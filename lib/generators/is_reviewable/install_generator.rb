require 'rails/generators'

module IsReviewable
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generate a migration to create reviews table'

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_migrations
      copy_migration 'create_reviews'
    end

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    protected

    def copy_migration(filename)
      if self.class.migration_exists?('db/migrate', "#{filename}")
        say_status('skipped', "Migration #{filename}.rb already exists")
      else
        migration_template "migrations/#{filename}.rb", "db/migrate/#{filename}.rb"
      end
    end

  end
end