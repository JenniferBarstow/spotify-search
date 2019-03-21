class AddUserRefToSearchResults < ActiveRecord::Migration[5.2]
  def change
    add_reference :search_results, :user, foreign_key: true
  end
end
