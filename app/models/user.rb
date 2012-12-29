class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :slug
  validate :name, :presence => true
  extend FriendlyId
  friendly_id :name, use: :slugged
end
