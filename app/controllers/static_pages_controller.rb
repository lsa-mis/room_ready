class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: %i[ home ]

  def home
    authorize :static_page
  end

  def about
    authorize :static_page
  end
end
