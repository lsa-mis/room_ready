class StaticPagePolicy < ApplicationPolicy

  def about?
    true
  end

  def dashboard?
    is_admin?
  end

  def welcome_rovers?
    is_rover?
  end

end
