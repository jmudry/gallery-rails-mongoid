class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name

 # embedded_in :user
  belongs_to :user
  embeds_many :photos
  attr_accessible :name

  validates :name, :presence => true, :uniqueness => true, :length => {:in => 2..30}

end
