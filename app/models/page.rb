class Page < ActiveRecord::Base

  has_one :text
  belongs_to :text

  self.table_name = "page"

  searchable do
    text :page_title
    

  end
end
