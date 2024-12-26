"""
utils module.
"""

import sys

from stdlib_list import stdlib_list

class SpecUtils:
    """
    SpecUtils class.
    """

    @classmethod
    def hidden_imports(cls) -> list[str]:
        result: list[str] = []
        version: str = f"{sys.version_info.major}.{sys.version_info.minor}"
        modules: list[str] = stdlib_list(version=version)
        for v in modules:
            module: str = str(v)
            if module.startswith("_"):
                if module != "__future__":
                    continue
            if module.startswith("lib2to3"):
                continue
            result.append(module)
        return result
