class Zone::BuildingPolicy < ApplicationPolicy

  def create?
    user_in_admin_group?
  end

  def remove_building?
    user_in_admin_group?
  end
end
