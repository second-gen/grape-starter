require 'rubygems'
require 'bundler/setup'

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: [:rubocop, :spec]

require File.expand_path('../config/environment', __FILE__)
require 'grape-swagger/rake/oapi_tasks'
GrapeSwagger::Rake::OapiTasks.new(::Api::Base)
