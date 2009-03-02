class Project::TicketsController < ApplicationController
  resources :tickets
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  layout "projects"

  def before_index
    xhr_render_index
  end

  def before_edit
    xhr_render_edit
  end

  def before_new
    @milestones = @project.milestones
    xhr_render_new
  end

  def before_show
    @ticket = Ticket.find_by_permalink(params[:id])
    @comments = Comment.find(:all,
                :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
    unless params[:popup].nil?
      xhr_render_popup
    else
      xhr_render_show
    end
  end
  
  def before_create
    @ticket.state = Ticket::STATE_NEW
    @ticket.project_id = @project.id
    @ticket.created_user_id = @current_user.id
    @ticket.tag_list.add(params[:tag_list]) unless params[:tag_list].nil? || params[:tag_list].empty?
    @ticket.save
    @attachment = Attachment.new(params[:attachment])
#    @attachment = @ticket.attachments.create(params[:attachment])
    @attachment.user_id = @current_user.id
    @attachment.save
    unless @ticket.errors.empty?
      xhr_render_new
    end
  end

  def after_create
    UserMailer.deliver_ticket_notification(@project, @ticket, @current_user, User.find(@ticket.responsible_id), request)
    @action = @ticket.actions.create(:user_id => @current_user.id,
                            :what_did=> "was created by", :project_id=> @project.id)
    @action.save
    #
    if request.xhr?
        @comments = Comment.find(:all,
                  :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
        render :update do |page|
          page.replace_html :body, :partial=>"show"
          page.replace_html "tag_cloud", :partial=>"/layouts/tag_cloud"
        end

    end
  end

  def after_destroy
    xhr_render_index
  end

private
  def xhr_render_edit
    if request.xhr?
      render :update do |page|
        page.replace_html :body, :partial=>"edit"
      end
    end
  end

  def xhr_render_new
    if request.xhr?
      render :update do |page|
        page.replace_html :body, :partial=>"new"
      end
    end
  end

  def xhr_render_show
    if request.xhr?
      render :update do |page|
        page.replace_html :body, :partial=>"show"
      end
    end
  end

  def xhr_render_popup
    if request.xhr?
      if params[:popup] == 1.to_s
        render :update do |page|
          @comments = Comment.find(:all,
                  :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
          page.replace_html "ticket", :partial=> "popup_show", :object=>@comments
          page.show "ticket"
        end
      else
        render :update do |page|
          page.hide "ticket"
          page.replace_html "ticket", ""
        end
      end
    end
  end

  def xhr_render_index
    if request.xhr?
      @tickets = Ticket.find(:all, :conditions=>["project_id=?", @project.id], :order=>"created_at desc")
      @tickets_count = Ticket.find(:all, :conditions=>["project_id=?", @project.id], :order=>"created_at desc").size

      @tickets_pager = ::Paginator.new(@tickets_count, 10) do |offset, per_page|
          Ticket.find(:all, :conditions=>["project_id=?", @project.id], :limit => per_page, :offset => offset,
                                  :order=>"created_at desc")
      end
      unless params[:state].nil?
        @tickets_count = Ticket.find_all_by_state(params[:state], :conditions=>["project_id=?", @project.id], :order=>"created_at desc").size

        @tickets_pager = ::Paginator.new(@tickets_count, 10) do |offset, per_page|
            Ticket.find_all_by_state(params[:state], :conditions=>["project_id=?", @project.id], :limit => per_page, :offset => offset,
                                    :order=>"created_at desc")
        end
      else
        unless params[:user].nil?
          @tickets_count = Ticket.find_all_by_responsible_id(params[:user], :conditions=>["project_id=?", @project.id], :order=>"created_at desc").size

          @tickets_pager = ::Paginator.new(@tickets_count, 10) do |offset, per_page|
              Ticket.find_all_by_responsible_id(params[:user], :conditions=>["project_id=?", @project.id], :limit => per_page, :offset => offset,
                                      :order=>"created_at desc")
          end
          
        else
          unless params[:tag].nil?
            @tickets_count = Ticket.find_tagged_with(params[:tag], :conditions=>["project_id=?", @project.id], :order=>"created_at desc").size

            @tickets_pager = ::Paginator.new(@tickets_count, 10) do |offset, per_page|
                Ticket.find_tagged_with(params[:tag], :conditions=>["project_id=?", @project.id], :limit => per_page, :offset => offset,
                                        :order=>"created_at desc")
            end
          else
            unless params[:tags].nil?
#                 rettrn
#               end
            end
          end
        end
      end
      @tickets_page = @tickets_pager.page(params[:page])
      render :update do |page|
        page.replace_html "body", :partial=>"index"
#         page.sortable "tickets_list", :url=> project_tickets_path(@project), :tag=>"div"
      end
    end
  end
end
