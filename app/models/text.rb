class Text  < ActiveRecord::Base
  self.table_name = "text"

  has_one :page
  belongs_to :page

  searchable do
   
    text :content 
    text :page  do 
          page.page_title
    end
   
  end

end