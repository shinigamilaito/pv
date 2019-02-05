module ApplicationHelper
  def active_item(uri)
    uri_segments = request.fullpath.split(/\/|\?/)
    uri_segments[1] == uri && uri_segments[2] != 'pending_services' ? 'active-sidebar' : ''
  end

  def active_item_action(action)
    uri_segments = request.fullpath.split(/\/|\?/)
    uri_segments[2] == action ? 'active-sidebar' : ''
  end

  def date_time_helper(datetime)
    datetime.strftime('%d/%m/%Y - %I:%M %p')
  end

end
