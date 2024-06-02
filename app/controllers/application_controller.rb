class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from Exception, with: :render_500
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_membership
  after_action :verify_authorized, unless: :devise_controller?
  include ApplicationHelper

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  def auth_user
    unless user_signed_in?
      $baseURL = request.fullpath
      redirect_post(user_saml_omniauth_authorize_path, options: {authenticity_token: :auto})
    end
  end

  def after_sign_in_path_for(resource)
    if $baseURL.present?
      $baseURL
    elsif session[:user_memberships].present?
      dashboard_path
    elsif is_rover?(resource)
      welcome_rovers_path
    else
      root_path
    end
  end

  def sort_floors(floors)
    sorted = floors.sort_by do |s|
      if s =~ /^\d+$/
        [2, $&.to_i]
      else
        [1, s]
      end
    end
    return sorted
  end

  def render_404
    respond_to do |format|
      format.html { render 'errors/not_found', status: :not_found, layout: 'application' }
      format.json { render json: { error: 'Not Found' }, status: :not_found }
    end
  end

  def render_500(exception)
    # Log the error, send it to error tracking services, etc.
    respond_to do |format|
      format.html { render 'errors/internal_server_error', status: :internal_server_error, layout: 'application' }
      format.json { render json: { error: 'Internal Server Error' }, status: :internal_server_error }
    end
  end

  private

    def set_membership
      if user_signed_in?
        current_user.membership = session[:user_memberships]
        current_user.admin = session[:user_admin]
      else
        new_user_session_path
      end
    end
end
