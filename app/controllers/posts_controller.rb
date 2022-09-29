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
      @post.pendding!
      redirect_to(@group, notice: "更新群組成功")
    else
      render "edit"
    end
  end

  def destroy
    @post.destroy
    redirect_to(@group, alert: "成功刪除群組")
  end

  def manage
    @post.update(post_params)
    status = @post.status

    case status
      when "published"
        redirect_to(@group, notice: "通過文章審核")
      when "return_back"
        redirect_to(@group, alert: "不通過文章審核,請重新編輯後再次提交待審")
      when "delete_by_owner"
        redirect_to(@group, alert: "文章已被群組管理員刪除")
      when "delete_by_user"
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

  def is_group_member?
    return redirect_to(@group, alert: "使用者無權限，請先加入群組!") if !current_user.is_member_of?(@group)
  end
end
