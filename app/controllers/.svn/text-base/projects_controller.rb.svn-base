class ProjectsController < ApplicationController
  resources :projects
  logged_in_access
  account_member_access
  project_member_access :except=>[:new, :create]
  layout "projects", :except=>:new

  def before_index
    redirect_to main_path
  end

  def after_new
  end

  def before_create
    @project.account_id = @site.id
  end

  def after_create
    @user_project = UserProject.new
    @user_project.user_id = @current_user.id
    @user_project.role_id = Role.find_by_name('project.admin').id
    @user_project.project_id = @project.id
    @user_project.save!
    @action = @project.actions.create(:user_id => @current_user.id, :project_id=> @project.id, :what_did=> "<a href='#{project_path(@project)}'>#{@project.name}</a>was created")
    @action.save!
  end

  def before_show
    session[:project_id] = params[:id]
    @project = Project.find_by_permalink(params[:id])

    @users = @project.users
    @actions_count = Action.find(:all, :conditions => ["user_id = ? and project_id = ?",
                    @current_user.id, @project.id]).size

    @actions_pager = ::Paginator.new(@actions_count, 10) do |offset, per_page|
      Action.find(:all, :limit => per_page, :offset => offset,
            :conditions =>["user_id = ? and project_id = ?",
            @current_user.id, @project.id], :order=> "created_at desc")
    end
    @actions_page = @actions_pager.page(params[:page])
#   @actions = Action.find_all_by_project_id(@project.id, :order=> "created_at desc")
  end


end
