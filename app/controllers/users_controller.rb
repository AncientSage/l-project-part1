$SUCCESS=1
$ERR_BAD_CREDENTIALS=-1
$ERR_USER_EXISTS=-2
$ERR_BAD_USERNAME=-3
$ERR_BAD_PASSWORD=-4
$MAX_USERNAME_LENGTH=128
$MAX_PASSWORD_LENGTH=128

class UsersController < ApplicationController

    def home
    end

    def login
        result = Users.login(params[:user],params[:password])
        if result < 0
            render json: {errCode: result}
        else
            render json: {errCode: $SUCCESS, count:result}
        end
    end

    def add
        result = Users.add(params[:user],params[:password])
        if result < 0
            render json: {errCode: result}
        else
            render json: {errCode: $SUCCESS, count:result}
        end
    end

    def resetFixture
        result = Users.TESTAPI_resetFixture
        render json: {errCode: result}
    end
    
    def unitTests
        begin
            system("rake test > convert.txt")
            f = File.new("convert.txt", "r")
            d = f.readlines
            f.close()
            f2 = File.new("convert.txt","r")
            output = f2.read
            f2.close()
            totalT = Integer(d[-1].split(",")[0].split(" ")[0])
            totalF = Integer(d[-1].split(",")[-2].split(" ")[0]) + Integer(d[-1].split(",")[-3].split(" ")[0])
                render json: {totalTests: totalT, nrFailed: totalF, output: output}
            rescue 
                render json: {output: "An error has occurred."}, status: 500 
        end
    end
end
