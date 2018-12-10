class Car < ApplicationRecord

  has_many :comments
  has_many :users, through: :comments

  validates :carname, presence: true, length: { maximum: 30 },
                      uniqueness: { case_sensitive: false }

end
