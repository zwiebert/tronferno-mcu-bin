import sys

is_windows = False


def _find_getch():
    """
    Return getch() function of user's terminal
    """
    try:
        import termios
    except ImportError:
        # Non-POSIX. Return msvcrt's (Windows') getch.
        import msvcrt
        global is_windows
        is_windows = True
        return msvcrt.getch

    # POSIX system. Create and return a getch that manipulates the tty.
    import tty

    def _getch():
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(fd)
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch

    return _getch


our_getch = _find_getch()


def getch():
    """return one char string"""
    # print("Press [key]: ")
    c = our_getch()
    try:
        return c.decode()
    except:
        return c
