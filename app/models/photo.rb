class Photo < ActiveRecord::Base
  belongs_to :album
  attr_accessible :description, :name, :image_content_type, :image_file_name, :image_file_size, :image_updated_at, :album_id, :image,
                  :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_image, :if => :cropping?
  has_attached_file :image, :styles => {
      :thumb  => "32x32",
      :small => "100x100",
      :medium => "600x500"
  },
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename",
  :processors => [:cropper]

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end

  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']

  private
  def reprocess_image
    image.reprocess!
  end

end
