class SearchResultSerializer < ActiveModel::Serializer
  attributes :release_date, :album_name, :album_url
end