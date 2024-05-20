class BuildingPolicy < ApplicationPolicy
  def index?
    user_in_admin_group? || is_rover?
  end

  def show?
    user_in_admin_group? || is_rover?
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
end
