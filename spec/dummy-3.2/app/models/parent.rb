class Parent < ActiveRecord::Base
  has_many :children

  accepts_nested_attributes_for :children

  attr_accessible :children_attributes
end
