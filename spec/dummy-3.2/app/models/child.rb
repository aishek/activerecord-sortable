class Child < ActiveRecord::Base
  acts_as_sortable do |config|
    config[:relation] = ->(instance) {instance.parent.children}
  end

  belongs_to :parent

  attr_accessible :name, :position
end
