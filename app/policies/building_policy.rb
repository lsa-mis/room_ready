class BuildingPolicy < ApplicationPolicy
  def index?
    is_admin?
  end

  def show?
    is_admin?
  end

  def create?
    is_admin?
  end

  def new?
    create?
  end

  def update?
    is_admin?
  end
  
  def edit?
    update?
  end

  def destroy?
    is_admin?
  end

  def archive?
    is_admin?
  end

  def unarchive?
    is_admin?
  end

  def unarchive_index?
    is_admin?
  end

end
