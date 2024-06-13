class SpecificAttributeStatePolicy < ApplicationPolicy
    def index?
      is_admin?
    end

    def create?
      is_rover?
    end
  
    def new?
      create?
    end
  
    def update?
      is_rover?
    end
  
    def edit?
      update?
    end
  
    def destroy?
      is_admin?
    end
  end
  