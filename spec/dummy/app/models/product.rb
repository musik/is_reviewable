class Product < ActiveRecord::Base

  is_reviewable by: [:user]

end