class Text  < ActiveRecord::Base
self.table_name = "text"

searchable do
	text :old_text
	
end

def text
	old_text
end


end