# frozen_string_literal: true
class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  # before_action :find_group, only: [:edit, :update, :destroy]

  def index
    @posts = current_user.posts.includes(:group).recent
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to account_posts_path, notice: "Post updated."
    else
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to account_posts_path, alert: "Post deleted."
  end 

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

end
