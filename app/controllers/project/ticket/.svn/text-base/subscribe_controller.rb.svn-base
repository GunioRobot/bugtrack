class Project::Ticket::SubscribeController < ApplicationController
  resource :subscribe
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  layout "projects"


  def before_create
    @subscribe.ticket_id = @ticket.id
    @subscribe.user_id = @current_user.id
  end

  def after_create
    xhr_render_subscribe
  end

  def before_destroy
    @subscribe = Subscribe.find(params[:subscribe_id])
  end

  def after_destroy
    @subscribe = nil
    xhr_render_subscribe
  end

  def xhr_render_subscribe
    if request.xhr?
      render :update do |page|
        page.replace_html :subscribe, :partial=> "subscribe"
      end
    end
  end  
end
