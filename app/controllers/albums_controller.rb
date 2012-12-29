class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(params[:album])
    @album.user = current_user
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "new" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.json
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

  # DELETE /albums/1
  # DELETE /albums/1.json
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
    @photo = Photo.find(params[:id])
    @which = params[:which]
    photos = @album.photos.order("id ASC")
    count_all = photos.count
    @prev = false
    @next = false

    if @which == "random"
      first_photo = photos.first
      last_photo = photos.last
      photos = photos.where("id != ?", @photo.id)
      photos.shuffle!
      res_photo = photos.first
      @prev = true if first_photo.id != res_photo.id
      @next = true if last_photo.id != res_photo.id
    else
      if @which == "prev"
        photos = photos.where("id < ?", @photo.id)
        photos.reverse!
        @prev = true if  photos.count > 1
        @next = true
      elsif @which == "next"
        photos = photos.where("id > ?", @photo.id)
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

    end
    res_photo = photos.first
    respond_to do |format|
      format.json { render :json => {
          which: @which,
          prev: @prev,
          next: @next,
          photo_id:  !res_photo.nil? ? res_photo.id : "nil",
          src: !res_photo.nil? ? res_photo.image.url : "" } }
    end
  end

end
