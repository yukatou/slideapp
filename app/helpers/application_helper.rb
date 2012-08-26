module ApplicationHelper
  def search_slide
    @search = Slide.search(params[:search])
  end
  def truncate_lines(string, length)
    count = 0
    string.split("").each_with_index do |s,index|
      break if count == 24
      if s.bytesize == 1
        count += 1
      elsif s.bytesize == 3
        length -= 1
        count +=2
      end
    end
    truncate(string, :length => length)
  end
end
