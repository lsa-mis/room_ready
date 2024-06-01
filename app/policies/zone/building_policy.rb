class Zone::BuildingPolicy < ApplicationPolicy

  def create?
    is_admin?
  end

  def update?
    is_admin?
  end
  
  def edit?
    update?
  end

  def remove_building?
    is_admin?
  end
end
