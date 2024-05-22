class AppPreferencePolicy < ApplicationPolicy
  def index?
    user_in_admin_group?
  end

  def show?
    user_in_admin_group?
  end

  def create?
    user_in_admin_group?
  end

  def new?
    create?
  end

  def update?
    user_in_admin_group?
  end
  
  def edit?
    update?
  end

  def destroy?
    user_in_admin_group?
  end

  def configure_prefs?
    user_in_admin_group?
  end

  def save_configured_prefs?
    user_in_admin_group?
  end

end
