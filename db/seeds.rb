# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
include ApplicationHelper

my_user = User.where(email: "jairek@o2.pl").first


if !my_user.nil?
  motor_album = Album.new
  motor_album.name = "National Geographic"
  motor_album.user = my_user
  if motor_album.save

  motor_images =  get_image_with_directory "National_Geographic"

  motor_images.each{|x|
    photo = motor_album.photos.new
    photo.name = Populator.words(1)
    photo.description = Populator.sentences 1
    photo.image = File.open x.to_s

    if !photo.save
      p "dont't save"
    end
  }
  else
    p "Error create album"
  end

else
  p "Brak usera jairek@o2.pl"
end

