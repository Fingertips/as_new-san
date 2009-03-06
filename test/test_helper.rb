require "rubygems"
require "test/unit"
require "test/spec"
require 'activerecord'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require File.expand_path('../../rails/init', __FILE__)

module DBSetupAndTeardownHelper
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
  ActiveRecord::Migration.verbose = false
  
  def self.included(base)
    base.class_eval do
      before do
        ActiveRecord::Schema.define(:version => 1) do
          create_table :bacon_flavours do |t|
            t.string  :name
            t.boolean :as_new, :default => false
            t.timestamps
          end
        end
      end
      
      after do
        ActiveRecord::Base.connection.tables.each do |table|
          ActiveRecord::Base.connection.drop_table(table)
        end
      end
    end
  end
end

class BaconFlavour < ActiveRecord::Base
  include AsNewSan
end

module Test::Spec::Rails
  module ShouldDiffer
    def differ(eval_str, diff)
      before = eval(eval_str)
      @object.call
      assert_equal before + diff, eval(eval_str)
    end
  end
end

Test::Spec::Should.send(:include, Test::Spec::Rails::ShouldDiffer)