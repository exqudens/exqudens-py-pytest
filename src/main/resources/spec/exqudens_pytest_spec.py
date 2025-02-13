import sys
from pathlib import Path

from PyInstaller.building.build_main import Analysis
from PyInstaller.building.api import PYZ, EXE, COLLECT

sys.path.append(Path.cwd().joinpath("src", "main", "resources", "spec").as_posix())

from spec_utils import SpecUtils

config: dict[str, any] = {
    "name": "exqudens-pytest",
    "strip": False,
    "upx": True
}
analysis: Analysis = Analysis(
    scripts=["src/main/py/exqudens/pytest/__init__.py"],
    pathex=["src/main/py"],
    datas=[],
    runtime_hooks=[],
    hiddenimports=SpecUtils.hidden_imports()
)
pyz: PYZ = PYZ(
    analysis.pure,
    analysis.zipped_data
)
exe: EXE = EXE(
    pyz,
    analysis.scripts,
    [
        #("v", None, "OPTION")
    ],
    exclude_binaries=True,
    name=config["name"],
    debug=False,
    strip=config["strip"],
    upx=config["upx"],
    console=False,
    uac_admin=False,
    contents_directory="_internal"
)
collect: COLLECT = COLLECT(
    exe,
    analysis.binaries,
    analysis.zipfiles,
    analysis.datas,
    strip=config["strip"],
    upx=config["upx"],
    name=config["name"]
)
