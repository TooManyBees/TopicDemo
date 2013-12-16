class Article < ActiveRecord::Base
  has_many :discussions, order: "discussions.visible DESC"

  validates :title, presence: true

  after_create -> { discussions.create!(summary: "Official discussion thread") }

  # Creates seed data
  def seed_with_terribleness
    d = discussions.first
    positive = d.comments.create(content: "I like this author. He's got moxie.", rating: 10)
    negative = d.comments.create(content: "You suck", parent_id: positive.id, rating: -5)
    d.comments.create(content: "Check out my website, I made $5000 in just 3 hours a day!", parent_id: positive.id, rating: 1)
    d.comments.create(content: "no u", parent_id: negative.id, rating: -8)
    negative = d.comments.create(content: "son, i am disappoint", parent_id: negative.id, rating: -6)
    negative = d.comments.create(content: "Nice one, you learned how to browse knowyourmeme.com", parent_id: negative.id, rating: -6)
    d.comments.create(content: "Guyyyyyys, can't we all just get along??", parent_id: negative.id, rating: 3)
    negative = d.comments.create(content: "your mom", parent_id: negative.id, rating: -7)
    negative = d.comments.create(content: "how does that even work as a response?", parent_id: negative.id, rating: -6)
    d.comments.create(content: "Good sir, I agree with your assessment. There is moxie aplenty over yonder.", parent_id: positive.id, rating: 6)
  end
end
