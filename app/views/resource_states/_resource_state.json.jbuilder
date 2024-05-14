json.extract! resource_state, :id, :status, :is_checked, :room_state_id, :resource_id, :created_at, :updated_at
json.url resource_state_url(resource_state, format: :json)
