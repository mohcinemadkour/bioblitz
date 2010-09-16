# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      handle_remember_cookie! true
      redirect_to '/taxonomizer'
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :template => 'users/new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_to auth_path
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Couldn't log you in as '#{params[:emai]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
