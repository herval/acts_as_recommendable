require 'rake'
require 'rake/testtask'
require 'rubygems'
require 'bundler'
require 'bundler/gem_tasks'

Bundler::GemHelper.install_tasks

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the acts_as_recommended plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
