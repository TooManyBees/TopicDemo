class Discussion < ActiveRecord::Base

  validates :summary, presence: true
  validates :article, presence: true

  belongs_to :article, inverse_of: :discussions
  belongs_to(
    :source_discussion,
    class_name: "Discussion",
    primary_key: :id,
    foreign_key: :branched_from_discussion_id,
    inverse_of: :branches
  )
  has_many :comments, dependent: :destroy, order: :created_at
  has_many(
    :branches,
    class_name: "Discussion",
    primary_key: :id,
    foreign_key: :branched_from_discussion_id,
    dependent: :nullify
  )

  def visible_branches
    branches.where(visible: true)
  end

  # Banish and promote both remove a comment and all of its children into
  # a parallel discussion. Promote advertises it at the top of the discussion
  # page; banish just does it invisibly.
  def banish(comment)
    d = new_discussion_from(comment)
    d.update_attribute(:visible, false)
  end

  def promote(comment)
    new_discussion_from(comment)
  end

  # The only reason this method belongs to discussion instead of comment
  # is so that discussion can grab all its comments in a single db action
  def find_children_of(comment)
    children = []
    all_comments = comments_by_parent
    to_check = [comment]

    until to_check.empty?
      current = to_check.shift

      children << current
      to_check += all_comments[current.id]
    end

    children
  end

  private
  def new_discussion_from(comment)
    new_discussion = Discussion.create(
      article: self.article,
      summary: comment.summary_snippet
      )
    children = find_children_of(comment)
    children.each { |el| el.update_attribute(:discussion, new_discussion) }
    new_discussion
  end

  def comments_by_parent
    hashed = Hash.new { |h, k| h[k] = [] }

    # TODO: may need to .to_a this to avoid needless db hits
    comments.reload.each do |comment|
      hashed[comment.parent_id] << comment
    end

    hashed
  end
end
