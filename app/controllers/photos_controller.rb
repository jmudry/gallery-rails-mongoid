class PhotosController < ApplicationController
  before_filter :set_per_page

  def index
    @album = Album.find params[:album_id]
    @photos = @album.photos.asc(:id).take(@per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  def crop
    @album = Album.find params[:album_id]
    @photo = @album.photos.find(params[:id])
  end

  def get_photos
    last_id = params[:last_id]
    @album = Album.find params[:album_id]

    @photos = @album.photos
    @photos = @photos.asc(:id)
    @photos = @photos.gt(id: last_id) if last_id and last_id != 'end'

    if @photos.empty? || params[:last_id] == 'end'
      new_last_id = "end"
    else
      new_last_id = @photos.last.id
    end

    @next_url = new_last_id == "end" ? "end" : get_album_photos_path(@album, {last_id: @photos.last.id, format: :json})

    respond_to do |format|
      format.json { render :json => {:url => @next_url,
                                     :html => render_to_string(:partial => "photos/photo", :collection => @photos)},
                           :layout => false }
    end
  end

  def new
    @album = Album.find params[:album_id]
    @photo = @album.photos.new
  end

  def show
    @album = Album.find params[:album_id]
    @photo = @album.photos.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end


  def edit
    @album = Album.find params[:album_id]
    @photo = @album.photos.find(params[:id])
  end

  def create
    @album = Album.find params[:album_id]
    @photo = @album.photos.create params[:photo]

    if @photo.save
      if params[:photo][:image].blank?
        flash[:notice] = 'Photo was successfully created.'
        redirect_to @album
      else
        render :action => "crop"
      end
    else
      render action: "new"
    end
  end

  def update
    @album = Album.find params[:album_id]
    @photo = @album.photos.find(params[:id])

    if @photo.update_attributes(params[:photo])
      if params[:photo][:image].blank?
        flash[:notice] = 'Photo was successfully updated.'
        redirect_to [@album, @photo]
      else
        render :action => "crop"
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @album = Album.find params[:album_id]
    @photo = @album.photos.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to album_photos_url @album }
      format.json { head :no_content }
    end
  end

  private

  def set_per_page
    @per_page = 15
  end
end
