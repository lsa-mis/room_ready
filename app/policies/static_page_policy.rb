class StaticPagePolicy < ApplicationPolicy

  def about?
    true
  end

  def dashboard?
    is_admin?
  end

  def welcome_rovers?
    is_rover? || is_admin?
  end

end
