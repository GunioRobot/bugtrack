class AccountsController < ApplicationController
  resources :accounts
  layout "main"
  logged_in_access
  account_admin_access :only=> :index

  def before_new
    if @site
      redirect_to "/"
    else
    @account = Account.new
    end
  end

  def before_create
    @account.user_id = @current_user.id
    @success = @account && @account.save
  end

  def after_create
    if @success && @account.errors.empty?
      @user_account = @current_user.user_accounts.new
      @user_account.role_id = Role.find_by_name('account.admin').id
      @user_account.user_id = @current_user.id
      @user_account.account_id = @account.id
      @user_account.save
#       @action = @account.actions.create(:user_id => @current_user.id, :what_did=> "Account #{@account.name} created")
#       @action.save!
      redirect_to(main_path)
      flash[:notice] = _("Thanks for creating new account!")
    else
      flash[:error]  = _("We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above).")
      render :action => 'new'
    end
  end
end
