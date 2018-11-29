class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :content_id
      t.text :content
      t.integer :subject_value
      t.integer :sentiment_value

      t.timestamps
    end
  end
end
