class ResourceStatePolicy < ApplicationPolicy

  def create?
    is_rover? || is_admin?
   end
 
   def new?
     create?
   end
end
