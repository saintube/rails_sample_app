class Comment < ApplicationRecord

  validates :content_id, presence: true
  validates :content, presence:true, length: {maximum: 1000}

end
