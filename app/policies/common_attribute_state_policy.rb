class CommonAttributeStatePolicy < ApplicationPolicy
  def create?
   is_admin?
  end

  def new?
    create?
  end
end
