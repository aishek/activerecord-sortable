class OrderThing < ActiveRecord::Base
  acts_as_sortable do |config|
    config[:position_column] = :order
  end
end
