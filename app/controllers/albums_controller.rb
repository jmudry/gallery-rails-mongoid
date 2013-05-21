class AlbumsController < ApplicationController
  def index
    @albums = Album.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @album }
    end
  end

  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  def edit
    @album = Album.find(params[:id])
    @photos = @album.photos.asc(:id).take(15)

  end

  def create
    @album = Album.new(params[:album])
    @album.user = current_user
    respond_to do |format|
      if @album.save
        format.html { redirect_to albums_url, notice: 'Album was successfully created.' }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "new" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end

  def get_photo
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    @which = params[:which]
    photos = @album.photos.asc(:id)
    count_all = photos.count
    @prev = false
    @next = false

    if @which == "random"
      first_photo = photos.first
      last_photo = photos.last
      photos = photos.ne(id: @photo.id)
      res_photo = photos.sample
      @prev = true if first_photo.id != res_photo.id
      @next = true if last_photo.id != res_photo.id
    else
      if @which == "prev"
        photos = photos.lt(id: @photo.id).desc(:id)
        @prev = true if  photos.count > 1
        @next = true
      elsif @which == "next"
        photos = photos.gt(id: @photo.id)
        @prev = true
        @next = true if  photos.count > 1
      elsif @which == "first"
        @prev = false
        @next = true if count_all > 0
      elsif @which == "last"
        photos.reverse!
        @prev = true if count_all > 0
        @next = false
      end
      res_photo = photos.first
    end

    respond_to do |format|
      format.json { render :json => {
          which: @which,
          prev: @prev,
          next: @next,
          :photo => {
              src: !res_photo.nil? ? res_photo.image(:medium) : "",
              id: !res_photo.nil? ? res_photo.id : "nil",
              description: !res_photo.nil? ? !res_photo.description.nil? ? res_photo.description : "" : ""
          }
        }
      }
    end
  end

end
