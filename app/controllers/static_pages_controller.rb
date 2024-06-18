class StaticPagesController < ApplicationController
  before_action :auth_user, only: %i[ dashboard welcome_rovers ]

  def dashboard
    authorize :static_page
  end

  def about
    authorize :static_page
    @about_page_announcement = Announcement.find_by(location: "about_page")

    @rovers_welcome_page_announcement = Announcement.find_by(location: "rovers_welcome_page")
  end

  def welcome_rovers
    authorize :static_page
  end
end
