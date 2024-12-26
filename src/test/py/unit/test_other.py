"""
test_other module.
"""

from util.convert_utils import ConvertUtils

class TestOther:
    """
    TestOther class.
    """

    def test_1(self) -> None:
        expected: int = 1
        actual: int = ConvertUtils.str_to_int("1")
        assert expected == actual
        return None

    def test_2(self) -> None:
        return None
