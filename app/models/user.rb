class User < ApplicationRecord
  devise :database_authenticatable, :jwt_authenticatable, :registerable, jwt_revocation_strategy: JWTBlacklist
  has_many :searches
  has_many :search_results
end
