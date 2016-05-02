module ApplicationHelper

  def set_canvas_size_class
    if logged_in? && !current_user.work_in_progress
     "set-canvas-size"
    else
      ""
    end
  end
end
