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

  # Returns true if the average of child_comments rating poorly
  def exceeds_negative_threshold?
    children = discussion.find_children_of(self)
    unless children.size >= 5
      puts "exceeds_negative_threshold?: Comment #{id} doesn't have enough children to consider pruning"
      return false
    else
      puts "exceeds_negative_threshold?: Comment #{id} has enough children. Considering pruning..."
    end

    total_value = children.reduce(0) { |rating, comment| rating += comment.rating }
    average_value = total_value.fdiv children.size

    puts "exceeds_negative_threshold?: Comment #{id} has thread value of #{average_value}"

    average_value < (-1 * discussion.article.comment_threshold)
  end

  # Travels upwards from comment to find the "highest level" poorly rated comment
  def find_source_of_negativity
    return self if parent_comment.nil?
    parent_comment.rating < 0 ? parent_comment.find_source_of_negativity : self
  end

  # Passing hide: true means that it was branched under... unfavorable circumstances
  # The new discussion will be greyed out wherever it's linked
  def form_new_discussion(opt={})
    visible = !opt.fetch(:hide, false)
    article = discussion.article
    new_discussion = article.discussions.create(
      summary: summary_snippet, visible: visible, branched_from_discussion_id: discussion.id
      )
    children = discussion.find_children_of(self)
    children.each { |c| c.update_attribute(:discussion_id, new_discussion.id) }
  end

  def as_json(options={})
    options = options.merge({except: [:created_at, :updated_at], methods: :post_time_in_words})
    super(options)
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
