class OtherThing < ActiveRecord::Base
  acts_as_sortable do |config|
    config[:position_column] = :place
  end
end
