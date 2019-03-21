class SessionsController < Devise::SessionsController
  protect_from_forgery prepend: true
  skip_before_action :verify_authenticity_token
  
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end
end