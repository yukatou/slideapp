# encoding: utf-8
class SlidesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  def index
    @slides = Slide.where(:status => 200).order("id DESC").limit(20)
    respond_to do |format|
      format.html
      format.json { render json: @slides }
    end
  end

  def show
    @slide = Slide.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @slide }
    end
  end


  def new
    @slide = Slide.new()
  end

  def create
    @slide = Slide.new(params[:slide])
    @slide.user_id = current_user.id

    puts params[:file].content_type

    if @slide.save
      redirect_to @slide, alert: '追加しました'
    else
      render action: "new"
    end
  end

  def search
    @slides = Slide.search(params[:search])
  end

  def get_files
    @pages = Page.where(:slide_id => params[:id])
    render json: @pages
  end
end
