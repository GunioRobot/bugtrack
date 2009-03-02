class Project::Ticket::CommentsController < ApplicationController
  resources :comments
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  layout "projects"

  def before_index
    @comment = Comment.new
    @comments = Comment.find(:all,
                :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
    if request.xhr?
      if params[:close] = 1
        render :update do |page|
          page.hide "comment"
        end
      end
    end
  end

  def before_new
    if request.xhr?
      render :update do |page|
        page.replace_html "comment", :partial=>"new"
        page.show "comment"
      end
    end
  end

  def before_edit
    if request.xhr?
      @comments = Comment.find(:all,
                :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
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
    @comment = @ticket.comments.create(:commentable_type=>"Ticket", :commentable_id=> @ticket.id,
                                       :user_id=> @current_user.id, :ticket_id=>@ticket.id,
                                       :project_id=>@project.id, :title=>params[:comment][:title], :comment=> params[:comment][:comment],
                                       :account_id => @site.id)
#     @comment.actions.create(:user_id=>@current_user.id, :project_id=>@project.id, :what_did=>"State changed from ")

    
    @comment.save
    unless @comment.errors.empty?
      render :update do |page|
        page.replace_html "comment", :partial=>"new", :object=> @comment
        page.replace_html "tag_cloud", :partial=>"/layouts/tag_cloud"
      end
      return
    else
      @ticket.actions.create(:user_id=>@current_user.id, :project_id=>@project.id, :what_did=> "was updated by")
      @ticket.tag_list.add(params[:tag_list]) unless params[:tag_list].nil? || params[:tag_list].empty?
      @ticket.update_attributes(params[:ticket])
    end
  end
  
  def after_create
    @comments = Comment.find(:all,
                :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
    unless params[:all].nil?
      UserMailer.deliver_updated_ticket_notification(@project, @ticket, User.find(@ticket.responsible_id), request)
    else
      UserMailer.deliver_updated_ticket_notification(@project, @ticket, User.find(@ticket.responsible_id), request, emails)
    end
    if request.xhr?
      render :update do |page|
        page.replace_html "tag_cloud", :partial=>"/layouts/tag_cloud"
        page.replace_html "comments", :partial=>"index"
      end
    end
  end

  def after_destroy
    if request.xhr?
      render :update do |page|
        page.replace_html "comment_#{@comment.id}", ""
      end
    end
  end

  private
  def emails
    emails = ""
    for user in @project.users
      if params["user_#{user.id}"]
        emails << "," + user.email
      end
    end
    return emails
  end
end
