class Zone::BuildingPolicy < ApplicationPolicy

  def create?
    user_in_admin_group?
  end

  def update?
    user_in_admin_group?
  end
  
  def edit?
    update?
  end

  def remove_building?
    user_in_admin_group?
  end
end
