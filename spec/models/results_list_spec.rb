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
    hits3 = [hit3]
    hits4 =[]
    
    list1 = ResultsList.new(hits1)
    list2 = ResultsList.new(hits2)
    list3 = ResultsList.new(hits3)
    list4 = ResultsList.new(hits4)
    
    intersect1 = list1.intersect(list2)
    intersect2 = list2.intersect(list1)
    intersect3 = list3.intersect(list1)
    intersect4 = list4.intersect(list1)
    
    
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
  
  it "can normalize a Resultslist" do
   hits = [hit1 = double("Hit1", :score => 50.0), hit2 = double("Hit2", :score => 100.0), hit3 = double("Hit3", :score => 0.0)]
   hits2 = [hit4 = double("Hit4", :score => 50.0)]
    list = ResultsList.new(hits)
    list2 = ResultsList.new(hits2)
    list3 = ResultsList.new([])
    
    hit1.should_receive(:score=).with(0.5)
    hit2.should_receive(:score=).with(1)
    hit3.should_receive(:score=).with(0)
    hit4.should_receive(:score=).with(1)
    list.normalize
    list2.normalize
    list3.normalize
    
    
  end
  
 
end