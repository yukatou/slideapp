class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @queued_slides = Slide.where(:status => [0,100], :user_id => current_user.id)
    @slides = Slide.where(:status => 200, :user_id => current_user.id)
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def create
    @slide = Slide.new()
  end


  def update
  end


  def delete
  end

end
