require 'activerecord/sortable/acts_as_sortable/instance_methods'

require 'active_support'

module ActiveRecord
  module Sortable
    module ActsAsSortable
      extend ::ActiveSupport::Concern

      module ClassMethods
        def acts_as_sortable(&block)
          options = {
            relation: ->(instance) { instance.class },
            append: false,
            position_column: :position
          }
          block.call(options) if block_given?

          sortable_relation_create_accessors
          sortable_relation_provide_accessor_values(options)

          scope "ordered_by_#{sortable_position_column}_asc".to_sym, -> { order(arel_table[sortable_position_column].asc) }

          before_create :sortable_set_default_position
          after_destroy :sortable_shift_on_destroy

          include ActiveRecord::Sortable::ActsAsSortable::InstanceMethods
        end

        private

        def sortable_relation_create_accessors
          cattr_accessor :sortable_relation, instance_reader: false, instance_writer: false
          cattr_accessor :sortable_append, instance_reader: true, instance_writer: false
          cattr_accessor :sortable_position_column, instance_reader: true, instance_writer: false
          cattr_accessor :escaped_sortable_position_column, instance_reader: true, instance_writer: false
        end

        def sortable_relation_provide_accessor_values(options)
          self.sortable_relation = options[:relation]
          self.sortable_append = options[:append]
          self.sortable_position_column = options[:position_column]
          self.escaped_sortable_position_column = ActiveRecord::Base.connection.quote_column_name(options[:position_column])
        end
      end
    end
  end
end

require 'active_record'
ActiveRecord::Base.send :include, ActiveRecord::Sortable::ActsAsSortable
