class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from Exception, with: :render_500
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
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
    elsif session[:role] == "developer" || session[:role] == "admin"
      dashboard_path
    elsif session[:role] == "rover"
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

  def redirect_back_or_default(notice: '', alert: false, default: all_root_url)
    if alert
      flash[:alert] = notice
    else
      flash[:notice] = notice
    end
    url = session[:return_to]
    session[:return_to] = nil
    redirect_to(url, anchor: "top" || default)
  end

  def pundit_user
    { user: current_user, role: session[:role] }
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

  def redirect_rover_to_correct_state_new(room, room_state, step)
    state_to_redirect_to = confirmation_rover_navigation_path(room_id: room.id)
    steps = ["room", "common_attributes", "specific_attributes", "resources"]
    index = steps.find_index(step) + 1
    redirect = {}
    CommonAttribute.all.present? ? redirect["common_attributes"] = true : redirect["common_attributes"] = false
    room.specific_attributes.present? ? redirect["specific_attributes"] = true : redirect["specific_attributes"] = false
    room.resources.present? ? redirect["resources"] = true : redirect["resources"] = false

    path_to_redirect = {
      "common_attributes" => new_common_attribute_state_path(room_state_id: room_state.id),
      "specific_attributes" => new_specific_attribute_state_path(room_state_id: room_state.id), 
      "resources" => new_resource_state_path(room_state_id: room_state.id)
  }
    while index < steps.count
      if redirect[steps[index]]
        return state_to_redirect_to = path_to_redirect[steps[index]]
      end
      index += 1
    end
    state_to_redirect_to
  end


  def redirect_rover_to_correct_state_edit(room, room_state, step)
    state_to_redirect_to = confirmation_rover_navigation_path(room_id: room.id)
    steps = ["room", "common_attributes", "specific_attributes", "resources"]
    index = steps.find_index(step) + 1
    redirect = {}
    CommonAttribute.all.present? ? redirect["common_attributes"] = true : redirect["common_attributes"] = false
    room.specific_attributes.present? ? redirect["specific_attributes"] = true : redirect["specific_attributes"] = false
    room.resources.present? ? redirect["resources"] = true : redirect["resources"] = false

    path_to_redirect = {
      "common_attributes" => edit_common_attribute_state_path(room_state_id: room_state.id),
      "specific_attributes" => edit_specific_attribute_state_path(room_state_id: room_state.id), 
      "resources" => edit_resource_state_path(room_state_id: room_state.id)
    }

    while index < steps.count
      if redirect[steps[index]]
        return state_to_redirect_to = path_to_redirect[steps[index]]
      end
      index += 1
    end
    state_to_redirect_to
  end

end
