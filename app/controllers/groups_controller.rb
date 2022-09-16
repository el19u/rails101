class GroupsController < ApplicationController
  before_action(:find_group, only: [:show, :edit, :update, :destroy, :join, :quit])
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
      current_user.join!(@group)
      redirect_to(groups_path, notice: "新增群組成功")
    else
      render :new
    end
  end

  def join
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本群組成功！"
    else
      flash[:warning] = "你已經是本群組成員了！"
    end
    
    redirect_to group_path(@group)
  end

  def quit
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本群組！"
    else
      flash[:warning] = "非群組成員，無法退出"
    end

    redirect_to group_path(@group)
  end

  def join
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本群組成功！"
    else
      flash[:warning] = "你已經是本群組成員了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本群組！"
    else
      flash[:warning] = "非群組成員，無法退出"
    end

    redirect_to group_path(@group)
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