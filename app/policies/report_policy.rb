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
  
  def no_access_report?
    is_admin?
  end

  def common_attribute_states_report?
    is_admin?
  end

  def specific_attribute_states_report?
    is_admin?
  end

  def resource_states_report?
    is_admin?
  end
end
