class ResourceStatePolicy < ApplicationPolicy

  def create?
    is_rover? || is_admin?
   end
 
   def new?
     create? || is_admin?
   end

   def update_resource_states?
    is_rover? || is_admin?
  end

  def edit?
    update_resource_states?
  end
end
