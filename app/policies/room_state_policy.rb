class RoomStatePolicy < ApplicationPolicy
    def index?
      is_rover?
    end

    def show?
      user_in_admin_group?
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
  