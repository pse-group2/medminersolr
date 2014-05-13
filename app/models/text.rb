class Text  < ActiveRecord::Base
  self.table_name = "text"

  has_one :page
  belongs_to :page
  
  validates :page, :presence => true

  searchable do
   
    text :content, :stored => true
    text :page  do 
          page.page_title
    end
  end

end