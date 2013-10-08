module IsReviewable
  class IsReviewableError < ::StandardError
    def initialize(message)
      IsReviewable.logger.debug(message)

      super(message)
    end
  end

  InvalidConfigValueError = ::Class.new(IsReviewableError)
  InvalidReviewerError = ::Class.new(IsReviewableError)
  InvalidReviewValueError = ::Class.new(IsReviewableError)
  RecordError = ::Class.new(IsReviewableError)

end
