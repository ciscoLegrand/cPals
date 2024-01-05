# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :conversations, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 50 }, allow_blank: true

  enum role: { user: 0, admin: 1 }
  validates :role, inclusion: { in: roles.keys }
end
