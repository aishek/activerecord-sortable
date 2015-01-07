class ParentsController < ApplicationController
  def new
    @parent = Parent.new
    3.times do |position|
      @parent.children.build(
        :name => "Child #{position}",
        :position => position
      )
    end
  end

  def create
    @parent = Parent.new params[:parent]
    if @parent.save
      redirect_to parent_path(@parent)
    else
      render :new
    end
  end

  def show
    @parent = Parent.find(params[:id])
  end
end
