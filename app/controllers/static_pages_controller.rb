class StaticPagesController < ApplicationController
  before_action :auth_user, only: %i[ home ]

  def home
    authorize :static_page
  end

  def about
    authorize :static_page
  end
end
