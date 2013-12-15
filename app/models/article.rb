class Article < ActiveRecord::Base
  has_many :discussions, order: "discussions.visible DESC"

  validates :title, presence: true

  after_create -> { discussions.create!(summary: "Official discussion thread") }

  def seed_with_terribleness
    d = discussions.first
    positive = d.comments.create(content: "I like this author. He's got moxie.")
    negative = d.comments.create(content: "You suck", parent_id: positive.id, rating: -5)
    d.comments.create(content: "Check out my website, I made $5000 in just 3 hours a day!", parent_id: positive.id, rating: -5)
    d.comments.create(content: "no u", parent_id: negative.id, rating: -5)
    negative = d.comments.create(content: "son, i am disappoint", parent_id: negative.id, rating: -5)
    negative = d.comments.create(content: "Nice one, you learned how to browse knowyourmeme.com", parent_id: negative.id, rating: -5)
    negative = d.comments.create(content: "your mom", parent_id: negative.id, rating: -5)
    negative = d.comments.create(content: "how does that even work as a response?", parent_id: negative.id, rating: -5)
  end
end
