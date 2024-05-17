class CommonAttributePolicy < ApplicationPolicy
  def index?
    user_in_admin_group?
  end

  def new?
    user_in_admin_group?
  end

  def edit?
    user_in_admin_group?
  end

  def create?
    user_in_admin_group?
  end

  def update?
    user_in_admin_group?
  end

  def destroy?
    user_in_admin_group?
  end
end