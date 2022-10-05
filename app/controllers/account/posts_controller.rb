# frozen_string_literal: true
class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: [:edit, :update, :destroy]

  def index
    @posts = current_user.posts.includes(:group).recent
  end

  def edit
  end

  def update
    if @post.update(post_params)
      status = @post.status

      case status
        when "published"
          @post.update_verify!
        end

      redirect_to(account_posts_path, notice: "更新文章成功，進入審查階段")
    else
      render :edit
    end
  end

  def destroy
    status = post_params[:status]

    case status
      when "delete_by_owner"
        @post.delete_by_owner!
      when "delete_by_user"
        @post.delete_by_user!
    end

    redirect_to(account_posts_path, alert: "文章已被刪除")
  end

  private

  def post_params
    params.require(:post).permit(:content, :status)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
