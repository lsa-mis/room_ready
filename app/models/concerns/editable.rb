module Editable
  extend ActiveSupport::Concern

  def readonly?
    if self.id.present?
      self.updated_at < Time.current.beginning_of_day
    else
      false
    end   
  end

  def is_editable
    errors.add(:base, 'Old state record cannot be edited') if readonly?
  end
end
