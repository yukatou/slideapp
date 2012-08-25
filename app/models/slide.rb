class Slide < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  attr_accessible :description, :path, :status, :title, :origin

  validates :title, presence: true
  validates :description, presence: true
end
