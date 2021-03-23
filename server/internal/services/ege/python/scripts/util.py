import sys


def fatal(message):
    sys.stdout = sys.stderr
    print(message)
    sys.exit(1)
