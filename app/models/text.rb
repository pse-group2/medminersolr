class Text  < ActiveRecord::Base
  self.table_name = "text"

  searchable do
    text :content
  end

end