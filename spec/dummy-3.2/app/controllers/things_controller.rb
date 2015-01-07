class ThingsController < ApplicationController
  def index
    @things = Thing.ordered_by_position_asc
  end

  def move
    @thing = Thing.find(params[:id])
    @thing.move_to! params[:position]
  end
end
