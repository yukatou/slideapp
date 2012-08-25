module ApplicationHelper
  def search_slide
    @search = Slide.search(params[:search])
  end
end
