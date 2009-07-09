require File.expand_path('../test_helper', __FILE__)

describe "AsNewSan", ActiveRecord::TestCase do
  include DBSetupAndTeardownHelper
  
  it "should really create a record for a `new' object with `as_new' set to `true'" do
    assert_difference('BaconFlavour.count_without_as_new', +1) { BaconFlavour.as_new(:name => 'chunky') }
    BaconFlavour.include_as_new.find_by_name('chunky').as_new.should.be true
  end
  
  it "should garbage collect any record which has been in the db for a specific period" do
    old_record = BaconFlavour.as_new(:name => 'banana', :created_at => (Time.now - 1.week - 1))
    new_record = BaconFlavour.as_new(:name => 'smoked')
    
    assert_difference('BaconFlavour.count_without_as_new', -1) { BaconFlavour.collect_garbage! }
  end
  
  it "should be possible to do a `find' without matching any `as_new' records" do
    as_new_record = BaconFlavour.as_new(:name => 'smells as new')
    not_as_new_record = BaconFlavour.create(:name => 'does not smell at all')
    
    BaconFlavour.find_without_as_new(:all).should == [as_new_record, not_as_new_record]
    BaconFlavour.find(:all).should == [not_as_new_record]
  end
  
  it "should set `as_new' records to `false' on update" do
    record = BaconFlavour.as_new(:name => 'ice cream')
    record.as_new_record?.should.be true
    record.update_attribute(:name, 'that is right, bacon ice cream')
    record.as_new_record?.should.be false
  end
  
  it "should define a named scope to include as_new records" do
    as_new_record = BaconFlavour.as_new(:name => 'good as new')
    BaconFlavour.include_as_new.find(:first, :conditions => { :name => 'good as new' }).should == as_new_record
  end
  
  it "should define a named scope to exclude as_new records" do
    as_new_record = BaconFlavour.as_new(:name => 'good as new')
    BaconFlavour.exclude_as_new.find(:first, :conditions => { :name => 'good as new' }).should.be.nil
  end
end