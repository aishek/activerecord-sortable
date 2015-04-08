require 'spec_helper'

# test for model with position column named `orded` (which can cause problems with raw SQL queries)
describe OrderThing do
  it_behaves_like 'activerecord-sortable', position_column: :order
end
