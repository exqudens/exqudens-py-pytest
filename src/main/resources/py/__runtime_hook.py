"""
runtime_hook module.
"""

import os

from utils import Utils

Utils.import_modules(
    os.environ.get("PYTHONPATH", None)
)
