module ActiveRecord
  module Sortable
    module ActsAsSortable
      module InstanceMethods

        def move_to!(new_position)
          new_position = Integer(new_position)

          transaction do
            if new_position > self.send(sortable_position_column)
              sortable_relation
                .where(["#{sortable_position_column} > ? AND #{sortable_position_column} <= ?", self.send(sortable_position_column), new_position])
                .update_all sortable_updates_with_timestamps("#{sortable_position_column} = #{sortable_position_column} - 1")
            else
              sortable_relation
                .where(["#{sortable_position_column} >= ? AND #{sortable_position_column} < ?", new_position, self.send(sortable_position_column)])
                .update_all sortable_updates_with_timestamps("#{sortable_position_column} = #{sortable_position_column} + 1")
            end

            self.update_attribute(sortable_position_column, new_position)
          end
        end


        private

        def sortable_relation
          self.class.sortable_relation.call(self)
        end

        def sortable_set_default_position
          sortable_assign_default_position unless self.send(sortable_position_column).present?

          true
        end

        def sortable_assign_default_position
          if sortable_append
            next_position = (max_position = sortable_relation.pluck(self.sortable_position_column).max).present? ? max_position + 1 : 0
            self.send("#{sortable_position_column}=".to_sym, next_position)
          else
            sortable_relation.update_all sortable_updates_with_timestamps("#{sortable_position_column} = #{sortable_position_column} + 1")
            self.send("#{sortable_position_column}=".to_sym, 0)
          end
        end

        def sortable_updates_with_timestamps(base_query)
          current_time = current_time_from_proper_timezone

          query_items = [base_query]

          update_values = timestamp_attributes_for_update_in_model.map do |attr|
            query_items << "#{attr} = ?"
            current_time
          end
          updates = [query_items.join(', ')] + update_values
        end

        def sortable_shift_on_destroy
          sortable_relation.where(["#{sortable_position_column} > ?", self.send(sortable_position_column)]).update_all sortable_updates_with_timestamps("#{sortable_position_column} = #{sortable_position_column} - 1")
          true
        end
      end
    end
  end
end
