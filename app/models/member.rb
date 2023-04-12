class Member < ActiveRecord::Base
    has_one :user
    belongs_to :user
    has_many :accounts

    has_many :transactions, through: :accounts
end