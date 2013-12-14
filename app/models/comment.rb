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

  def summary_snippet
    content[0...100] + "..."
  end

  def exceeds_negative_threshold?
    # Returns false if the average of child_comments rating poorly
    children = discussion.find_children_of(self)
    total_value = children.reduce(0) { |rating, comment| rating += comment.rating }
    average_value = total_value / children.size

    average_value < (-1 * discussion.article.comment_threshold)
  end

  def form_new_discussion(opt)
    visible = !opt.fetch(:hide, false)
    article = discussion.article
    new_discussion = article.discussion.create(
      summary: summary_snippet, visible: visible
      )
    children = discussion.find_children_of(self)
    children.each { |c| c.update_attribute(:discussion_id, new_discussion.id) }
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
