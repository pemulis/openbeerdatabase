class Api::V1::BaseController < ApplicationController
  before_filter :authenticate,    :only   => [:create, :destroy]
  before_filter :validate_format, :except => [:destroy]

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  protected

  def authenticate
    head(:unauthorized) unless current_user.present?
  end

  def current_user
    return unless params[:token].present?

    if request.get?
      User.find_by_token(params[:token])
    else
      User.find_by_private_token(params[:token])
    end
  end
  memoize :current_user

  def validate_format
    head(:not_acceptable) unless request.format.json?
  end
end
