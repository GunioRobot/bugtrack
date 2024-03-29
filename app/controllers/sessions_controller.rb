# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  resource
  layout "main", :only=>[:new]

  def before_create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      self.current_user = user
      self.current_user.remember_me
#       new_cookie_flag 
#       handle_remember_cookie! new_cookie_flag
      cookies[:auth_token] = {
        :value   => self.current_user.remember_token,
        :expires => self.current_user.remember_token_expires_at,
        :domain => ".bugtracker.com"
      }
      cookies[:auth_token] = {
        :value => self.current_user.remember_token,
        :expires => self.current_user.remember_token_expires_at
      }
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def before_destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('http://bugtracker.com')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
