class Project::MilestonesController < ApplicationController
  resources :milestones, :belongs_to=> "@project"
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  project_admin_access :only=>[:new, :create, :edit, :update]
  layout "projects"

  def before_index
    xhr_render_index
  end

  def before_new
    xhr_render_new
  end

  def before_show
    @milestone = Milestone.find(params[:id])
    @open_tickets = 0
    @milestone.tickets.each do |t|
      if t.state != Ticket::STATE_RESOLVED && t.state != Ticket::STATE_HOLD
        @open_tickets += 1
      end
    end
    xhr_render_show
  end

  def before_edit
    xhr_render_edit
  end

  def before_update
    @milestone.created_user_id = @current_user.id
    @milestone.due_date = params[:milestone][:due_date].to_date
    @milestone.save
    unless @milestone.errors.empty?
      xhr_render_edit
    end
  end

  def after_update
    @milestone.actions.create(:user_id => @current_user.id, :project_id=> @project.id, :what_did=> "was created by")
    xhr_render_index
  end
  
  def before_create
    @milestone.created_user_id = @current_user.id
    unless params[:milestone][:due_date].empty?
      @milestone.due_date = params[:milestone][:due_date].to_date
    end
    @milestone.save
    unless @milestone.errors.empty?
      xhr_render_new
    end
  end

  def after_create
    @milestone.actions.create(:user_id => @current_user.id, :project_id=> @project.id, :what_did=> "was created by")
    xhr_render_index
  end

  def after_destroy
    xhr_render_index
  end

  private

  def xhr_render_index
    if request.xhr?
      render :update do |page|
        @milestones = @project.milestones
        page.replace_html :filters, ""
        page.replace_html "body", :partial=> "index", :object=> @milestones
      end
    end
  end

  def xhr_render_show
    if request.xhr?
      render :update do |page|
        page.replace_html :filters, ""
        page.replace_html "body", :partial=> "show"
      end
    end
  end

  def xhr_render_new
    if request.xhr?
      render :update do |page|
        page.replace_html :filters, ""
        page.replace_html "body", :partial=> "new"
      end
    end
  end

  def xhr_render_edit
    if request.xhr?
      render :update do |page|
        page.replace_html :filters, ""
        page.replace_html "body", :partial=> "edit"
      end
    end
  end

end
