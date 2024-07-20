class NotePolicy < ApplicationPolicy
  
  def index?
    is_admin?
  end

  def show?
    is_admin?
  end

  def new?
    create?
  end

  def create?
    is_admin?
  end

  def edit?
    update?
  end

  def update?
    is_admin?
  end

  def destroy?
    is_admin?
  end

end
