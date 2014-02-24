require "bundler"
require "rake"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'pry'
require "quandl/client"

include Quandl::Client

Quandl::Client.use ENV['QUANDL_TEST_URL']
Quandl::Client.token = ENV['QUANDL_TEST_TOKEN']

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = "spec/**/*_spec.rb"
end

task :console do |t, args|
  binding.pry
end