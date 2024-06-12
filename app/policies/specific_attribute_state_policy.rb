class SpecificAttributeStatePolicy < ApplicationPolicy
    def index?
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
  end
  