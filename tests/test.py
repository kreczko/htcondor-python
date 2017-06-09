import unittest

class HTCondorTest(unittest.TestCase):

    def test_import(self):
        import htc
        from htc import htcondor
        from htc import classad
