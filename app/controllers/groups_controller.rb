# frozen_string_literal: true
class GroupsController < ApplicationController
  before_action(:find_group, only: [:show, :edit, :update, :destroy, :join, :quit])
  before_action(:authenticate_user!, only: [:new, :create, :edit, :update, :destroy])
  before_action(:check_owner, only: [:edit, :update, :destroy])
  before_action(:authenticate_user!, only: [:join, :quit])

  def index
    @groups = Group.includes(:user).recent
  end

  def show
    @verify_posts = @group.posts.where(status: [:pendding, :update_success]).includes(:user).recent
    @user_posts = @group.posts.where(status: [:pendding, :decline, :draft], user: current_user).includes(:user).recent
    @posts = @group.posts.where(status: [:published, :delete_by_user, :delete_by_owner, :block, :update_success, :update_fail]).includes(:user).recent.page(params[:page]).per(20)
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
      render "new"
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to(groups_path, notice: "更新群組成功")
    else
      render "edit"
    end
  end

  def destroy
    @group.destroy
    redirect_to(groups_path, alert: "Group deleted")
  end

  def join
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入群組成功！"
    else
      flash[:warning] = "你已經是本群組成員了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出群組！"
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
    return redirect_to(root_path, alert: "使用者無權限，請先加入群組") if current_user != @group.user
  end
end
