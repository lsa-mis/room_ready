class RoomPolicy < ApplicationPolicy
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

  def destroy?
    is_admin?
  end
end
