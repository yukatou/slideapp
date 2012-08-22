class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.string :title, :null => false
      t.text :description
      t.integer :status, :default => 0
      t.string :path
      t.references :user

      t.timestamps
    end
    add_index :slides, :user_id
  end
end
