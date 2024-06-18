class RoomStatus
	include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

	def initialize(room)
		@room = room
	end

  def status_weight
    ca = CommonAttribute.count > 0 ? 1 : 0
    sa = @room.specific_attributes.count > 0 ? 1 : 0
    res = @room.resources.count 0 ? 1 : 0
    w = 1.to_f / (1 + ca + sa + res) * 100
    return w
  end

	def room_checked_once?
		@room.last_time_checked.present?
	end

	def last_time_checked
		@room.last_time_checked.to_date
	end

	def tomorrow
		Date.today + 1.day
	end

	def yesterday
		Date.today - 1.day
	end

	def room_checked_today?
		yesterday < last_time_checked && last_time_checked < tomorrow
	end

	def common_attributes_exist?
		CommonAttribute.count > 0
	end

	def specific_attributes_exist?
		@room.specific_attributes.count > 0
	end

	def resources_exist?
		@room.resources.count > 0
	end

	def room_state
		@room.room_states.last
	end

	def common_attribute_checked?
		room_state.common_attribute_states.last.present? && (yesterday..tomorrow).include?(room_state.common_attribute_states.last.updated_at.to_date)
	end

	def specific_attribute_checked?
		room_state.specific_attribute_states.last.present? && (yesterday..tomorrow).include?(room_state.specific_attribute_states.last.updated_at.to_date)
	end

	def resources_checked?
		room_state.resources_states.last.present? && (yesterday..tomorrow).include?(room_state.resources_states.last.updated_at.to_date)
	end

	def show_status
		if room_checked_once?
			if room_checked_today?
				w = status_weight
				percentage = w
				if common_attributes_exist?
					percentage += w if common_attribute_checked?
				end
				if specific_attributes_exist?
					percentage += w if specific_attribute_checked?
				end
				if resources_exist?
					percentage += w if resources_checked?
				end
				checked = "Checked " + number_with_precision(percentage, precision: 2).to_s + "%"
			else
        checked = "Checked " + time_ago_in_words(last_time_checked + 1.day) + " ago"
      end
		else
			checked = "Never checked"
		end
		return checked
	end

end