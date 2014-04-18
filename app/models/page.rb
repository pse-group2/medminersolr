class Page < ActiveRecord::Base
  self.table_name = "page"

  has_one :text
  belongs_to :text
  
  validates :text, :presence => true

  searchable do
    text :page_title
  end
  
end
