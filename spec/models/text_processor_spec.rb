require 'spec_helper'

describe TextProcessor do
  it "accepts strings with no real words in it" do
    symbols = ['','    ', '?', '.', ',', '!?', ':', '[]']
    symbols.each do |s|
      t = TextProcessor.new(s)
      w = t.word_count
      w.should be == 0
    end
  end

  text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. "\
    "Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque "\
    "penatibus et magnis dis parturient montes, nascetur ridiculus mus. "\
    "Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. "\
    "Nulla consequat massa quis enim. Donec pede justo, fringilla vel, "\
    "aliquet nec, vulputate eget, arcu."
  text2 = "Er kommt nach Hause. Nach Hause kommt er."
    
  it "counts words correctly" do
    TextProcessor.new(text).word_count.should be == 52
    
    strings =
    {'' => 0,
      'a' => 1,
      'word word' => 2,
      'dash-symbol - symbol' => 2}

    strings.each do |key, value|
      t = TextProcessor.new(key)
      w = t.word_count
      w.should be == value
    end
  end

  it "returns words correctly and removes duplicates case sensitive" do
    t = TextProcessor.new(text2)
    expected = ['Er','kommt','nach','Hause','Nach','er']
    t.words.should =~ expected
  end
  
  it "measures the frequency ignoring case sensitivity" do
    t = TextProcessor.new(text)
    t.frequency_of('Lorem').should be == 1
    t.frequency_of('lorem').should be == 1
    t.frequency_of('sit').should be == 1
    t.frequency_of('Sit').should be == 1
    t.frequency_of('Nulla').should be == 1
    t.frequency_of('nulla').should be == 1
  end

  it "does not measures the frequency of words that are not in the text" do
    t = TextProcessor.new(text)
    t.frequency_of('rocket').should be == 0
    t.frequency_of('lore').should be == 0
  end

  it "can find the nouns in the text" do
    simple_text = "Eine Welt ohne Verbrechen und Gewalt. Ein Traum."
    expected = ['Welt', 'Verbrechen', 'Gewalt', 'Traum']
    t = TextProcessor.new(simple_text)
    t.nouns.should =~ expected
    
    simple_text = "gross- und Kleinschreibung - ein alptraum."
    expected = ['Kleinschreibung']
    t = TextProcessor.new(simple_text)
    t.nouns.should =~ expected
  end
  
  it "can find adjectives in the text" do 
    simple_text = "Er wurde gewaltsam. Heute geht es mir gut. Der Ozean - ein blauer Diamant."
    expected = ['gewaltsam', 'gut', 'blauer']
    t = TextProcessor.new(simple_text)
    t.adjectives.should =~ expected
  end

end