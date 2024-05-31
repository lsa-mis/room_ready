class RoverNavigationsController < ApplicationController
  before_action :auth_user

  def zones
    authorize :rover_navigation, :zones?
    @zones = Zone.includes(:buildings).order(:name)
  end

  def buildings
    authorize :rover_navigation, :buildings?
    @buildings = Building.all
  end

  def rooms
    authorize :rover_navigation, :rooms?
    @rooms = Room.all
  end
end
