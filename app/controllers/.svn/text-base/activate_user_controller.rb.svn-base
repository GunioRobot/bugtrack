class ActivateUserController < ApplicationController
  resource

  def before_show
    reset_session
    cookies.delete :auth_token, :domain => ".bugtracker.com"
    cookies.delete :auth_token
    @user = User.find_by_activation_code(params[:activation_code])
    if @user.nil?
      flash[:notice] = _("User has been activated or activation code is incorrect.")
      redirect_to main_path
    end
  end

  def before_update
    @user = User.find_by_email(params[:email])
    @user.update_attributes(params[:user])
    @user.activation_code = nil
#     @action = @user.actions.create(:user_id => @user.id, :what_did=> "User #{@user.email} activated and now is a member of #{@account.name} account")
  end

  def after_update
    self.current_user = @user
    self.current_user.remember_me
    new_cookie_flag = (params[:remember_me] == "1")
    #handle_remember_cookie! new_cookie_flag
    cookies[:auth_token] = {
      :value   => self.current_user.remember_token,
      :expires => self.current_user.remember_token_expires_at,
      :domain => ".bugtracker.com"
    }
    cookies[:auth_token] = {
      :value => self.current_user.remember_token,
      :expires => self.current_user.remember_token_expires_at
    }
#     redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!"
    flash[:notice] = _("Congratulations your account has been activated")
    redirect_to main_path
  end
end
