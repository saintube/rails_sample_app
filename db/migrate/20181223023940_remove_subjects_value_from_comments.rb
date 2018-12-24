class RemoveSubjectsValueFromComments < ActiveRecord::Migration[5.1]
  def change
    remove_column :comments, :subjects_value, :integer
  end
end
