class Comment < ActiveRecord::Base

  validates :discussion, presence: true

  belongs_to :discussion
  has_one(
    :parent,
    class_name: "Comment",
    foreign_key: :parent_id,
    primary_key: :id
  )

end
