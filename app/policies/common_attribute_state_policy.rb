class CommonAttributeStatePolicy < ApplicationPolicy
  def create?
    user_in_admin_group?
  end

  def new?
    create?
  end
end
