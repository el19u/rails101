class GroupsController < ApplicationController
  before_action(:find_group, only: [:show, :edit, :update, :destroy])
  before_action(:authenticate_user!, only: [:new, :create, :edit, :update, :destroy])
  before_action(:check_owner, only: [:edit, :update, :destroy])
  
  def index
    @groups = Group.recent
  end
  
  def show
    @posts = @group.posts.recent.page(params[:page]).per(5)
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.build(group_params)

    if @group.save
      redirect_to(groups_path, notice: "新增群組成功")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to(groups_path, notice: "更新群組成功")
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

  def check_owner
    redirect_to root_path, alert: "使用者無權限" if current_user != @group.user
  end
end