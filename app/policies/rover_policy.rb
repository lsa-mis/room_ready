class RoverPolicy < ApplicationPolicy
  
  def index?
    user_in_admin_group?
  end

  def create?
    true
  end

  def new?
    true
  end
  
end