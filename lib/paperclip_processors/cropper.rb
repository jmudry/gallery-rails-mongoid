module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      target = @attachment.instance
      if target.cropping?
        crop_command = [
            "-crop",
            "#{target.crop_w}x" \
            "#{target.crop_h}+" \
            "#{target.crop_x}+" \
            "#{target.crop_y}",
            "+repage"
        ]
        super_command = super.join(" ").sub(/\-crop.*\+repage/,"")
        crop_command << super_command
      else
        super
      end
    end
  end
end