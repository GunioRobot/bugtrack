class MainController < ApplicationController
  resource :path => "", :member=>[:auto_complete_for_project_names]
  domain_existens_access
  layout "main"

  def auto_complete_for_project_names
    re = Regexp.new("#{params[:ticket_tags]}", "i" )
    @tags = []
    Tag.find(:all,
      :conditions=>["id in (select tag_id from taggings where taggable_type='Ticket' and taggable_id in (Select t.id from tickets t Join projects p On t.project_id = p.id where p.permalink = ?))", params[:id]]).each do |l|
      @tags << l.name unless l.name.match(re).nil?
    end
    render :layout=>false
    @site.projects
  end

  def before_show
    unless @current_user.nil?
      if @site
        @projects = @site.projects
        if request.xhr?
          render :update do |page|
            page.replace_html "body", :partial=>"show_account", :object=> [@projects, @current_user]
          end
        else
          render :partial => "show_account", :object=> [@projects, @current_user], :layout=>"main"
        end
      else
        @accounts = @current_user.accounts
        if request.xhr?
          render :update do |page|
            page.replace_html "body", :partial=>"show_account"
          end
        end
      end
    end
  end
end
