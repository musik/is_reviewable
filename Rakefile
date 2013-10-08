require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

RSpec::Core::RakeTask.new(:spec)

# If you want to make this the default task
task default: :spec