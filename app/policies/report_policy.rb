class ReportPolicy < ApplicationPolicy
  def index?
    is_admin? || is_readonly?
  end

  def number_of_room_issues_report?
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

  def no_access_for_n_times_report?
    is_admin? || is_readonly?
  end

  def not_checked_rooms_report?
    is_admin? || is_readonly?
  end

end
