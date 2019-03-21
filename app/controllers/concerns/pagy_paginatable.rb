# frozen_string_literal: true

module PagyPaginatable
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
    rescue_from Pagy::OverflowError, with: :render_pagy_exception_message
  end

  private

    def render_pagy_exception_message(exception)
      render json: { error: exception.message }, status: :not_found
    end
end