class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|

      t.string	:carname
      t.text	:description
      t.string	:subjects
      t.integer	:score
      t.timestamps

    end

    add_index :cars, :carname, unique: true

  end
end
