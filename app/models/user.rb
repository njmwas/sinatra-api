class User < ActiveRecord::Base
    has_one :member
    has_one :staff

    has_many :accounts, through: :member
end