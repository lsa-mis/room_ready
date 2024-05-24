# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
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

  def user_in_admin_group?
    # binding.pry
    # admin_group = ['lsa-roomready-admins']
    # user.membership && (user.membership & admin_group).any?
    @user.membership && @user.membership.include?('lsa-roomready-admins')
  end

  def is_rover?
    Rover.all.pluck(:uniqname).include?(user.uniqname)
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
