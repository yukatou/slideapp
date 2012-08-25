class AddThmFilenameToPages < ActiveRecord::Migration
  def change
    add_column :pages, :thm_filename, :string
  end
end
