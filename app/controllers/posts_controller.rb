class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_group, only: [:new, :create, :edit, :update, :destroy]

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

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to(groups_path, notice: "更新群組成功")
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to @group, alert: "Group deleted"
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
  
  def find_group
    @group = Group.find(params[:group_id])
  end
end