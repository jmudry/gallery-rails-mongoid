class PhotosController < ApplicationController
  before_filter :set_per_page


  def index
    @photos = Photo.order("id ASC").limit(@per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  def crop
    @photo = Photo.find(params[:id])
  end

  def get_photos
    last_id = params[:last_id]
    @photos = Photo
    @photos = @photos.where(album_id: params[:album_id]) if !params[:album_id].nil?
    @photos = @photos.order("id ASC")

    if last_id and last_id != 'end'
      @photos = @photos.where("id > ?", last_id)
    end

    @photos = @photos.limit(@per_page)

    if @photos.empty? || params[:last_id] == 'end'
      new_last_id = "end"
    else
      new_last_id = @photos.last.id
    end
    if !params[:album_id].nil?

      @next_url = new_last_id == "end" ? "end" : get_album_photos_path(Album.find(params[:album_id]), {last_id: @photos.last.id, format: :json})
    else
      @next_url = new_last_id == "end" ? "end" : get_next_photos_path({last_id: @photos.last.id, format: :json})
    end

    respond_to do |format|
      format.json { render :json => {:url => @next_url,
                                     :html => render_to_string(:partial => "photos/photo", :collection => @photos)},
                           :layout => false }
    end
  end

  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def create
    @photo = Photo.new(params[:photo])

    if @photo.save
      if params[:photo][:image].blank?
        flash[:notice] = 'Photo was successfully created.'
        redirect_to @photo
      else
        render :action => "crop"
      end
    else
      render action: "new"
    end
  end

  def update
    @photo = Photo.find(params[:id])

    if @photo.update_attributes(params[:photo])
      if params[:photo][:image].blank?
        flash[:notice] = 'Photo was successfully updated.'
        redirect_to @photo
      else
        render :action => "crop"
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  private

  def set_per_page
    @per_page = 15
  end
end
