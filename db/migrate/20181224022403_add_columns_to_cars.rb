class AddColumnsToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :power, :integer
    add_column :cars, :price, :integer
    add_column :cars, :interior, :integer
    add_column :cars, :configure, :integer
    add_column :cars, :safety, :integer
    add_column :cars, :appearance, :integer
    add_column :cars, :control, :integer
    add_column :cars, :consumption, :integer
    add_column :cars, :space, :integer
    add_column :cars, :comfort, :integer
  end
end
