class User < ApplicationRecord
    has_secure_password
  
    validates :email, presence: true, uniqueness: true
    validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/, message: "Must be a valid email address"
    validates :name, presence: true
    validates :password, length: { minimum: 6, maximum: 20 }, if: -> { password.present? }
  end
  