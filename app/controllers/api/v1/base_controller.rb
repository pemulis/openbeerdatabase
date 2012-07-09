class Api::V1::BaseController < ApplicationController
  before_filter :authenticate,          only:   [:create, :update, :destroy]
  before_filter :validate_format,       except: [:destroy]
  before_filter :validate_query_length, only:   [:index]

  skip_before_filter :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  protected

  def access_denied
    head :unauthorized
  end

  def authorized_for?(record)
    signed_in? && current_user.can_access?(record)
  end

  def validate_format
    head(:not_acceptable) unless request.format.json?
  end

  def validate_query_length
    query = params[:query].to_s.strip

    if query.present? && query.length == 1
      head :bad_request
    end
  end
end
