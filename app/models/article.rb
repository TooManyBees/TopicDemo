class Article < ActiveRecord::Base
  has_many :discussions

  validates :title, presence: true

  after_create -> { discussions.create!(summary: "Official discussion thread") }
end
