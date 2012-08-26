# encoding: utf-8
class SlidesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  def index
    @slides = Slide.where(:status => 200).order("id DESC").page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @slides }
      format.js { render "add_next" }
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

      raise 'ファイルが選択されてません' unless params[:file]

      file = params[:file]
      ext = File.extname(file.original_filename).downcase
      max_size = Constants.upload_max_size.to_i
      # validation
      raise '拡張子が正しくありません' unless %w(.ppt .pptx .odp).include?(ext)
      raise 'アップロードできるのは#{max_size}MBまでです' if file.size > max_size.megabyte
    rescue => e
      flash[:alert] = e.message
      render action: "new"
      return
    end

    begin
      @slide.save!

      path = 'data/' + @slide.id.to_s
      dir = 'public/' + path
      filename =  @slide.id.to_s + ext
      save_filename = 'public/' + path + '/' + filename
      
      FileUtils.mkdir_p(dir)
      File.open(save_filename, 'wb') do |f|
        f.write(file.read)
      end

      @slide.update_attributes!(:path => path, :origin => filename)
      Resque.enqueue(Converter, @slide.id)
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = '入力値が正しくありません'
      render action: "new"
      return
    rescue => e
      flash[:alert] = e.message 
      render action: "new"
      return
    end

    redirect_to user_path(current_user), notice: '追加しました'
  end

  def edit
    @slide = Slide.find(params[:id])
  end

  def update
    @slide = Slide.find(params[:id])
    @slide.update_attributes(params[:slide])
    redirect_to  user_path(current_user), notice: '編集しました'
  end

  def destroy
    @slide = Slide.find(params[:id])
    @slide.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end

  def search
    @slides = Slide.search(params[:search])
  end

  def pages
    slide = Slide.find(params[:id])
    hash = {"slide_id"=> slide.id, "user_id"=> slide.user.id, "data" => {}}
    Page.where(:slide_id => params[:id]).each do |page|
      hash["data"][page.order] = {
        "url"=> root_url + slide.path + "/" + page.filename,
        "url_thm"=> root_url + slide.path + "/" + page.thm_filename
      }
    end
    render json: hash
  end
end
