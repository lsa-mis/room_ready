class StaticPagePolicy < ApplicationPolicy

  def about?
    true
  end

  def home?
    user_in_admin_group?
  end

end
