class CommonAttributeStatePolicy < ApplicationPolicy
  def create?
   is_rover?
  end

  def new?
    create?
  end
end
