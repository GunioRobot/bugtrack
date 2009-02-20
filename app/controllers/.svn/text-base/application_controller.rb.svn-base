# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include GetText::Rails
#   session :session_domain => '.bugtraker.com'
  helper :all # include all helpers, all the time
  before_filter :init

  # Инициализируем систему доменом
  init_gettext "blog"

  # Устанавливаем кодировку
  before_filter :set_charset

  def set_charset
    headers['Content-Type'] = "text/html;charset=utf-8"
  end

  protected
  def init
    @project = Project.find_by_permalink(params[:project_id]) unless params[:project_id].nil?
    @ticket = Ticket.find_by_permalink(params[:ticket_id]) unless params[:ticket_id].nil?
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
    @site = ApplicationController.get_site(request)
    logger.info "Site: " + @site.inspect
    @site = nil if @site == :false
#     return if params[:controller] == 'favicon'
    return (redirect_to "/subdomain_error.html") if !@site && !request.subdomains.join(".").blank? && request.subdomains.join(".") != 'www'
  end
  
  def accountrole(role)
    @current_user = User.find(session[:user_id])
    unless @site == :false
      @roles = Role.find(:all, :joins=>"Join user_accounts ua On roles.id = ua.role_id",
      :conditions=>["ua.user_id =? and ua.account_id = ? ", @current_user.id, @site.id])
    end
    @user_roles = @current_user ? @roles.collect{|r| r.name} : ""
    return true if @user_roles.include?(role)
    false
  end

  def projectrole(role)
    @current_user = User.find(session[:user_id])
    unless @project.nil?
      @roles = Role.find(:all, :joins=>"Join user_projects up On roles.id = up.role_id",
      :conditions=>["up.user_id =? and up.project_id = ? ", @current_user.id, @project.id])
    end
    @user_roles = @current_user ? @roles.collect{|r| r.name} : ""
    return true if @user_roles.include?(role)
    false
  end

  access_test_method :logged_in_access, :account_member_access, :account_admin_access, :domain_existens_access, :project_member_access, :project_admin_access

  def domain_existens_access
    raise AccessDenied unless request.subdomains.join(".") != ''
  end

  def logged_in_access
    raise AccessDenied unless session[:user_id]
  end

  def account_admin_access
    raise AccessDenied unless accountrole('account.admin')
  end

  def account_member_access
    raise AccessDenied unless accountrole('account.member') || accountrole('account.admin')
  end

  def project_member_access
    raise AccessDenied unless projectrole('project.member') || projectrole('project.admin')
  end

  def project_admin_access
    raise AccessDenied unless projectrole('project.admin')
  end

  def self.get_site(request)
    return nil unless request
    (
      request.subdomains.join(".") != '' &&
      Account.find_by_permalink(request.subdomains.join("."))
    ) ||
    :false
  end
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c13abd9ec80a7f1a7a565e062ac113df'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password
end
