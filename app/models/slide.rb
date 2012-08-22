class Slide < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :path, :status, :title
end
