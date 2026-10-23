"""Build 8086 DOS EXEs with the official Open Watcom V2 toolchain."""
import argparse
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
FOLDERS = ("01_hello_world", "02_ascii_table", "03_sum", "04_multiplication")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--watcom", type=Path, required=True)
    args = parser.parse_args()
    watcom = args.watcom.resolve()
    tools = watcom / ("binnt64" if (watcom / "binnt64").exists() else "binnt")
    env = os.environ.copy()
    env.update(WATCOM=str(watcom), INCLUDE=str(watcom / "h"))
    env["PATH"] = str(tools) + os.pathsep + str(watcom / "binnt") + os.pathsep + env["PATH"]
    log = []

    def run(argv, cwd):
        result = subprocess.run([str(x) for x in argv], cwd=cwd, env=env,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        text = result.stdout.decode("utf-8", errors="replace")
        log.append("$ " + " ".join(str(x).replace(str(watcom), "$WATCOM").replace(str(ROOT), "$REPO") for x in argv))
        log.append(text)
        if result.returncode:
            raise RuntimeError(text)

    for folder in FOLDERS:
        base = ROOT / folder
        for sub in ("bin", "results", ".build"):
            (base / sub).mkdir(exist_ok=True)
        for src in sorted((base / "src").glob("*.asm")):
            stem = src.stem
            obj = Path("../.build") / (stem + ".obj")
            run([tools / "wasm.exe", "-q", "-0", "-fo=" + str(obj), src.name], src.parent)
            run([tools / "wlink.exe", "system", "dos", "option", "quiet", "name",
                 "../bin/" + stem + ".exe", "file", obj], src.parent)
            run([tools / "wdis.exe", "-l=../results/" + stem + ".disasm.txt", obj], src.parent)
            listing = base / "results" / (stem + ".disasm.txt")
            text = listing.read_text(encoding="utf-8").replace(str(src.resolve()), src.name)
            listing.write_text(text, encoding="utf-8")
            print("Built", folder + "/bin/" + stem + ".exe", flush=True)
        for src in sorted((base / "src").glob("*.c")):
            stem = src.stem + "_c"
            obj = Path("../.build") / (stem + ".obj")
            run([tools / "wcc.exe", "-q", "-0", "-ms", "-od", "-d2", "-bt=dos",
                 "-fo=" + str(obj), src.name], src.parent)
            run([tools / "wlink.exe", "system", "dos", "option", "quiet", "name",
                 "../bin/" + stem + ".exe", "file", obj], src.parent)
            run([tools / "wdis.exe", "-l=../results/" + stem + ".disasm.txt", obj], src.parent)
            run([tools / "wdis.exe", "-a", "-l=../results/" + stem + ".generated.asm", obj], src.parent)
            # The homework examines instructions/constants, not DWARF metadata.
            # Omit debug sections containing local build paths; retain code verbatim.
            listing = base / "results" / (stem + ".disasm.txt")
            text = listing.read_text(encoding="utf-8")
            text = text.split("Segment: .debug_info", 1)[0]
            text = text.replace(str(src.resolve()), src.name)
            listing.write_text(text, encoding="utf-8")
            generated = base / "results" / (stem + ".generated.asm")
            text = generated.read_text(encoding="utf-8")
            text = text.split("`.debug_info`", 1)[0].rstrip() + "\n\t\tEND\n"
            generated.write_text(text, encoding="utf-8")
            print("Built", folder + "/bin/" + stem + ".exe", flush=True)
    (ROOT / "BUILD_LOG.txt").write_text("\n".join(log), encoding="utf-8")


if __name__ == "__main__":
    main()
