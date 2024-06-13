class ResourceStatePolicy < ApplicationPolicy

  def create?
    is_rover?
   end
 
   def new?
     create?
   end

   def update_resource_states?
    is_rover?
  end

  def edit?
    update_resource_states?
  end
end
