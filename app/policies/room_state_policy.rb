class RoomStatePolicy < ApplicationPolicy
    def index?
      is_rover? || is_admin?
    end

    def show?
      is_rover?
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
      is_rover?
    end
  end
