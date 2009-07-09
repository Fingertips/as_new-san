require "rubygems"
require "test/spec"
require 'activerecord'

$:.unshift File.expand_path('../../lib', __FILE__)
require File.expand_path('../../rails/init', __FILE__)

module DBSetupAndTeardownHelper
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
  ActiveRecord::Migration.verbose = false
  
  def setup
    ActiveRecord::Schema.define(:version => 1) do
      create_table :bacon_flavours do |t|
        t.string  :name
        t.boolean :as_new, :default => false
        t.timestamps
      end
    end
  end
  
  def teardown
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end
end

class BaconFlavour < ActiveRecord::Base
  include AsNewSan
end