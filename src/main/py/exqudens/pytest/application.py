"""
application module.
"""

import pytest

from plugin import Plugin

class Application:
    """
    Application class.
    """

    @classmethod
    def run(cls, arguments: list[str]) -> int:
        """
        run method.
        """
        exit_code: int = 0

        if not arguments:
            return exit_code

        if len(arguments) > 1:
            exit_code = pytest.main(args=arguments[1:], plugins=[Plugin()])

        return exit_code
