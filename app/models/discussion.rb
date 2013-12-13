class Discussion < ActiveRecord::Base

  validates :summary, presence: true
  validates :article, presence: true

  belongs_to :article
  has_many :comments

  def find_children_of(comment_id)
    result = []
    
  end
end
