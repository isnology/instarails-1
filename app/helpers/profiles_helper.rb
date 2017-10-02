module ProfilesHelper
  
  def format_lame_browsers(str)
    str.split(' ').join('<br/>').html_safe
  end

end
