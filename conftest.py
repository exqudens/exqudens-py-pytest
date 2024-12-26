import json
from pathlib import Path
from typing import Union, Mapping

from pytest import Parser, PytestPluginManager, OptionGroup, Session, CollectReport, TestReport, Config

def pytest_addoption(
    parser: Parser,
    pluginmanager: PytestPluginManager
) -> None:
    group: OptionGroup = parser.getgroup("conftest-extensions")
    group.addoption("--conftest-collect-file", action="store", default=False, help="Saves collected test items to json file.")
    group.addoption("--conftest-report-file", action="store", default=False, help="Append test events to file in json format.")
    return None

def pytest_collection_finish(
    session: Session
) -> None:
    file: str | None = session.config.getoption("--conftest-collect-file")
    if file:
        entries: list[dict[str, any]] = []
        for item in session.items:
            entry: dict[str, any] = {
                "nodeid": str(item.nodeid)
            }
            entries.append(entry)
        content: str = json.dumps(entries, indent=4)
        data: bytes = content.encode()
        Path(file).parent.mkdir(parents=True, exist_ok=True)
        Path(file).write_bytes(data=data)
    return None

def pytest_report_teststatus(
    report: Union[CollectReport, TestReport],
    config: Config
) -> None | tuple[str, str, Union[str, Mapping[str, bool]]]:
    file: str | None = config.getoption("--conftest-report-file")
    if file:
        entry: dict[str, any] = {
            "nodeid": str(report.nodeid) if report.nodeid else None,
            "filesystempath": str(report.location[0]) if report.location and report.location[0] else None,
            "line": int(report.location[1]) if report.location and report.location[1] else None,
            "domaininfo": str(report.location[2]) if report.location and report.location[2] else None,
            "when": str(report.when) if report.when else None,
            "passed": True if report.passed else False,
            "failed": True if report.failed else False,
            "skipped": True if report.skipped else False
        }
        content: str = json.dumps(entry) + "\n"
        data: bytes = content.encode()
        Path(file).parent.mkdir(parents=True, exist_ok=True)
        with open(file, "ab") as stream:
            stream.write(data)
    return None
