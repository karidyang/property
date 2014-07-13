# -*- encoding : utf-8 -*-
module NoticesHelper
  def get_read(user_notice)
    get_boolean({false => '未读', true => '已读'}, user_notice.is_read)
  end

  def get_publish_type(notice)
    get({1 => '全局公告', 2 => '特定公告'}, notice.publish_type)
  end
end
