class Project::TicketsController < ApplicationController
  resources :tickets
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  layout "projects"

  def before_index
    @tickets = Ticket.find(:all, :order=>"created_at desc")
    unless params[:state].nil?
      @tickets_count = Ticket.find_all_by_state(params[:state], :order=>"created_at desc").size

      @tickets_pager = ::Paginator.new(@tickets_count, 10) do |offset, per_page|
        Ticket.find_all_by_state(params[:state], :limit => per_page, :offset => offset,
                                :order=>"created_at desc")
      end
      @tickets_page = @tickets_pager.page(params[:page])
    end
  end

  def before_create
    @ticket.state = Ticket::STATE_OPEN
    @ticket.project_id = @project.id
    @ticket.created_user_id = @current_user.id
  end

  def after_create
    UserMailer.deliver_ticket_notification(@project, @ticket, @current_user, User.find(@ticket.responsible_id), request)
    @action = @ticket.actions.create(:user_id => @current_user.id, :what_did=> "<a href='#{project_ticket_path(@project, @ticket)}'>#{@ticket.title}</a> was created by #{@current_user.email}", :project_id=> @project.id)
    @action.save
    redirect_to project_tickets_path
  end

  def before_show
    @ticket = Ticket.find_by_permalink(params[:id])
    @comments = Comment.find(:all,
                :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
  end
end
