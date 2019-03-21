class AddAlbumUrlToSearchResults < ActiveRecord::Migration[5.2]
  def change
    add_column :search_results, :album_url, :string
  end
end
