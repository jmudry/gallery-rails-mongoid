include ApplicationHelper

my_user = User.new
# Ustawiamy usera
my_user.email = "admin@example.com"
my_user.password = "adminadmin"
my_user.save

album_name = "Example"  #nazwa naszego albumu
album_directory_name = "example_photos" # katalog o takiej nazwie powienien znaleźć się w katalogu public/
rand_days = 20 #do losowania daty

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

