class RoverNavigationPolicy < ApplicationPolicy
  def zones?
    user_in_admin_group?
  end

  def buildings?
    user_in_admin_group?
  end

  def rooms?
    user_in_admin_group?
  end
end
