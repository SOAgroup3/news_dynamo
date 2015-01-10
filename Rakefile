require 'rake/testtask'
require './app'
require_relative 'model/classification.rb'
require_relative 'model/keyword.rb'
require_relative 'model/original.rb'

task :default => :spec

desc "Run all tests"
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

namespace :db do
  desc "Create database"
  task :migrate do
    begin
      Classification.create_table(5, 6)
      Keyword.create_table(5, 6)
      Original.create_table(5, 6)
    rescue AWS::DynamoDB::Errors::ResourceInUseException => e
      puts 'DB exists -- no changes made, no retry attempted'
    end
  end
end