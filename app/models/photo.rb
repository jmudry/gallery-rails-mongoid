class Photo < ActiveRecord::Base
  belongs_to :album
  attr_accessible :description, :name, :image_content_type, :image_file_name, :image_file_size, :image_updated_at, :album_id, :image


  has_attached_file :image, :styles => {
      :thumb  => "32x32#",
      :small => "100x100#"
  },
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"

  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
end
