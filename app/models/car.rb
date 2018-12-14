class Car < ApplicationRecord

  has_many :comments
  has_many :users, through: :comments

  VALID_CARNAME_REGEX = /\A[a-zA-Z]+[a-zA-Z\d]+/

  validates :carname, presence: true, length: { minimum: 3, maximum: 30 },
                      uniqueness: { case_sensitive: false },
                      format: { with: VALID_CARNAME_REGEX }
  validates :description, length: {maximum: 200}

end
