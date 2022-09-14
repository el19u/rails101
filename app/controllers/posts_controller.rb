class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_group, only: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
  
  def find_group
    @group = Group.find(params[:group_id])
  end
end