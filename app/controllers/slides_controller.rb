class SlidesController < ApplicationController
  def index
    Resque.enqueue(Echo, params[:text])
    render :text => params[:text]
  end

  def show

  end

  def new
    @slide = Slide.new()
  end

  def create
    @uploaded = params[:upload]
    render :text => file.original_filename
  end
end
