class RemoveSubjectsFromCars < ActiveRecord::Migration[5.1]
  def change
    remove_column :cars, :subjects, :string
  end
end
