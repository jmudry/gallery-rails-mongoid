class Album < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name

  has_many :photos, :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true, :length => {:in => 2..30}

end
