class Project::AddUserController < ApplicationController
  resource
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access

  def before_create
    if params[:project_roles] != 'project.admin' && params[:project_roles] != 'project.member'
      flash[:notice]=_("Wrong params")
      redirect_to projects_path
    end
    if params[:email].empty? || /^[a-zA-Z0-9\-_\.\!]+@[a-zA-Z0-9\-_\.\!]+$/.match(params[:email]).nil?
      flash[:notice] = _("Please, enter the correct email address")
      return render :action => :new
    end
    #
    @user = User.find_by_email(params[:email])
    @project = Project.find_by_permalink(params["project_id"])
    @role = Role.find_by_name(params[:project_roles])
    @account = Account.find_by_permalink(request.subdomains[0])
    #
    unless @user.nil?
      msg = "<a href='#{user_path(@user)}'>#{@user.email}</a> was added #{@project.name} to project"
      fill_params(@role, @user, @project, @account, msg)
    else
      @user = User.new
      @user.email = params[:email]
      @user.activation_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)
      @user.save
      msg = "<a href='#{user_path(@user)}'>#{@user.email}</a> was invited to the #{@project.name} Project"
      fill_params(@role, @user, @project, @account, msg)
      #
      UserMailer.deliver_signup_notification(@project, @current_user, @user, request)
    end
  end

  def after_create
    flash[:notice]=_("The user has been added to your project")
    redirect_to main_path
  end

  private
  def fill_params(role, user, project, account, msg)
    # If user_account exists it will pass through
    if UserAccount.find(:first, :conditions=>["user_id=? and account_id = ? ", user.id, account.id]).nil?
      @user_account = UserAccount.new
      @user_account.user_id = user.id
      @user_account.role_id = Role.find_by_name('account.member').id
      @user_account.account_id = account.id
      @user_account.save
    end
    # If user_project exists it will pass through
    if UserProject.find(:first, :conditions=>["user_id=? and project_id = ? ", user.id, project.id]).nil?
      @user_project = UserProject.new
      @user_project.user_id = user.id
      @user_project.role_id = role.id
      @user_project.project_id = project.id
      @action = @current_user.actions.create(:user_id=>@user.id, :project_id=> @project.id, :what_did=> msg)
      @user_project.save
      @action.save
    else
      flash[:notice]=_("The user already added to the project")
      redirect_to main_path
    end
  end
end
