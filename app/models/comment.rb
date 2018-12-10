class Comment < ApplicationRecord

  belongs_to :car
  belongs_to :user

  validates :content, presence: true, length: { maximum: 65536 }

end
