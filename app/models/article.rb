class Article < ActiveRecord::Base
  has_many :discussions

  validates :title, presence: true
end
