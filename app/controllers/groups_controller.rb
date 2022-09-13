class GroupsController < ApplicationController
  def index
    @groups = Group.order(created_at: :desc)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.save
    redirect_to root_path
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end