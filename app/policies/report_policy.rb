class ReportPolicy < ApplicationPolicy
  def index?
    is_admin?
  end

  def room_issues_report?
    is_admin?
  end

  def inspection_rate_report?
    is_admin?
  end
end
