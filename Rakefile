require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "as_new-san"
    gem.homepage    = "http://github.com/alloy/as_new_san"
    gem.email       = "eloy.de.enige@gmail.com"
    gem.authors     = ["Eloy Duran"]
    gem.summary     = "A simple plugin which allows you to create records in the database, but treat them as if they were new records."
    gem.description = %{
      The AsNewSan mixin makes it easier to create associations on a new Active
      Record instance.

      Use the as_new method to instantiate new empty objects that are immediately
      saved to the database with a special flag marking them as new. Because new
      instances are already stored in the database, you always have an id
      available for creating associations. This means you can use the same views
      and controller logic for new and edit actions which is especially helpful
      when you are creating new associated objects using Ajax calls.
    }
  end
  
  begin
    require 'jewelry_portfolio/tasks'
    JewelryPortfolio::Tasks.new do |p|
      p.account = 'Fingertips'
    end
  rescue LoadError
    puts "JewelryPortfolio not available. Install it with: sudo gem install Fingertips-jewelry_portfolio -s http://gems.github.com"
  end
  
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'AsNewSan'
  rdoc.options << '--line-numbers' << '--inline-source' << '--charset=utf-8'
  rdoc.rdoc_files.include('README*', 'LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

task :default => :test