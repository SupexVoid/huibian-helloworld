"""Check captured DOS program output against the assignment requirements."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]


def output(folder, name):
    return (ROOT / folder / "results" / name).read_text(encoding="ascii").replace("\r", "")


class AssignmentOutputTests(unittest.TestCase):
    def test_hello_exe(self):
        self.assertEqual(output("01_hello_world", "hello.txt"), "Hello, World!\n")

    def test_debug_entered_com(self):
        self.assertEqual(output("01_hello_world", "helloe.txt"), "Hello, World!\n")

    def test_ascii_loop_and_conditional_and_c(self):
        expected = "a b c d e f g h i j k l m\nn o p q r s t u v w x y z\n"
        for name in ("ascloop.txt", "ascjump.txt", "ascii_c.txt"):
            with self.subTest(name=name):
                self.assertEqual(output("02_ascii_table", name), expected)

    def test_sum_storage_variants_and_c(self):
        for name in ("sumreg.txt", "sumdata.txt", "sumstack.txt", "sum_c.txt"):
            with self.subTest(name=name):
                self.assertEqual(output("03_sum", name), "5050\n")

    def test_all_one_hundred_input_values(self):
        for n in range(1, 101):
            with self.subTest(n=n):
                text = output("03_sum", f"input_{n:03d}.txt")
                actual = re.search(r"Sum = (\d+)", text)
                self.assertIsNotNone(actual, text)
                self.assertEqual(int(actual[1]), n * (n + 1) // 2)

    def test_invalid_input_retries_without_overflow(self):
        for name in ("empty", "zero", "negative", "large", "letters", "mixed", "long", "spaces"):
            with self.subTest(name=name):
                text = output("03_sum", f"invalid_{name}.txt")
                self.assertIn("Invalid input", text)
                self.assertRegex(text, r"Sum = 55(?:\n|$)")

    def test_multiplication_assembly_and_c(self):
        for name in ("mult.txt", "mult_c.txt"):
            with self.subTest(name=name):
                lines = output("04_multiplication", name).splitlines()
                self.assertEqual(lines[0], "The 9mul9 table:")
                self.assertEqual(len(lines), 10)
                terms = []
                for row, line in zip(range(9, 0, -1), lines[1:]):
                    cells = re.findall(r"(\d)\*(\d)=(\d+)", line)
                    self.assertEqual(len(cells), row)
                    for col, (a, b, product) in enumerate(cells, 1):
                        self.assertEqual((int(a), int(b), int(product)), (row, col, row * col))
                    terms.extend(cells)
                self.assertEqual(len(terms), 45)


if __name__ == "__main__":
    unittest.main(verbosity=2)
