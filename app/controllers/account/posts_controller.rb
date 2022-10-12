# frozen_string_literal: true
class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: [:edit, :update, :destroy]
  before_action :check_post_owner, only: [:edit, :update, :destroy]

  def index
    @posts = current_user.posts.includes(:group).recent
  end

  def edit
  end

  def update
    if @post.update(post_params)
      @post.update_verify! if @post.publish?

      redirect_to(account_posts_path, notice: "更新文章成功")
    else
      render "edit"
    end
  end

  def destroy
    @post.delete_by_post_author!

    redirect_to(account_posts_path, alert: "文章已被刪除")
  end

  private

  def post_params
    params.require(:post).permit(:content, :status)
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def check_post_owner
    redirect_to(root_path, alert: "你沒有權限修改此文章") if !@post.author?(current_user)
  end
end
