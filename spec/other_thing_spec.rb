require 'spec_helper'

describe OtherThing do
  it_behaves_like 'activerecord-sortable', :position_column => :place
end
