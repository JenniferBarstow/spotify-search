require 'rspotify'
class SearchesController < ApplicationController
  include PagyPaginatable

  before_action :authenticate_user!

  def index
    @albums = if params[:year].present?
      Search.find_or_create_by(user: current_user, keyword: params[:year])
      RSpotify::Album.search("year:#{params[:year]}", limit: 50)
    else
      []
    end

    create_search_results
    @search_results = current_user.search_results
    apply_filters
    @pagy, @search_results  = pagy(@search_results)

    if !(params[:year] && valid_date?(params[:year]))
      render json: { error: "Please enter a valid year (1950-2019)" }, status: :unprocessable_entity
    else
      render json: @search_results, status: :ok
    end
  end

  def create
    Search.create(user: current_user, keyword: params[:search])
    @search = RSpotify::Album.search(params[:search])
    render json: @searches, status: :ok
  end

  def user_searches
    @search_results = Rails.cache.fetch(current_user.search_results, expires_in: 60.minutes) do
      current_user.search_results
    end

    apply_filters
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

  def apply_filters
    sort_by_album
    filter_by_album
    filter_by_year
  end

  def create_search_results 
    @albums.each do |album|
      SearchResult.find_or_create_by(
        release_date: album.release_date,
        album_name: album.name,
        album_url: album.external_urls["spotify"],
        user: current_user
      )
    end
  end

  def valid_date?(year)
    if year.scan(/\D/).empty? and (1950..2020).include?(year.to_i)
      true
    else
      false
    end
  end

  def sort_by_album
    if params[:sort] == 'album_name'
      @search_results = @search_results.order(:album_name)
    end
  end

  def filter_by_album
    if params[:album].present?
      @search_results = @search_results.where("album_name LIKE ?", "%#{params[:album]}%")
    end
  end

  def filter_by_year
    if params[:year].present?
      @search_results = @search_results.where("release_date LIKE ?", "%#{params[:year]}%")
    end
  end
end