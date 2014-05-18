class Remover
  
  attr_accessor :pct
  attr_accessor :c
  
  def initialize(client, array)
    @client = client
    @input = array
    @c = 0
    @length = @input.length.to_i
    @pct = 0
  end
  
  def start
    @input.each do |id|
      @pct = (@c.to_f/@length.to_f*100).round(3)
      @client.query("DELETE FROM page WHERE page_id=#{id}")
      @client.query("DELETE FROM text WHERE page_id=#{id}")
      @c+=1
    end
  end
  
end