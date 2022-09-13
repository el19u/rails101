class GroupsController < ApplicationController
  before_action(:find_group, only: [:show, :edit, :update, :destroy])

  def index
    @groups = Group.order(created_at: :desc)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path, notice: "新增群組成功"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "更新群組成功"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to root_path, alert: "Group deleted"
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end

  def find_group
    @group = Group.find(params[:id])
  end
end