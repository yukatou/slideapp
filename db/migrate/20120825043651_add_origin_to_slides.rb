class AddOriginToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :origin, :string
  end
end
