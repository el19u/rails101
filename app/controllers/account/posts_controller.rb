class Account::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to account_posts_path, alert: "Post deleted"
  end

  private

  def find_group
    @group = Post.find(params[:post_id])
  end
end
