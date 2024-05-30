class StaticPagesController < ApplicationController
  before_action :auth_user, only: %i[ home ]

  def home
    authorize :static_page
  end

  def about
    authorize :static_page
    @about_page_announcement = Announcement.find_by(location: "about_page")
  end
end
