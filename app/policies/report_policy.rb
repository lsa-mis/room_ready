class ReportPolicy < ApplicationPolicy
  def index?
    is_admin? || is_readonly?
  end

  def room_issues_report?
    is_admin? || is_readonly?
  end

  def inspection_rate_report?
    is_admin? || is_readonly?
  end
  
  def no_access_report?
    is_admin? || is_readonly?
  end

  def common_attribute_states_report?
    is_admin? || is_readonly?
  end

  def specific_attribute_states_report?
    is_admin? || is_readonly?
  end

  def resource_states_report?
    is_admin? || is_readonly?
  end

  def no_access_in_n_days_report?
    is_admin? || is_readonly?
  end
end
