# The AsNewSan mixin makes it easier to create associations on a new Active
# Record instance.
#
# Use the +as_new+ method to instantiate new empty objects that are immediately
# saved to the database with a special flag marking them as new. Because new
# instances are already stored in the database, you always have an +id+
# available for creating associations. This means you can use the same views
# and controller logic for new and edit actions which is especially helpful
# when you are creating new associated objects using Ajax calls.
#
# An Active Record class using this mixin needs to have an +as_new+ boolean
# column with the default value set to +false+ and a +created_at+ column.
#
# Example:
#
#   class CreateMessages < ActiveRecord::Migration
#     def self.up
#       create_table :messages do |t|
#         t.string :body
#         t.boolean :as_new, :default => false
#         t.timestamps
#       end
#     end
#   end
#   
#   class CreateRecipients < ActiveRecord::Migration
#     def self.up
#       create_table :recipient do |t|
#         t.integer :message_id
#         t.string :name
#       end
#     end
#   end
#
#   class Message < ActiveRecord::Base
#     include AsNewSan
#     has_many :recipients, :dependent => :destroy
#   end
#   
#   class Recipient < ActiveRecord::Base
#     belongs_to :message
#   end
#   
#   class MessagesController < ApplicationController
#     def index
#       # Remove all records older than 1 week that have the `as_new` property set to `true`.
#       Message.collect_garbage!
#       
#       # The mixin comes with the `find_without_as_new` class method, which behaves as the 
#       # ActiveRecord::Base#find class method, but only finds records which have their 
#       # `as_new` property set to `false`.
#       @messages = Message.find_without_as_new(:all)
#     end
#     
#     def new
#      # Create and save a message with the `as_new` property set to `true`.
#      # 
#      # Recipients are created and associated using Ajax calls on the recipients controller.
#      @message = Message.as_new
#     end
#     
#     def update
#       # The mixin comes with a `before_update` filter that sets the `as_new` column to 
#       # `false` before saving the updated record.
#       @message = Message.find(params[:id])
#       @message.update_attributes(params[:message])
#
#       # So, at this point the record is not marked `as_new` anymore.
#     end
#   end
module AsNewSan
  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
    base.before_update(:unset_as_new)
  end
  
  module ClassMethods
    # Instantiates a new object, sets the as_new column to +true+ and saves the
    # associated record without validation.
    #
    # If the record is never updated, or its as_new property explicitely set to
    # +false+, it will be destroyed after 1 week when the collect_garbage!
    # class method is called.
    #
    # See <tt>ActiveRecord::Base.new</tt> for all the other options that can be
    # passed to as_new.
    def as_new(attributes = {})
      returning( new(attributes.merge( :as_new => true )) ) { |record| record.save(false) }
    end
    
    # Finds and destroys all the records where the as_new column is set to
    # +true+ and +created_at+ is longer than 1 week ago.
    def collect_garbage!
      find(:all, :conditions => ['as_new = ? AND created_at < ?', true, Time.now - 1.week]).each(&:destroy)
    end
    
    # Works the same as <tt>ActiveRecord::Base.find</tt> but only returns
    # records for which the as_new column is set to +false+.
    def find_without_as_new(*args)
      with_scope(:find => { :conditions => { :as_new => false } }) do
        find(*args)
      end
    end
  end
  
  # Returns a boolean indicating whether or not this is a +as_new+ record.
  def as_new_record?
    self.as_new
  end
  
  private
  
  def unset_as_new
    self.as_new = false
    true
  end
end