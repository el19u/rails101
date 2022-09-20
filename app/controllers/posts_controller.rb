class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :find_group, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_post, only: [:edit, :update, :destroy]
  before_action :is_group_member?, only: [:new, :create]
  
  def new
    @post = current_user.posts.new
  end

  def create
    @post = posts.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to(group_path(@group), notice: "新增文章成功")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to(@group, notice: "更新群組成功")
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to(@group, alert: "成功刪除群組")
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
  
  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def is_group_member?
    return redirect_to(@group, alert: "無權限!") if !current_user.is_member_of?(@group)
  end
end