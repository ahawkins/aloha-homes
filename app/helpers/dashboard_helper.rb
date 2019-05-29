module DashboardHelper
  def empty_value(value, placeholder = '?')
    value ? value : placeholder
  end
end
