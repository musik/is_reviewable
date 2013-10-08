require 'active_support/dependencies'

module IsReviewable

  # Our host application root path
  # We set this when the engine is initialized
  mattr_accessor :app_root
  mattr_accessor :logger

  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end

end

require_relative 'is_reviewable/engine'
require_relative 'is_reviewable/exceptions'
require_relative 'is_reviewable/reviewable'