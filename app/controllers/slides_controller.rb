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
      render action: "new", error: e.message
    end
  end

  def search
    @slides = Slide.search(params[:search])
  end

  def pages
    @pages = Page.where(:slide_id => params[:id])
    @pages.each do |page|
      @page["url"] = root_url
      @page["url_thm"] = root_url
    end
    render json: @pages
  end
end
