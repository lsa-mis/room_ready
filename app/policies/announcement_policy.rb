class AnnouncementPolicy < ApplicationPolicy
  
    def index?
      user_in_admin_group?
    end
  
    def show?
      user_in_admin_group?
    end
    
    def update?
      user_in_admin_group?
    end
    
    def edit?
      update?
    end
  
    def destroy?
      user_in_admin_group?
    end
    
  end
  