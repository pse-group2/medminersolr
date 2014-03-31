class Page < ActiveRecord::Base

  self.table_name = "page"

  searchable do
    text :page_title

  end
end
