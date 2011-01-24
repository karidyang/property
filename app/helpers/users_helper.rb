module UsersHelper
  def user_name_tag(user)
    result = "<a href=\"#{user_path(user.id)}\" title=\"#{user.name}\">#{user.name}</a>"
    raw(result)
  end
end
