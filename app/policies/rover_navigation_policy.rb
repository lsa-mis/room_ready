class RoverNavigationPolicy < ApplicationPolicy
  def zones?
    is_rover? || is_admin?
  end

  def buildings?
    is_rover? || is_admin?
  end

  def rooms?
    is_rover? || is_admin?
  end

  def confirmation?
    is_rover? || is_admin?
  end
end
