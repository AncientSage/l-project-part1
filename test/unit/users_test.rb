require 'test_helper'

$SUCCESS=1
$ERR_BAD_CREDENTIALS=-1
$ERR_USER_EXISTS=-2
$ERR_BAD_USERNAME=-3
$ERR_BAD_PASSWORD=-4
$MAX_USERNAME_LENGTH=128
$MAX_PASSWORD_LENGTH=128


class UsersTest < ActiveSupport::TestCase
  

    test "adding new user" do
        Users.TESTAPI_resetFixture
        result = Users.add("a","a")
        assert result == $SUCCESS
    end

    test "adding nil username w/ non-nil password" do
        Users.TESTAPI_resetFixture
        result = Users.add("","a")
        assert result ==  $ERR_BAD_USERNAME
    end

    test "adding nil username w/ overlimit password" do
        Users.TESTAPI_resetFixture
        result = Users.add("","aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        assert result ==  $ERR_BAD_USERNAME
    end

    test "add duplicate user" do
        Users.TESTAPI_resetFixture
        assert Users.add("test","test") == $SUCCESS
        assert Users.add("test","testy") == $ERR_USER_EXISTS
    end

    test "increase login count" do
        Users.TESTAPI_resetFixture
        assert Users.add("a", "a") == 1
        assert Users.login("a", "a") == 2
    end

    test "adding overlimit username w/ non-nil password" do
        Users.TESTAPI_resetFixture
        result = Users.add("a"*129,"a")
        assert result ==  $ERR_BAD_USERNAME
    end

    test "adding non-nil username w/ overlimit password" do
        Users.TESTAPI_resetFixture
        result = Users.add("a","a"*129)
        assert result ==  $ERR_BAD_PASSWORD
    end

    test "failing password w/ correct username" do
        Users.TESTAPI_resetFixture
        Users.add("a", "a")
        assert Users.login("a", "b") == $ERR_BAD_CREDENTIALS
    end

    test "failing password w/ correct username that is nil" do
        Users.TESTAPI_resetFixture
        Users.add("a", "a")
        assert Users.login("a", "") == $ERR_BAD_CREDENTIALS
    end

    test "user does not exist" do
        Users.TESTAPI_resetFixture
        assert Users.login("a","a") == $ERR_BAD_CREDENTIALS
    end

end
