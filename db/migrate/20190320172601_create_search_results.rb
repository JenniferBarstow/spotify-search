class CreateSearchResults < ActiveRecord::Migration[5.2]
  def change
    create_table :search_results do |t|
      t.string :release_date
      t.string :album_name

      t.timestamps
    end
  end
end
