class Project::AddUserController < ApplicationController
  resource
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  layout "main"

  def before_new
    if request.xhr?
      render :update do |page|
        page.replace_html "body", :partial=>"new"
      end
    end
  end

  def before_create
    if request.xhr?
      if params[:project_roles] != 'project.admin' && params[:project_roles] != 'project.member'
        flash[:notice]=_("Wrong params")
        redirect_to main_path
      end
      if params[:email].empty? || /^[a-zA-Z0-9\-_\.\!]+@[a-zA-Z0-9\-_\.\!]+$/.match(params[:email]).nil?
        flash[:notice] = _("Please, enter the correct email address")
        render :update do |page|
          page.replace_html "flash", flash[:notice]
          page.visual_effect "appear", "flash"
          page.replace_html "body", :partial=>"new"
          page.visual_effect "fade", "flash"
        end
        return #render :action => :new
      end
      #
      @user = User.find_by_email(params[:email])
      @project = Project.find_by_permalink(params["project_id"])
      @role = Role.find_by_name(params[:project_roles])
      @account = Account.find_by_permalink(request.subdomains[0])
      #
      unless @user.nil?
        msg = "was added to the #{@project.name} project"
        fill_params(@role, @user, @project, @account, msg)
      else
        @user = User.new
        @user.email = params[:email]
        @user.activation_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)
        @user.save
        msg = "was invited to the #{@project.name} project"
        fill_params(@role, @user, @project, @account, msg)
        #
        UserMailer.deliver_signup_notification(@project, @current_user, @user, request)
      end
    end
  end

  def after_create
    flash[:notice]=_("The user has been added to your project")
    if request.xhr?
      render :update do |page|
        @projects = @current_user.projects
        page.replace_html "flash", flash[:notice]
        page.visual_effect "appear", "flash"
        page.visual_effect "fade", "flash"
        page.replace_html "body", :partial=>"main/show_account", :object=> @projects
        page.replace_html "users_list", :partial=>"layouts/project_users"
      end
    else
      redirect_to main_path
    end
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
      @action = @user.actions.create(:user_id=>@current_user.id, :project_id=> @project.id, :what_did=> msg)
      @user_project.save
      @action.save
    else
      flash[:notice]=_("The user already added to the project")
      if request.xhr?
        render :update do |page|
          @projects = @current_user.projects
          page.replace_html "flash", flash[:notice]
          page.visual_effect "appear", "flash"
          page.visual_effect "fade", "flash"
          page.replace_html "body", :partial=>"main/show_account", :object=> @projects
        end
      else
        redirect_to main_path
      end
    end
  end
end
