class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    # 车评计算更新
    @comment.sentiment_value = 50
    if @comment.save
      # 发布成功，先增量更新车型属性，再跳转
      # 利用算法模块的FindTheme_helper()得到车评的十个主题评分
      @car = Car.find_by_id(comment_params[:car_id])
      # subject_values, comment_score = FindTheme_helper(@comment.content, comment_params[:option])
      # TO-DO: 修改helper使得除了返回主题分也返回计算好的综合分
      # @comment.update_atrribute(:sentiment_value, comment_score)
      if @car.comments.count <= 1
        @car.update_attribute(:score, @comment.sentiment_value)
      else
        tscore = @car.score
        tcount = @car.comments.count - 1
        @car.update_attribute(:score, ((tscore * tcount + @comment.sentiment_value) / (tcount + 1)))
      end
      flash[:success] = "车评已创建!"
      redirect_to comments_url
    else
      # 发布失败
      flash[:danger] = "车评创建失败，请检查内容是否过长或过短"
      redirect_to car_url(comment_params[:car_id])
    end
  end

  def destroy
    # 减量更新车型属性
    @car = Car.find_by_id(@comment.car_id)
    tscore = @car.score
    tcount = @car.comments.count
    tvalue = @comment.sentiment_value
    @comment.destroy
    if tcount <= 1
      @car.update_attribute(:score, 50)
    else
      @car.update_attribute(:score, ((tscore * tcount - tvalue) / (tcount - 1)))
    end
    flash[:success] = "车评已删除"
    redirect_to request.referrer || comments_url
  end

  def index
    @comments = Comment.order(:created_at).page(params[:page]).per(10)
  end

  private

    def comment_params
      # 获取三个参数：车评内容，车型id（隐式），算法选项
      params.require(:comment).permit(:content, :car_id)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to comments_url if @comment.nil?
    end
end
