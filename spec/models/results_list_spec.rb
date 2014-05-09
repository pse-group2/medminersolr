require 'spec_helper'

describe ResultsList do
  it "ignores nil values from search hits" do
    hit1 = double("Hit")
    hit2 = nil
    list = ResultsList.new([hit1, hit2])
    list.all.count.should be == 1
  end
  
  it "calculates the range of the scores" do
    hits = [double("Hit", :score => 40), double("Hit", :score => 200), double("Hit", :score => 100)]
    
    list = ResultsList.new(hits)
    list.lowest_score.should be == 40
    list.highest_score.should be == 200
    list.score_range.should be == 160
  end
  
  it "can intersect with another list" do
    hit1 = double("Hit", :primary_key => 2)
    hit2 = double("Hit", :primary_key => 4)
    hit3 = double("Hit", :primary_key => 1)
    
    
    hits1 = [hit1, hit2, hit3]
    hits2 = [hit3, hit2]
    
    list1 = ResultsList.new(hits1)
    list2 = ResultsList.new(hits2)
    
    intersect1 = list1.intersect(list2)
    intersect2 = list2.intersect(list1)
    
    intersect1.count.should be == 2
    intersect2.count.should be == 2
    
    intersect1.all[0].should eql hit2
    intersect2.all[0].should eql hit3
  end
 
  it "can unite with another list" do
    hit1 = double("Hit", :primary_key => 2)
    hit2 = double("Hit", :primary_key => 4)
    hit3 = double("Hit", :primary_key => 1)
    hit4 = double("Hit", :primary_key => 3)
    
    hits1 = [hit1, hit2, hit3]
    hits2 = [hit4, hit2]
    
    list1 = ResultsList.new(hits1)
    list2 = ResultsList.new(hits2)
    
    union1 = list1.unite(list2)
    union2 = list2.unite(list1)
    
    union1.count.should be == 4
    union2.count.should be == 4
    
    union1.all[0].should eql hit1
    union2.all[0].should eql hit4
  end
end