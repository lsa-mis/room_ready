class CommonAttributeStatePolicy < ApplicationPolicy
  def create?
   is_rover?
  end

  def new?
    create?
  end

  def update?
    is_rover?
   end

  def update_common_attribute_states?
  is_rover?
  end

  def edit?
    update?
  end
end
