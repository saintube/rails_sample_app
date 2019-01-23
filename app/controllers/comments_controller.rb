class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    # 车评计算更新
    @comment.sentiment_value = 50
    if @comment.save
      # 发布成功，先增量更新车型属性，再跳转
      init_subjects = Hash[:power => -1, \
                  	:price => -1, \
                  	:interior => -1, \
                  	:configure => -1, \
                  	:safety => -1, \
                  	:appearance => -1, \
                  	:control => -1, \
                  	:consumption => -1, \
                  	:space => -1, \
                  	:comfort => -1]
      @comment.update_attributes(init_subjects)
      # 利用算法模块的FindTheme_helper()得到车评的十个主题评分和综合分
      @car = Car.find_by_id(comment_params[:car_id])
      # 使用表单传递的算法选项
      algorithm_option = comment_params[:model].to_i
      comment_scores = evaluate_content(@comment.content, algorithm_option)
      @comment.update_attributes(comment_scores)
      new_scores = calculate_scores(@car.comments)
      @car.update_attributes(new_scores)
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
    @comment.destroy
    new_scores = calculate_scores(@car.comments)
    @car.update_attributes(new_scores)
    flash[:success] = "车评已删除"
    redirect_to request.referrer || comments_url
  end

  def index
    @comments = Comment.order(:created_at).page(params[:page]).per(10)
  end

  private

    def comment_params
      # 获取三个参数：车评内容，车型id（隐式），算法选项
      params.require(:comment).permit(:content, :car_id, :model)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to comments_url if @comment.nil?
    end
end
