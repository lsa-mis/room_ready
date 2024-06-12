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
  end
  