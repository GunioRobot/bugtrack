class Project::Ticket::CommentsController < ApplicationController
  resources :comments
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  before_filter :comment_init, :only=>[:index, :edit]
  layout "projects"

  def before_index
    
    if request.xhr?
      if params[:close] = 1
        render :update do |page|
          page.hide "comment"
        end
      end
    end
  end

  def before_new
    @attachment = @ticket.attachments.new
    puts @attachment.attachable_type
    if request.xhr?
      render :update do |page|
        page.replace_html "comment", :partial=>"new"
        page.show "comment"
      end
    end
  end

  def before_edit
    if request.xhr?
      render :update do |page|
        page.replace_html "comment_#{params[:id]}", :partial=>"edit"
        page.show "comment_#{params[:id]}"
        page.replace_html "comment", ""
      end
    end
  end

  def before_update
    @comment.update_attributes(params[:comment])
    @ticket.updated = Ticket::UPDATED
    @ticket.email_sender = Ticket::NOT_SEND
    @ticket.save
    @comment.save
    unless @comment.errors.empty?
      render :update do |page|
        page.replace_html "comment_#{params[:id]}", :partial=>"edit"
        page.show "comment_#{params[:id]}"
        page.replace_html "comment", ""
      end
    end
  end

  def after_update
    if request.xhr?
      render :update do |page|
        page.replace_html "edit_#{@comment.id}", :partial=> 'comment'
        page.replace_html "comment", :partial=>"new"
      end
    end
  end

  def before_create
    if params[:popup]
      state = params[:ticket][:state]
      responsible_id = params[:ticket][:responsible_id]
      #
      urgency = before_urgency = @ticket.urgency
      severity = before_severity = @ticket.severity
      milestone_id = before_milestone_id = @ticket.milestone_id
    else
      state = params[:ticket][:state]
      responsible_id = params[:ticket][:responsible_id]
      urgency = params[:ticket][:urgency]
      severity = params[:ticket][:severity]
      milestone_id = params[:ticket][:milestone_id]
      before_state = @ticket.state
      before_urgency = @ticket.urgency
      before_severity = @ticket.severity
      before_responsible_id = @ticket.responsible_id
      before_milestone_id = @ticket.milestone_id
    end
    @comment = @ticket.comments.create(:commentable_type =>"Ticket", :commentable_id => @ticket.id,
                                          :user_id => @current_user.id, :ticket_id => @ticket.id,
                                          :project_id =>@project.id, :account_id => @site.id,
                                          :comment => params[:comment][:comment],
                                          :before_state=> before_state, :before_urgency=> before_urgency,
                                          :before_severity=> before_severity, :before_responsible_id=> before_responsible_id,
                                          :before_milestone_id=> before_milestone_id,
                                          :state => state, :urgency => urgency,
                                          :severity => severity, :responsible_id => responsible_id,
                                          :milestone_id => milestone_id
                                          )      
    @comment.save
    unless @comment.errors.empty?
      render :update do |page|
        if params[:popup]
          page.replace_html "ticket_comment_#{@ticket.id}", :partial=>"popup_new", :object=> @comment
        else
          page.replace_html "comment", :partial=>"new", :object=> @comment
        end
        page.replace_html "tag_cloud", :partial=>"/layouts/tag_cloud"
      end
      return
    else
      @ticket.actions.create(:user_id=>@current_user.id, :project_id=>@project.id, :what_did=> "was updated by")
      unless params[:ticket_tags].nil? || params[:ticket_tags].empty?
        params[:ticket_tags].split(",").each do |tag|
          @ticket.tag_list.add(tag)
        end
      end
      @ticket.updated = Ticket::UPDATED
      @ticket.email_sender = Ticket::NOT_SEND
      @ticket.save
      @ticket.update_attributes(params[:ticket])
    end
  end
  
  def after_create
    comment_init
    #
    unless @comment.responsible_id.nil?
      unless Subscribe.find(:all, :conditions=>["ticket_id = ? and user_id = ?", @ticket.id, @comment.responsible_id]).empty?
        @subscribe = Subscribe.new
        @subscribe.ticket_id = @ticket.id
        @subscribe.user_id = @comment.responsible_id
        @subscribe.save!
      end
    end
    #
    subscribtions
    #
    if request.xhr?
      if params[:popup]
        render :update do |page|
          page.replace_html "menu_ticket_#{@ticket.id}", :partial=>"new_comment", :object=> @ticket
          page.replace_html "ticket_#{@ticket.id}", :partial=>"/project/tickets/popup_show"
        end
      else
        render :update do |page|
          page.replace_html :body, :partial=>"/project/tickets/show"
          page.replace_html "tag_cloud", :partial=>"/layouts/tag_cloud"
  #         page.replace_html "comments", :partial=>"index"
        end
      end
    end
  end

  private
  def subscribtions
    if params[:all].nil?
      for user in @project.users
        if params["user_#{user.id}"]
          if Subscribe.find(:all, :conditions=>["ticket_id = ? and user_id = ?", @ticket.id, user.id]).empty?
            @subscribe = Subscribe.new
            @subscribe.user_id = user.id
            @subscribe.ticket_id = @ticket.id
            @subscribe.save!
          end
        end
      end
    else
      for user in @project.users
        if Subscribe.find(:all, :conditions=>["ticket_id = ? and user_id = ?", @ticket.id, user.id]).empty?
          @subscribe = Subscribe.new
          @subscribe.user_id = user.id
          @subscribe.ticket_id = @ticket.id
          @subscribe.save!
        end
      end
    end
  end

  def comment_init
    @comments = Comment.find(:all,
      :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ",
      @project.id, @ticket.id, @site.id], :order=>"created_at asc")
  end
end
