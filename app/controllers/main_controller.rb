class MainController < ApplicationController
  resource :path => ""
  layout "main"

  def before_show
    unless session[:user_id].nil?
      if @site
        @account = Account.find_by_permalink(request.subdomains[0])
        @projects = Project.find_all_by_account_id(@account.id)
        if request.xhr?
          render :update do |page|
            page.replace_html "body", :partial=>"show_account"
          end
        else
          render :action => "show_account"
        end
      else
        @user = User.find(session[:user_id])
        @accounts = Account.find_all_by_user_id(session[:user_id])
        if request.xhr?
          render :update do |page|
            page.replace_html "body", :partial=>"show_account"
          end
        end
      end
    end
  end
end
