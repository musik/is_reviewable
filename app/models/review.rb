class Review < ::ActiveRecord::Base

  ASSOCIATIVE_FIELDS = [
      :reviewable_id,
      :reviewable_type,
      :reviewer_id,
      :reviewer_type,
      :ip
    ].freeze
  CONTENT_FIELDS = [
      :rating,
      :body
    ].freeze

  attr_accessible :rating, :body

  # Associations.
  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewer,   polymorphic: true

  # Aliases.
  alias :object :reviewable
  alias :owner  :reviewer

  # Ordering scopes
  scope :in_order,       -> { order('created_at ASC') }
  scope :most_recent,    -> { order('created_at DESC') }
  scope :lowest_rating,  -> { order('rating ASC') }
  scope :highest_rating, -> { order('rating DESC') }

  # Filtering scopes
  scope :since,  -> created_at { where('reviews.created_at >= ?', created_at) }
  scope :recent, -> arg {
    if [::ActiveSupport::TimeWithZone, ::DateTime, ::Time, ::Date].any? { |c| arg.is_a?(c) }
      since(arg)
    else
      limit(arg.to_i)
    end
  }

  scope :between_dates,       -> from_date, to_date { where(created_at: (from_date..to_date)) }

  # Returns all reviews with a given rating.
  #
  # @param [Integer]
  # or
  # @param [Range]
  scope :with_rating,         -> rating { where(rating: rating) }

  # TODO rename with_rating
  scope :with_a_rating,       -> { where('rating IS NOT NULL') }

  # TODO rename without_rating
  scope :without_a_rating,    -> { where('rating IS NULL') }

  # TODO rename with_comment
  scope :with_a_body,         -> { where('body IS NOT NULL AND LENGTH(body) > 0') }

  # TODO rename without_comment
  scope :without_a_body,      -> { where('body IS NULL OR LENGTH(body) = 0') }

  scope :complete,            ->  { where('rating IS NOT NULL AND body IS NOT NULL AND LENGTH(body) > 0') }

  scope :of_reviewable_type,  -> type { where(reviewable_type: type.name) }
  scope :by_reviewer_type,    -> type { where(reviewer_type: type.name) }
  scope :on,                  -> reviewable { where(reviewable_type: reviewable.class.name, reviewable_id: reviewable.id) }
  scope :by,                  -> reviewer { where(reviewer_type: reviewer.class.name, reviewer_id: reviewer.id) }

  scope :with_ip,             -> ip { where(ip: ip) }

  def by?(reviewer)
    (reviewer_type == reviewer.class.name && reviewer_id == reviewer.id)
  end

end