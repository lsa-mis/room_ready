class RoverPolicy < ApplicationPolicy
  
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
  
end