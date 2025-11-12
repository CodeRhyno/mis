class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  before_action :require_login

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: 'You must be logged in to access this section'
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied'
    end
  end

  def require_circle_admin
    unless current_user&.circle_admin? || current_user&.admin?
      redirect_to root_path, alert: 'Access denied'
    end
  end
end
