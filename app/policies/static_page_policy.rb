class StaticPagePolicy < ApplicationPolicy

  def about?
    true
  end

  def dashboard?
    user_in_admin_group?
  end

  def welcome_rovers?
    is_rover?
  end

end
