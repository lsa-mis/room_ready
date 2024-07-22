class CommonAttributeStatePolicy < ApplicationPolicy
  def create?
   is_rover? || is_admin?
  end

  def new?
    create?
  end

  def update_common_attribute_states?
    is_rover? || is_admin?
  end

  def edit?
    update_common_attribute_states?
  end
end
