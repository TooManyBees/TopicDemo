class Comment < ActiveRecord::Base

  validates :discussion, presence: true
  validate :parent_comment_belongs_to_same_discussion, unless: -> { persisted? }

  before_save :append_quote_from_parent_comment, unless: -> { persisted? }

  belongs_to :discussion, inverse_of: :comments

  belongs_to(
    :parent_comment,
    class_name: "Comment",
    foreign_key: :parent_id,
    primary_key: :id
  )

  has_many(
    :child_comments,
    class_name: "Comment",
    foreign_key: :parent_id,
    primary_key: :id
  )

  def post_time_in_words
    if created_at.today?
      format = "today at %I:%M %p"
    elsif created_at.year == Time.now.year
      format = "%b %-d at %I:%M %p"
    else
      format = "%b %-d %Y at %I:%M %p"
    end

    created_at.strftime(format)
  end

  private
  # These validations/callbacks only get performed when a comment is
  # being added for the first time (there's an unless persisted? above)
  def parent_comment_belongs_to_same_discussion
    return if parent_id.nil?
    parent = Comment.find(parent_id)
    if parent.discussion_id != self.discussion_id
      errors[:parent_comment] << "is not part of the same discussion"
    end
  end

  def append_quote_from_parent_comment
    return if parent_id.nil?
    parent = Comment.find(parent_id)
    self.quote = parent.content
  end

end
