class Text  < ActiveRecord::Base
self.table_name = "text"

searchable do
	text :content
	integer :page_id
	integer :text_id 
	
end


end