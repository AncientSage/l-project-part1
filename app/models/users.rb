$SUCCESS=1
$ERR_BAD_CREDENTIALS=-1
$ERR_USER_EXISTS=-2
$ERR_BAD_USERNAME=-3
$ERR_BAD_PASSWORD=-4
$MAX_USERNAME_LENGTH=128
$MAX_PASSWORD_LENGTH=128

class Users < ActiveRecord::Base
    
    def self.login(u,p)
        row = Users.find_by(username: u)
        if row
            not_empty=true
            pass_match=(row.password==p)
        end
        if not_empty && pass_match
            row.update_attribute(:count, row.count+1)
            return row.count
        else
            return $ERR_BAD_CREDENTIALS
        end
    end


    def self.add(u,p)
        limit = 128
        if Users.exists?(username: u)
            return $ERR_USER_EXISTS
        elsif u.to_s == "" || u.length > limit
            return $ERR_BAD_USERNAME
        elsif p.to_s == "" || p.length > limit
            return $ERR_BAD_PASSWORD
        else
            user = Users.new(username: u, password: p, count: 1)
            user.save
            return user.count
        end
    end

    def self.TESTAPI_resetFixture
        Users.delete_all
        return $SUCCESS
    end

end
