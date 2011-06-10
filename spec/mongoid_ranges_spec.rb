require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Mongoid Ranges" do
  before(:all) do
    bobs = Store.create(:name => 'Bob\'s Bodega')

    start_time = (9 + (30/60.0)).hours.to_i # 9:30 am
    end_time = (18 + (45/60.0)).hours.to_i # 6:30 pm
  
    5.times do |day|
      range_start = day.days.to_i

      bobs.hours.create :states =>['open'], :start => range_start + start_time, :end => range_start + end_time
    end
    bobs.save
  end

  it "should create valid selectors" do
    time = 3.days.to_i+12.hours.to_i
    Store.where(:hours.in_range('open') => time).selector[:hours]["$elemMatch"].should_not be_empty
  end
  
  it "should find at least one store" do
    time = 3.days.to_i+12.hours.to_i
    Store.where(:hours.in_range('open') => time).count.should > 0
  end

  it "should fix wrap check" do
    hash = {
      :name => 'Joe pizza',
      :hours => [
        {'states' =>['open'], 'start' => 20, 'end' => 50},
        {'states' =>['open'], 'start' => 60, 'end' => 70},
        {'states' =>['wrap'], 'start' => 90, 'end' => 30},
        {'states' =>['wrap'], 'start' => 90, 'end' => 10},
      ]
    }
    joes = Store.new
    joes.attributes = hash
    joes.save
    joe_new = Store.find(joes.id)
    joe_new.hours.each do |hour|
      if hour.states.first == 'open'
        hour.wrap.should == false
      else
        hour.wrap.should == true
      end
    end
  end
end
