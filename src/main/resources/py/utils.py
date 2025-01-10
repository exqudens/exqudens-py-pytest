"""
utils module.
"""

import os
from pathlib import Path

from _pytest.pathlib import import_path

class Utils:
    """
    Utils class.
    """

    @classmethod
    def import_modules(cls, path: str | None) -> None:
        if not path:
            return None

        path_strip: str = path.strip()
        path_split: list[str] = path_strip.split(os.pathsep) if len(path_strip) > 0 else []
        dir_files: dict[str, list[str]] = {}

        for i, v in enumerate(path_split):
            if v is None:
                raise Exception(f"'path[{i}]' is none")

            if len(v) == 0:
                raise Exception(f"'path[{i}]' is empty")

            if ".." in Path(v).parts:
                raise Exception(f"'..' unsupported in 'path[{i}]': '{v}'")

            dir: str = Path.cwd().as_posix() if v == "." else Path(v).as_posix()

            if not Path(dir).is_absolute():
                dir = Path.cwd().joinpath(v).as_posix()

            if not Path(dir).exists():
                raise Exception(f"not exists 'path[{i}]': '{v}'")

            if dir in dir_files:
                continue

            files: list[str] = cls.list_module_files(dir=dir)
            dir_files[dir] = files

        first: bool = True
        one_success: bool = False
        last_exception: Exception | None = None

        while len(dir_files) > 0 and (first or one_success):
            if first:
                first = False

            dir_files_copy: dict[str, list[str]] = dir_files.copy()
            dir_files.clear()

            one_success = False

            for dir in dir_files_copy:
                for file in dir_files_copy[dir]:
                    try:
                        import_path(
                            file,
                            mode="importlib",
                            root=Path(dir),
                            consider_namespace_packages=False
                        )
                        one_success = True
                        last_exception = None
                    except Exception as e:
                        if dir not in dir_files:
                            dir_files[dir] = []
                        dir_files[dir].append(file)
                        last_exception = e

        if last_exception is not None:
            raise last_exception

        return None

    @classmethod
    def list_module_files(cls, dir: str | None) -> list[str]:
        if dir is None:
            raise Exception(f"'dir' is none")

        if len(dir) == 0:
            raise Exception(f"'dir' is empty")

        result: list[str] = []

        for v in Path(dir).rglob("**/*.py"):
            if v.name.startswith("__") and v.name != "__init__.py":
                continue
            result.append(v.as_posix())

        return result
