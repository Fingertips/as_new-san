# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{as_new-san}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eloy Duran"]
  s.date = %q{2009-03-09}
  s.description = %q{The AsNewSan mixin makes it easier to create associations on a new Active Record instance.  Use the as_new method to instantiate new empty objects that are immediately saved to the database with a special flag marking them as new. Because new instances are already stored in the database, you always have an id available for creating associations. This means you can use the same views and controller logic for new and edit actions which is especially helpful when you are creating new associated objects using Ajax calls.}
  s.email = %q{eloy.de.enige@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["as_new-san.gemspec", "lib", "lib/as_new_san.rb", "LICENSE", "rails", "rails/init.rb", "Rakefile", "README.rdoc", "test", "test/as_new_san_test.rb", "test/test_helper.rb", "VERSION.yml"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/Fingertips/as_new-san}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simple plugin which allows you to create records in the database, but treat them as if they were new records.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
