class DashboardsController < ApplicationController
  before_action :auth_user

  def index
    @dashboard = Dashboard.new
    authorize @dashboard

    @zones = Zone.all
  end

  def new
  end

  def edit
  end

  def show
  end

  def delete
  end
end
