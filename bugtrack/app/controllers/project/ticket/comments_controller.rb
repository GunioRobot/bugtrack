class Project::Ticket::CommentsController < ApplicationController
  resources :comments
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  layout "projects"

  def before_index
    @comments = Comment.find(:all,
                :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
    if request.xhr?
      if params[:close] = 1
        render :update do |page|
          page.hide "comment"
          page.replace_html "comment", ""
        end
      end
    end
  end

  def before_new
    if request.xhr?
      @title = Comment.find(params[:comment_id]).title
      @comment = Comment.new
      @comment.title = "Re:" + @title
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
      end
    end
  end

  def after_update
    if request.xhr?
      render :update do |page|
        page.replace_html "edit_#{@comment.id}", :partial=> 'comment'
      end
    end
  end

  def before_create
    @comment = @ticket.comments.create(:commentable_type=>"Ticket", :commentable_id=> @ticket.id,
                                       :user_id=> @current_user.id, :ticket_id=>@ticket.id,
                                       :project_id=>@project.id, :title=>params[:comment][:title], :comment=> params[:comment][:comment],
                                       :account_id => @site.id)
  end
  
  def after_create
    @comments = Comment.find(:all,
                :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
    if request.xhr?
      render :update do |page|
        page.replace_html "comments", :partial=>"index"
        page.hide "comment"
      end
    end
  end

  def after_destroy
    if request.xhr?
      render :update do |page|
        page.replace_html "comment_#{@comment.id}", ""
        page.hide "comment"
      end
    end
  end
end
