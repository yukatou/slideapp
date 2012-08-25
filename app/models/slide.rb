class Slide < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :path, :status, :title

  validates :title, presence: true
  validates :description, presence: true
end
