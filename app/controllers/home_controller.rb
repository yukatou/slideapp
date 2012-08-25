class HomeController < ApplicationController
  def index
    @latest_slides = Slide.where(:status => 200).order("id DESC").limit(6)
  end
end
