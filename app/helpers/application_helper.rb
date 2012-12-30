module ApplicationHelper

  def get_image_with_directory(directory)
    files = []

    path = "public/" + directory + "/*.{jpg,png,gif}"
    @files_in_directory = Dir.glob(path)
    for file in @files_in_directory
      files << file
    end

    files
  end


end
