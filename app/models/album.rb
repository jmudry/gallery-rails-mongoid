class Album < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name

  has_many :photos
end
