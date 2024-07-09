# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :role, :record

  def initialize(context, record)
    @user = context[:user]
    @role = context[:role]
    @record = record

  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def is_admin?
    @role == "admin" || @role == "developer"
  end

  def is_developer?
    @role == "developer"
  end

  def is_readonly?
    @role == "readonly"
  end

  def is_rover?
    @role == "rover"
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
