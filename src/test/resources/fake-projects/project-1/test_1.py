from util.convert_utils import ConvertUtils

class Test1:

    def test_1(self) -> None:
        expected: int = 1
        actual: int = ConvertUtils.str_to_int("1")
        assert expected == actual
        return None
