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
    @parent = Parent.new parent_params
    if @parent.save
      redirect_to parent_path(@parent)
    else
      render :new
    end
  end

  def show
    @parent = Parent.find(params[:id])
  end


  private

  def parent_params
    params.require(:parent).permit(:children_attributes => [:name, :position])
  end
end
