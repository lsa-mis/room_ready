class RoverNavigationPolicy < ApplicationPolicy
  def zones?
    is_rover?
  end

  def buildings?
    is_rover?
  end

  def rooms?
    is_rover?
  end
end
