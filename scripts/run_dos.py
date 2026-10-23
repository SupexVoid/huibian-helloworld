"""Execute the real DOS binaries in DOSBox and save unmodified redirected output."""
import argparse
import datetime
import os
from pathlib import Path
import shutil
import subprocess
import uuid

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dosbox", type=Path, required=True)
    args = parser.parse_args()
    dosbox = args.dosbox.resolve()
    stage = ROOT / ".run" / (datetime.datetime.now().strftime("%Y%m%d-%H%M%S") + "-" + uuid.uuid4().hex[:6])
    stage.mkdir(parents=True)
    commands = ["@echo off"]
    captures = []
    jobs = [
        ("01_hello_world", "hello", "exe", "hello.txt"),
        ("01_hello_world", "helloe", "com", "helloe.txt"),
        ("02_ascii_table", "ascloop", "exe", "ascloop.txt"),
        ("02_ascii_table", "ascjump", "exe", "ascjump.txt"),
        ("02_ascii_table", "ascii_c", "exe", "ascii_c.txt"),
        ("03_sum", "sumreg", "exe", "sumreg.txt"),
        ("03_sum", "sumdata", "exe", "sumdata.txt"),
        ("03_sum", "sumstack", "exe", "sumstack.txt"),
        ("03_sum", "sum_c", "exe", "sum_c.txt"),
        ("04_multiplication", "mult", "exe", "mult.txt"),
        ("04_multiplication", "mult_c", "exe", "mult_c.txt"),
    ]
    for folder, stem, ext, result in jobs:
        shutil.copyfile(ROOT / folder / "bin" / f"{stem}.{ext}", stage / f"{stem}.{ext}")
        commands.append(f"{stem}.{ext} > {result}")
        captures.append((stage / result, ROOT / folder / "results" / result))
    shutil.copyfile(ROOT / "03_sum/bin/sumn.exe", stage / "sumn.exe")
    cases = [(f"n{n:03d}", str(n), f"input_{n:03d}.txt") for n in range(1, 101)]
    invalid = {"empty": "", "zero": "0", "negative": "-1", "large": "101",
               "letters": "abc", "mixed": "1a", "long": "99999999999999999999", "spaces": " 10"}
    cases += [(f"bad{i}", value + "\r\n10", "invalid_" + name + ".txt")
              for i, (name, value) in enumerate(invalid.items())]
    for short, value, result in cases:
        (stage / (short + ".in")).write_bytes((value + "\r\n").encode("ascii"))
        commands.append(f"sumn < {short}.in > {short}.txt")
        captures.append((stage / (short + ".txt"), ROOT / "03_sum/results" / result))
    commands += ["echo DONE > done.txt", "exit"]
    (stage / "run.bat").write_bytes(("\r\n".join(commands) + "\r\n").encode("ascii"))
    env = os.environ.copy()
    env.update(SDL_VIDEODRIVER="dummy", SDL_AUDIODRIVER="dummy", SDL_RENDER_DRIVER="software")
    startup = None
    if os.name == "nt":
        startup = subprocess.STARTUPINFO()
        startup.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        startup.wShowWindow = 0
    proc = subprocess.run([str(dosbox), "--noprimaryconf", "--nolocalconf", "--set", "output=texture",
                           "--set", "core=normal", "--set", "cpu_cycles=max", str(stage / "run.bat")],
                          cwd=stage, env=env, startupinfo=startup,
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=90)
    log = proc.stdout.decode("utf-8", errors="replace")
    for path, replacement in ((str(ROOT), "$REPO"), (str(dosbox), "$DOSBOX"),
                              (str(dosbox.parent), "$DOSBOX_DIR")):
        log = log.replace(path.replace("\\", "\\\\"), replacement).replace(path, replacement)
    (ROOT / "DOSBOX_LOG.txt").write_text(log, encoding="utf-8")
    if proc.returncode or not (stage / "done.txt").exists():
        raise RuntimeError(f"DOSBox did not finish: exit {proc.returncode}\n{log}")
    for source, dest in captures:
        if not source.is_file():
            raise RuntimeError("Missing DOS output: " + str(source))
        dest.parent.mkdir(exist_ok=True)
        shutil.copyfile(source, dest)
    print(f"Captured {len(captures)} real DOS program runs.")
    subprocess.run([os.sys.executable, str(ROOT / "scripts/verify.py")], check=True)


if __name__ == "__main__":
    main()
