class DashboardsController < ApplicationController
  before_action :auth_user

  def index
    @dashboard = Dashboard.new
    authorize @dashboard
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
