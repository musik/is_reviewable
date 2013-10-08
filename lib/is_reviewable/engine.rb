require 'rails/all'

module IsReviewable

  class Engine < Rails::Engine

    initializer 'is_reviewable.load_app_instance_data' do |app|
      IsReviewable.setup do |config|
        config.app_root = app.root
        config.logger   = Rails.logger
      end
    end

  end

end