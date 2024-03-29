class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  resources :users
  logged_in_access :except=>[:new, :create]
  account_admin_access :only => :index
  layout "main", :only=>[:new, :create]

  def before_index
    unless @site.nil?
      @users = @site.users
    else
      @users = ""
    end
  end

  def before_show
    xhr_render_show
  end

  def before_edit
    xhr_render_edit
  end

  def before_new
    @account = Account.new
  end

  def before_create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.time_zone = params[:user][:time_zone]
    @success = @user && @user.save
  end

  def before_update
    unless params[:unsubscribe].blank? || params[:unsubscribe].nil?
      @user.subscribe = params[:unsubscribe]
    end
    if params[:unsubscribe].nil?
      if params[:old_password].blank? 
        @user.name = params[:user][:name]
        @user.im = params[:user][:im]
        @user.job_title = params[:user][:job_title]
        @user.time_zone = params[:user][:time_zone]
        @user.cell_phone = params[:user][:cell_phone]
        @user.save
      elsif @user.authenticated?(params[:old_password])
        @user.update_attributes(params[:user])
      else
        @old_password_error = _("Password didn't match")
        xhr_render_edit
      end
    end
    unless @user.errors.empty?
      xhr_render_edit
    end
  end

  def after_update
    xhr_render_show
  end

  def after_create
    if @success && @user.errors.empty?
#       @action = @user.actions.create(:user_id => @user.id, :what_did=> "User #{@user.email} created")
#       @action.save!
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = @user
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
      flash[:notice] = "Thanks for signing up!"
      UserMailer.deliver_new_user_notification(@user, request)
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

private
  def xhr_render_edit
    if request.xhr?
      render :update do |page|
        page.replace_html :body, :partial=> "edit"
      end
    end
  end

  def xhr_render_show
    if request.xhr?
      render :update do |page|
        page.replace_html :body, :partial=> "show"
      end
    end
  end

end
