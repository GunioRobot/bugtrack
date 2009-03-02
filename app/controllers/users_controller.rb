class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  resources :users
  logged_in_access :except=>[:new, :create]
  layout "main", :only=>["new"]

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
    @success = @user && @user.save
  end

  def before_update
    if params[:old_password]
      unless User.find
    end
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
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
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
