require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'yard'
require "bundler/gem_tasks"

desc "Default Task"
task :default => :test

Rake::TestTask.new

YARD::Rake::YardocTask.new do |t|
  t.options += ['--verbose', '--title', "PayPal Adaptive Payments to Spree store"]
end
