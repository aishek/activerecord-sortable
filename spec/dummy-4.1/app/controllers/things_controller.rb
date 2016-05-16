class ThingsController < ApplicationController
  def index
    @things = Thing.ordered_by_position_asc
    @things = @things.where('position >= ?', params[:min_position]) if params[:min_position]
  end

  def move
    @thing = Thing.find(params[:id])
    @thing.move_to! params[:position]
  end
end
