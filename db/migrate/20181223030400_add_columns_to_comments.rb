class AddColumnsToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :power, :integer
    add_column :comments, :price, :integer
    add_column :comments, :interior, :integer
    add_column :comments, :configure, :integer
    add_column :comments, :safety, :integer
    add_column :comments, :appearance, :integer
    add_column :comments, :control, :integer
    add_column :comments, :consumption, :integer
    add_column :comments, :space, :integer
    add_column :comments, :comfort, :integer
  end
end
