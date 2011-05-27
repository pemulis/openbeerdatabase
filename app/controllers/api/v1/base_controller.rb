class Api::V1::BaseController < ApplicationController
  before_filter :authenticate,    :only   => [:create, :destroy]
  before_filter :validate_format, :except => [:destroy]

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
end
