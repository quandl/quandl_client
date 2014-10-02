require "bundler"
require "rake"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'pry'

require_relative 'spec/config/quandl'

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = "spec/**/*_spec.rb"
end