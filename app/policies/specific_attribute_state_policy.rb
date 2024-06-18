class SpecificAttributeStatePolicy < ApplicationPolicy
    def index?
      is_admin?
    end

    def create?
      is_rover? || is_admin?
    end
  
    def new?
      create?
    end
  
    def update_specific_attribute_states?
      is_rover? || is_admin?
    end
  
    def edit?
      update_specific_attribute_states?
    end
  
    def destroy?
      is_admin?
    end
  end
  