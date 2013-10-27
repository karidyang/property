# -*- encoding : utf-8 -*-
class NoticesController < ApplicationController
  before_filter :require_user
  layout 'admin', :except => :user_notice

  def index
    if params.has_key?('topic')
      @notices = Notice.where('topic like ?', "%#{params[:topic]}%").order('created_at desc').paginate(:page => params[:page])
    else
      @notices = Notice.order('created_at desc').paginate(:page => params[:page])
    end
    render 'admin/notices/index'
  end

  def create
    @notice = Notice.new(params[:notice])
    if @notice.save
      redirect_to notices_path, :notice => '新增公告成功'
    else
      flash.now[:error] = '新增公告失败'
      render 'admin/notices/new'
    end
  end

  def new
    @notice = Notice.new
    render 'admin/notices/new'
  end

  def edit
    @notice = Notice.find(params[:id])
    render 'admin/notices/edit'
  end

  def update
    @notice = Notice.find(params[:id])
    if @notice.update_attributes(params[:notice])
      redirect_to(notices_path, :notice => '保存用户成功.')

    else
      flash.now[:error] = '修改公告失败'
      render 'admin/notices/edit'
    end
  end

  def destroy
    @notice = Notice.find(params[:id])
    @notice.destroy
    flash.now[:error] = '删除成功.'
    redirect_to notices_path
  end

  def user_notice
    @top_notices = Notice.where('publish_type=1 and expire_date>now()')
    @user_notices = NoticesUsers.where('user_id=?',@current_user.id).paginate(:page => params[:page])
    render 'admin/notices/user_notice'
  end

  def read_notice
    @user_notice = NoticesUsers.find(params[:id])
    @user_notice.update_attribute(:is_read, 1)
    redirect_to notifications_path
  end

end
