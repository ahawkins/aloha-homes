module DashboardHelper
  def empty_value(value, placeholder = '?')
    value ? value : placeholder
  end

  def viewed?(post)
    session.fetch(:viewed, [ ]).include?(post.id)
  end
end
