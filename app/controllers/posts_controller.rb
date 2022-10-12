# frozen_string_literal: true
class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :manage]
  before_action :find_group, only: [:new, :create, :edit, :update, :destroy, :manage]
  before_action :find_post, only: [:edit, :update, :destroy, :manage]
  before_action :check_post_owner, only: [:edit, :update, :destroy]
  before_action :is_group_member?, only: [:new, :create, :edit, :update, :destroy]

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
      @post.update_verify!

      redirect_to(group_path(@group), notice: "更新文章成功")
    else
      render "edit"
    end
  end

  def manage
    status = post_params[:status]

    case status
    when "draft"
      @post.draft!
      redirect_to(group_path(@group), notice: "取消送審")
    when "verify"
      @post.verify!
      redirect_to(group_path(@group), notice: "文章已送審")
    when "publish"
      @post.publish!
      redirect_to(@group, notice: "文章通過審核")
    when "decline"
      @post.decline!
      redirect_to(@group, alert: "文章不通過審核")
    when "delete_by_post_author"
      @post.delete_by_post_author!
      redirect_to(@group, alert: "文章已被使用者刪除")
    when "block"
      @post.block!
      redirect_to(@group, alert: "文章已被管理員封鎖")
    when "update_decline"
      @post.update_decline!
      redirect_to(@group, alert: "版主拒絕更新文章")
    when "cancel_update_verify"
      @post.cancel_update_verify!
      redirect_to(@group, alert: "使用者取消審核")
    when "trash"
      @post.destroy
      redirect_to(@group, alert: "文章已被使用者刪除")
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

  def check_post_owner
    if current_user != @post.user
      redirect_to(root_path, alert: "你沒有權限修改此文章")
    end
  end

  def is_group_member?
    redirect_to(@group, alert: "使用者無權限，請先加入群組!") if !current_user.is_member_of?(@group)
  end
end
