import unittest
import os
import testLib

class TestExists(testLib.RestTestCase):
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testUserExists(self):
        respData = self.makeRequest("/users/add", method="POST", data={'user':'a', 'password':'a'})
        self.assertResponse(respData, 1, 1)
        respData = self.makeRequest("/users/add", method="POST", data={'user':'a', 'password':'a'})
        self.assertResponse(respData, None, -2)


class TestEmpty(testLib.RestTestCase):
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testEmptyNameWithNonEmptyPass(self):
        respData = self.makeRequest("/users/add", method="POST", data = {'user' : '', 'password' : 'a'} )
        self.assertResponse(respData, count = None, errCode = -3)
    def testEmptyNameWithEmptyPass(self):
        respData = self.makeRequest("/users/add", method="POST", data = {'user' : '', 'password' : ''} )
        self.assertResponse(respData, count = None, errCode = -3)
    def testEmptyNameWithNonemptyPassLogin(self):
        respData = self.makeRequest("/users/add", method="POST", data = {'user' : '', 'password' : 'a'})
        respData = self.makeRequest("/users/login", method="POST", data = {'user' : '', 'password' : 'a'})
        self.assertResponse(respData, count = None, errCode = -1)
    def testEmptyNameWithEmptyPassLogin(self):
        respData = self.makeRequest("/users/add", method="POST", data = {'user' : '', 'password' : ''})
        respData = self.makeRequest("/users/login", method="POST", data = {'user' : '', 'password' : ''})
        self.assertResponse(respData, count = None, errCode = -1)


class TestMax(testLib.RestTestCase):
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)
    def testNameLonger128(self):
        respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'b'*129, 'password' : 'a'})
        self.assertResponse(respData, count = None, errCode = -3)
    def testPassLonger128(self):
        respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'a', 'password' : 'b'*129})
        self.assertResponse(respData, count = None, errCode = -4)
    def testNameAndPassAt128(self):
        respData = self.makeRequest("/users/add", method="POST", data = {'user' : 'b'*128, 'password' : 'b'*128})
        self.assertResponse(respData, count = 1)


