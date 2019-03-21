require 'rspotify'
class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:search].present?
      Search.find_or_create_by(user: current_user, keyword: params[:search])

      @albums = RSpotify::Album.search("year:#{params[:search]}", limit: 50)
      if params[:sort] == 'name'
        @albums = @albums.sort { |a, b|  a.name.upcase <=> b.name.upcase }
      end

      if params[:artist].present?
        @albums = @albums.select { |a|  a.artists.map(&:name).join(", ").include? params[:artist] }
      end

    else
      @albums = []
    end

    @albums.each do |album|
      SearchResult.find_or_create_by(
        release_date: album.release_date,
        album_name: album.name,
        album_url: album.external_urls["spotify"],
        user: current_user
      )
    end
    unless (params[:search] && valid_date?)
      render json: { error: "Please enter a valid year (1950-2019)", status: :unprocessable_entity }
    else
      render json: current_user.search_results
    end
    @pagy_a, @albums = pagy_array(@albums)
  end

  def user_searches
    @searches = Rails.cache.fetch("user-#{User.last.id}-searches", expires_in: 10.minutes) do
      current_user.search_results
    end

    if params[:sort] == 'album_name'
      @searches = @searches.order(:album_name)
    end

    if params[:album].present?      
      @searches = @searches.where("album_name LIKE ?", "%#{params[:album]}%")
    end

    render json: @searches, status: :ok
  end

  def create
    Search.create(user: current_user, keyword: params[:search])
    @search = RSpotify::Album.search(params[:search])
    render json: @searches, status: :ok
  end

  def destroy
    Search.where(keyword: params[:id]).destroy_all
    render json: { status: :ok }
  end

  private

  def valid_date?
    if params[:search].scan(/\D/).empty? and (1950..2020).include?(params[:search].to_i)
      true
    else
      false
    end
  end
end