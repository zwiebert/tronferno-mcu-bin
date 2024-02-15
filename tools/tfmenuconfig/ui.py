import sys
import os
import sys


from .getch import getch, is_windows

def press_enter():
    """
    wait for enter key before continue to let the user loog at the command output
    """
    input("\n<press enter to continue>")


def ask_yes_no(question):
    print("\n#### "+question+" (y/n)")
    c = getch()
    if (c == "y"):
        return True
    return False


def clear_screen():
    os.system('cls' if is_windows else 'clear')


def write_point(): sys.stdout.write('.'); sys.stdout.flush()
