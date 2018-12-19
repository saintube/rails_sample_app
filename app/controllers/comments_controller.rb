class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "车评已创建!"
      redirect_to comments_url
    else
      # 不知道做啥，想跳回对应车型show页面但不会写
      flash[:danger] = "车评创建失败，请检查内容是否过长或过短"
      redirect_to car_url(comment_params[:car_id])
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "车评已删除"
    redirect_to request.referrer || comments_url
  end

  def index
    @comments = Comment.order(:created_at).page(params[:page]).per(10)
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :car_id)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to comments_url if @comment.nil?
    end
end
