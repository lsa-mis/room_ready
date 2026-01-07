module FloorSortable
  extend ActiveSupport::Concern

  def sort_floors(floors_or_names)
    floors_or_names.sort_by do |item|
      name = item.respond_to?(:name) ? item.name : item.to_s
      if name =~ /^\d+$/
        [2, $&.to_i]
      else
        [1, name]
      end
    end
  end
end
