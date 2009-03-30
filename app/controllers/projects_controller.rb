class ProjectsController < ApplicationController
  domain_existens_access
  resources :projects, :belongs_to => "@site", :member=>[:auto_complete_for_tags]
  logged_in_access
  account_member_access
  project_member_access :except=>[:new, :create, :auto_complete_for_tags]
  layout "projects", :except=>:new


  def auto_complete_for_tags
    re = Regexp.new("#{params[:ticket_tags]}", "i" )
    @tags = []
    Tag.find(:all,
      :conditions=>["id in (select tag_id from taggings where taggable_type='Ticket' and taggable_id in (Select t.id from tickets t Join projects p On t.project_id = p.id where p.permalink = ?))", params[:id]]).each do |l|
      @tags << l.name unless l.name.match(re).nil?
    end
    render :layout=>false

  end

  def before_index
    redirect_to main_path
  end

  def before_new
    xhr_render_new
  end

  def before_create
    @project.save
    unless @project.errors.empty?
      xhr_render_new
    end
  end

  def after_create
    @user_project = @project.user_projects.new
    @user_project.user_id = @current_user.id
    @user_project.role_id = Role.find_by_name('project.admin').id
    @user_project.save
    flash[:notice]=_("The project has been added, successfuly.")
    if request.xhr?
      render :update do |page|
        @projects = @current_user.projects.find(:all, :conditions => ["account_id = ?", @site.id])
        page.replace_html :filters, ""
        page.replace_html :flash, flash[:notice]
        page.replace_html :body, :partial=> "main/show_account", :object=> @projects
      end
    end
#     @action = @project.actions.create(:user_id => @current_user.id, :project_id=> @project.id, :what_did=> "<a href='#{project_path(@project)}'>#{@project.name}</a>was created")
#     @action.save
  end

  def before_show
    @users = @project.users
    @actions_count = Action.find(:all, :conditions =>["project_id = ?", @project.id]).size
    @actions_pager = ::Paginator.new(@actions_count, 30) do |offset, per_page|
      Action.find(:all, :limit => per_page, :offset => offset,
          :conditions =>["project_id = ?",
          @project.id], :order=> "created_at desc")
    end
    @actions_page = @actions_pager.page(params[:page])
    if request.xhr?
      render :update do |page|
          page.replace_html :filters, ""
          page.replace_html "body", :partial=>"/projects/show"
      end
    end
  end
private

  def xhr_render_new
    if request.xhr?
      render :update do |page|
        page.replace_html :filters, ""
        page.replace_html "body", :partial=>"new"
      end
    end    
  end

end
