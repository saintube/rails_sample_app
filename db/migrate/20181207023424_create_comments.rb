class CreateComments < ActiveRecord::Migration[5.1]
  def change
    #drop_table :comments
    create_table :comments do |t|

      t.text :content
      t.integer :subjects_value
      t.integer :sentiment_value
      t.timestamps
      t.belongs_to :user, index: true
      t.belongs_to :car, index: true

    end
  end
end
