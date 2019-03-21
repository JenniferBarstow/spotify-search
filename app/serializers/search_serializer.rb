class SearchSerializer < ActiveModel::Serializer
  belongs_to :user
  attributes :keyword
end