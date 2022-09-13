class GroupsController < ApplicationController
  def index
    @groups = Group.order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path, notice: '新增群組成功'
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update(group_params)
    redirect_to root_path
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to root_path, alert: "Group deleted"
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end
end