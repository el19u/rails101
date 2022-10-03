# frozen_string_literal: true
class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_group, only: [:new, :create, :edit, :update, :destroy, :manage]
  before_action :find_post, only: [:edit, :update, :destroy, :manage]
  before_action :is_group_member?, only: [:new, :create]

  def new
    @post = current_user.posts.new
  end

  def create
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to(group_path(@group), notice: "新增文章成功")
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      @post.update_post!
      redirect_to(group_path(@group), notice: "更新文章成功")
    else
      render "edit"
    end
  end

  def manage
    status = post_params[:status]

    case status
      when "published"
        @post.published!
        redirect_to(@group, notice: "文章通過審核")
      when "declined"
        @post.decline!
        redirect_to(@group, alert: "不通過審核")
      when "delete_by_owner"
        @post.delete_by_owner!
        redirect_to(@group, alert: "文章已被群組管理員刪除")
      when "delete_by_user"
        @post.delete_by_user!
        redirect_to(@group, alert: "文章已被使用者刪除")
      when "block"
        @post.block!
        redirect_to(@group, alert: "文章已被管理員封鎖")
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :status)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def is_group_member?
    return redirect_to(@group, alert: "使用者無權限，請先加入群組!") if !current_user.is_member_of?(@group)
  end
end
