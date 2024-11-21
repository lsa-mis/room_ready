# app/controllers/concerns/custom_failure.rb
class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_message == :timeout
      all_root_path
    else
      super
    end
  end

  def flash_message
    if warden_message == :timeout
      'Your session has expired. Please log in again to continue.'
    else
      super
    end
  end
end
