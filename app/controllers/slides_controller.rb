# encoding: utf-8
class SlidesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  def index
    @slides = Slide.order("id DESC").limit(20)
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

    begin
      file = params[:file]
      ext = File.extname(file.original_filename)
      @slide.save!

      path = 'tmp/slides/' + @slide.id.to_s 
      filename =  @slide.id.to_s + ext
      save_filename = path + '/' + filename

      FileUtils.mkdir_p(path)
      File.open(save_filename, 'wb') do |f|
        f.write(file.read)
      end

      @slide.update_attributes!(:path => path, :origin => filename)
      Resque.enqueue(Converter, @slide.id)

      redirect_to @slide, notice: '追加しました'
    rescue => e
      puts e.message
      render action: "new", alert: e.message
    end
  end
end
