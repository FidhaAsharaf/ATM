class User < ApplicationRecord
  has_secure_password
  has_many :transactions, dependent: :destroy

  validates :email,
            presence: true,
            uniqueness: true
  # format: { with: URI::MailTo::EMAIL_REGEXP, message: "not in correct email format" }

  # Only require password if using normal signup
  validates :password,
            presence: true,
            # format: { with: /\A\d{4}\z/, message: "must be a 4-digit number" },
            on: :create,
            if: :password_required?

  def password_required?
    provider.blank?
  end
end
