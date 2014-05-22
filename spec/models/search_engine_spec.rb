require 'spec_helper'
describe SearchEngine do
  it "can filter out dimensionwords" do
    input = ['Ich', 'gehe','in','behandlung','da','ich','eine',"Therapie","nötig","habe"]
    engine = SearchEngine.new("")
    engine.stub(:extract_dimensionwords_from_file).and_return(['therapie'])
    engine.send(:filter_dimensionwords,(input)).should be== ['ich', 'gehe','in','behandlung','da','ich','eine',"nötig","habe"]
    
  end
end