class Api::V1::BaseController < ActionController::Base
  # Base controller - common logic like Authentication / Authorization,
  # record not found, common functions to be kept here 
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def record_not_found(error)    
    render json: {
      status_code: 404,
      message: 'Record not found',
      data: {}
    }, status: 404
    return
  end
end