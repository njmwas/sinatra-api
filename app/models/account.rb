class Account < ActiveRecord::Base
    has_many :members
    has_many :transactions
    has_many :loans
end