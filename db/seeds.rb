include ApplicationHelper

# Ustawiamy usera
user_email = "jairek@o2.pl"
album_name = "Moto Wallpapers"  #nazwa naszego albumu
album_directory_name = "moto_wallpapers" # katalog o takiej nazwie powienien znaleźć się w katalogu public/
rand_days = 20 #do losowania daty

my_user = User.where(email: user_email ).first


if !my_user.nil?
  album = Album.new
  album.name = album_name
  album.user = my_user
  if album.save

  files =  get_image_with_directory album_directory_name

  files.each{|x|
    photo = album.photos.new
    photo.name = Populator.words(1)
    photo.description = Populator.sentences 1
    photo.image = File.open x.to_s

    if !photo.save
      p "don't save photo"
    else
      photo.image_updated_at = Time.now - rand(rand_days).days #random specjalnie do wykresu
      photo.save
    end
  }
  else
    p "Error create album"
  end

else
  p "User not found"
end

