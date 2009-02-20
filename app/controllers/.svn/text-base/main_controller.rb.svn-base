class MainController < ApplicationController
  resource :path => ""
  layout "main"

  def before_show
    session[:project_id] = nil
    unless session[:user_id].nil?
      if @site
        @account = Account.find_by_permalink(request.subdomains[0])
        @projects = Project.find_all_by_account_id(@account.id)      
        render :action => "show_account"
      end
      @user = User.find(session[:user_id])
      @accounts = Account.find_all_by_user_id(session[:user_id])
    end
  end
end
