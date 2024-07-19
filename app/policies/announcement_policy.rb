class AnnouncementPolicy < ApplicationPolicy
  
    def index?
      is_admin?
    end
  
    def show?
      is_admin?
    end
    
    def update?
      is_admin?
    end
    
    def edit?
      update?
    end
    
  end
