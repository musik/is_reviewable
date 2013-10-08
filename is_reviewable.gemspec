# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'is_reviewable/version'

Gem::Specification.new do |spec|
  spec.name          = 'is_reviewable'
  spec.version       = IsReviewable::VERSION
  spec.authors       = ['Jonas Grimfelt', 'Pablo Ifran']
  spec.email         = ['grimen@gmail.com', 'pabloifran@gmail.com']
  spec.description   = %q{Rails: Make an ActiveRecord resource ratable/reviewable (rate + text), without the usual extra code-smell.}
  spec.summary       = %q{Rails: Make an ActiveRecord resource ratable/reviewable (rate + text), without the usual extra code-smell.}
  spec.homepage      = 'http://github.com/grimen/is_reviewable'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('{lib}/**/*')
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency('activesupport' , '~> 3.0')
  spec.add_dependency('rails'         , '~> 3.0')

  spec.add_development_dependency('bundler', '~> 1.3')
  spec.add_development_dependency('rake')

  # Testing Dependencies
  spec.add_development_dependency('rspec-rails')
  spec.add_development_dependency('factory_girl')
  spec.add_development_dependency('shoulda')
  spec.add_development_dependency('sqlite3')
  spec.add_development_dependency('faker')
end