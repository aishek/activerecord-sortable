require 'activerecord/sortable/acts_as_sortable/instance_methods'

require 'active_support'

module ActiveRecord
  module Sortable
    module ActsAsSortable
      extend ::ActiveSupport::Concern

      module ClassMethods
        def acts_as_sortable(&block)
          options = {
            :relation => ->(instance) {instance.class},
            :append => false,
            :position_column => :position
          }
          block.call(options) if block_given?

          cattr_accessor :sortable_relation, :instance_reader => false
          cattr_accessor :sortable_append, :instance_reader => true
          cattr_accessor :sortable_position_column, :instance_reader => true

          self.sortable_relation = options[:relation]
          self.sortable_append = options[:append]
          self.sortable_position_column = options[:position_column]

          scope "ordered_by_#{self.sortable_position_column}_asc".to_sym, -> { order(self.sortable_position_column => :asc) }

          before_create :sortable_set_default_position
          after_destroy :sortable_shift_on_destroy

          include ActiveRecord::Sortable::ActsAsSortable::InstanceMethods
        end
      end
    end
  end
end

require 'active_record'
ActiveRecord::Base.send :include, ActiveRecord::Sortable::ActsAsSortable
