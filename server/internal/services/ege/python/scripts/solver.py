from enum import auto, Enum
import sys

_question_numbers_available = [24]

#check whether given question number can be solved
def check_available(number):
    return number in _question_numbers_available

class _TypeEnum(Enum):
    def __init__(self, num, desc = ""):
        self._number = num
        self._description = desc

    @property
    def number(self):
        return self._number

    @property 
    def description(self):
        return self._description

class Types_24(_TypeEnum):
    REPEATING_SAME = (1, "find the longest repeating string with the same letters")
    REPEATING_DIFF = (2, "find the longest repeating string with different letters")

def solve_24(file, type_):
    if type_ < 0 or type_ > len(Types_24):
        sys.stdout = sys.stderr
        print("There are no algorithm to solve question with given type.")
        print("Available types:")
        for t in Types_24:
            print(f"  {t.number} {t.description}")
        sys.exit(1)
    else:
        if type_ == 1:
            print(_solve_24_1(file))
        elif type_ == 2:
            print(_solve_24_2(file))

def _solve_24_1(file):
    data = file.read()
    if len(data) == 0:
        return 0
    curLen = 1
    maxLen = 0
    for i in range(1, len(data)):
        if data[i] == data[i - 1]:
            curLen += 1
        else:
            maxLen = max(maxLen, curLen)
            curLen = 1
    return max(maxLen, curLen)

def _solve_24_2(file):
    data = file.read()
    if len(data) == 0:
        return 0
    curLen = 1
    maxLen = 0
    for i in range(1, len(data)):
        if data[i] != data[i - 1]:
            curLen += 1
        else:
            maxLen = max(maxLen, curLen)
            curLen = 1
    return max(maxLen, curLen)
