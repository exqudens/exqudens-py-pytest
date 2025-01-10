"""
exqudens_pytest module.
"""

__version__ = "7.3.1"

import sys

from application import Application

if __name__ == "__main__":
    arguments: list[str] = None
    if getattr(sys, "frozen") and hasattr(sys, "_MEIPASS"):
        arguments = sys.argv
    else:
        arguments = sys.argv[1:]
    application: Application = Application()
    exit_code: int = application.run(arguments)
    sys.exit(exit_code)
