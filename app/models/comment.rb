class Comment < ApplicationRecord

  belongs_to :car
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { maximum: 65536 }
  validates :user_id, presence: true

end
