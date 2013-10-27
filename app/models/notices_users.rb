# -*- encoding : utf-8 -*-
class NoticesUsers < ActiveRecord::Base
  attr_accessible :notice_id, :user_id, :is_read

  belongs_to :user
  belongs_to :notice
end