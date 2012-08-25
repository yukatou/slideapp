class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :filename, :null => false
      t.integer :order, :null => false
      t.references :slide

      t.timestamps
    end
    add_index :pages, :slide_id
  end
end
