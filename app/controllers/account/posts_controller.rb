class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: [:edit, :update, :destroy]

  def index
    @posts = current_user.posts
  end

  # def edit
  # end

  # def update
  #   if @post.update(post_params)
  #     redirect_to(account_posts_path, notice: "更新成功")
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to(account_posts_path, alert: "刪除成功")
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end
end
