class User < ApplicationRecord
    has_secure_password

    validates_presence_of :fullname, :username, :password_digest
    validates_uniqueness_of :username
end
