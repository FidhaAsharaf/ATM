class User < ApplicationRecord
  has_secure_password
  has_many :transactions
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, format: { with: /\A\d{4}\z/, message: "must be a 4-digit number" }, on: :create
end
