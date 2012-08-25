class HomeController < ApplicationController
  def index
    @latest_slides = Slide.order("id DESC").limit(9)
  end
end
