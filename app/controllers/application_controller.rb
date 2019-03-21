class ApplicationController < ActionController::API
  include Pagy::Backend
  protect_from_forgery prepend: true
  skip_before_action :verify_authenticity_token
end
