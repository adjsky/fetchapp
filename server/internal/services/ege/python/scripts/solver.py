from enum import Enum
from scripts.util import fatal

_question_numbers_available = [24]


# check whether a given question number can be solved
def check_available(number):
    return number in _question_numbers_available


def get_available():
    return _question_numbers_available


class _TypeEnum(Enum):
    def __init__(self, num, desc=""):
        self._number = num
        self._description = desc

    @property
    def number(self):
        return self._number

    @property
    def description(self):
        return self._description


class Types_24(_TypeEnum):
    REPEATING_SAME = (1, "find the longest repeating substring with the same letters")
    REPEATING_DIFF = (2, "find the longest repeating substring with different letters")
    REPEATING_SAME_LETTER = (3, "find the longest repeating substring with the same given letter")


def solve_24(file_, type_, char):
    if type_ < 0 or type_ > len(Types_24):
        message = "There are no algorithm available to solve question with a given type.\nAvailable types:"
        for t in Types_24:
            message += f"  {t.number} {t.description}\n"
        fatal(message[0:-1])  # trim endline character
    else:
        if file_ is None:
            fatal("No file was provided.")
        if type_ == 1:
            print(_solve_24_1(file_))
        elif type_ == 2:
            print(_solve_24_2(file_))
        elif type_ == 3:
            if char is None or char == "":
                fatal("No character to count was provided.")
            print(_solve_24_3(file_, char))


def _solve_24_1(file_):
    data = file_.read()
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


def _solve_24_2(file_):
    data = file_.read()
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


def _solve_24_3(file_, char):
    data = file_.read()
    curLen = 0
    maxLen = 0
    for c in data:
        if c == char:
            curLen += 1
        else:
            maxLen = max(maxLen, curLen)
            curLen = 0
    return max(maxLen, curLen)
