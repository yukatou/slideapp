class Page < ActiveRecord::Base
  belongs_to :slide
  attr_accessible :filename, :thm_filename, :order
end
