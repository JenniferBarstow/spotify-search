require 'rspotify'
class SearchesController < ApplicationController
  include PagyPaginatable

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

    unless (params[:search] && valid_date?(params[:search]))      
      render json: { error: "Please enter a valid year (1950-2019)" }, status: :unprocessable_entity
    else
      render json: current_user.search_results.where("release_date LIKE ?", "%#{params[:search]}%")
    end    
  end

  def create
    Search.create(user: current_user, keyword: params[:search])
    @search = RSpotify::Album.search(params[:search])
    render json: @searches, status: :ok
  end

  def user_searches
    @search_results = Rails.cache.fetch("user-#{current_user.id}-searches", expires_in: 10.minutes) do
      current_user.search_results
    end

    if params[:sort] == 'album_name'
      @search_results = @search_results.order(:album_name)
    end

    if params[:album].present?      
      @search_results = @search_results.where("album_name LIKE ?", "%#{params[:album]}%")
    end

    if params[:year].present?    
      @search_results = @search_results.where("release_date LIKE ?", "%#{params[:year]}%")
    end

    @pagy, @search_results  = pagy(@search_results)

    if (params[:year].present? && !valid_date?(params[:year]))
      render json: { error: "Please enter a valid year (1950-2019)" }, status: :unprocessable_entity
    else      
      render json: @search_results, status: :ok
    end
  end

  def destroy
    current_user.searches.where(keyword: params[:id]).delete_all
    current_user.search_results.where("release_date LIKE ?", "%#{params[:id]}%").delete_all
    render json: { status: :ok }
  end

  private

  def valid_date?(year)
    if year.scan(/\D/).empty? and (1950..2020).include?(year.to_i)
      true
    else
      false
    end
  end
end