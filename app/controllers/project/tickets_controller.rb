class Project::TicketsController < ApplicationController
  resources :tickets, :member=>[:update_data]
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  auto_complete_for :ticket, :tags, :limit=> 5, :order=>"name Desc"
  layout "projects"

  def before_index
    
    xhr_render_index
  end

  def before_edit
    xhr_render_edit
  end

  def before_new
    @milestones = @project.milestones
    @ticket.milestone_id = @milestone.id unless @milestone.nil?
    xhr_render_new
  end

  def before_show
    @tags = @ticket.tags
    @subscribe = Subscribe.find(:first, :conditions=>["user_id = ? and ticket_id = ?", @current_user.id, @ticket.id])
#     @ticket = Ticket.find_by_permalink(params[:id])
    @comments = Comment.find(:all,
                :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
    if params[:popup].nil?
      xhr_render_show
    else
      xhr_render_popup
    end
  end

  def before_update
    @ticket.updated = Ticket::UPDATED
    @ticket.email_sender = Ticket::NOT_SEND
    @ticket.update_attributes(params[:ticket])
    @ticket.save
    unless @ticket.errors.empty?
      xhr_render_edit
    end
  end

  def after_update
    unless @ticket.responsible_id.nil?
      if Subscribe.find(:all, :conditions=>["ticket_id = ? and user_id = ?", @ticket.id, @ticket.responsible_id]).empty?
        @subsrb = Subscribe.new
        @subsrb.ticket_id = @ticket.id
        @subsrb.user_id = @ticket.responsible_id
        @subsrb.save
      end
    end
    #
    subscribtions
    #
    xhr_render_index
  end
  
  def before_create
    @ticket.state = Ticket::STATE_NEW
    @ticket.project_id = @project.id
    @ticket.created_user_id = @current_user.id
    @ticket.email_sender = Ticket::NOT_SEND
    unless params[:ticket_tags].nil? || params[:ticket_tags].empty?
      params[:ticket_tags].split(",").each do |tag|
        @ticket.tag_list.add(tag)
      end
    end
    @ticket.save
    @ticket.weight = @ticket.id
#     @attachment = Attachment.new(params[:attachment])
#    @attachment = @ticket.attachments.create(params[:attachment])
#     @attachment.user_id = @current_user.id
#     @attachment.save
    unless @ticket.errors.empty?
      xhr_render_new
    end
  end

  def after_create
    @sub = Subscribe.new
    @sub.ticket_id = @ticket.id
    @sub.user_id = @ticket.created_user_id
    @sub.save
    #
    subscribtions
    #
    unless @ticket.responsible_id.nil?
      @subsrb = Subscribe.new
      @subsrb.ticket_id = @ticket.id
      @subsrb.user_id = @ticket.responsible_id
      @subsrb.save
    end
    @action = @ticket.actions.create(:user_id => @current_user.id,
                            :what_did=> "was created by", :project_id=> @project.id)
    @action.save
    #
    xhr_render_index
  end

  def after_destroy
    xhr_render_index
  end

private
  def xhr_render_edit
    if request.xhr?
      render :update do |page|
        page.replace_html :filters, ""
        page.replace_html :body, :partial=>"edit"
      end
    end
  end

  def xhr_render_new
    if request.xhr?
      render :update do |page|
        page.replace_html :body, :partial=>"new"
        page.replace_html :users_list, :partial=> "/layouts/project_users"
      end
    end
  end

  def xhr_render_show
    @comments = Comment.find(:all,
                  :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
    if request.xhr?
      render :update do |page|
        page.replace_html :body, :partial=>"show"
        page.replace_html :filters, ""
        page.replace_html "tag_cloud", :partial=>"/layouts/tag_cloud"
      end
    end
  end

  def xhr_render_popup
    if request.xhr?
      if params[:popup] == 1.to_s
        render :update do |page|
          @comments = Comment.find(:all,
                  :conditions=>["project_id = ? and ticket_id = ? and account_id = ? ", @project.id, @ticket.id, @site.id], :order=>"created_at asc")
          page.replace_html "ticket_#{@ticket.id}", :partial=> "popup_show", :object=> @comments
          page.show "ticket_#{@ticket.id}"
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
    
    condition = ""
    join = ""
    order = ""
    condition << " tickets.project_id = #{@project.id}"
    modify_params
    @str_param = str_param
    unless params[:states].nil?
      states = params[:states].values.join(",")
      condition << " and tickets.state in (#{states})"
    end
    unless params[:users].nil?
      users = params[:users].values.join(",")
      condition << " and tickets.responsible_id in (#{users})"
    end
    unless params[:create_users].nil?
      users = params[:create_users].values.join(",")
      condition << " and tickets.created_user_id in (#{users})"
    end
    condition << " and tickets.responsible_id = #{params[:current_user].to_i} and (tickets.state = 1 or tickets.state = 2)" unless params[:current_user].nil?
    condition << " and tickets.state = #{params[:state].to_i}" unless params[:state].nil?
    condition << " and tickets.responsible_id = #{params[:user].to_i} and (tickets.state = 1 or tickets.state = 2)" unless params[:user].nil?
    condition << " and tickets.created_user_id = #{params[:created_user].to_i}" unless params[:created_user].nil?
    unless params[:tag].nil?
      condition << " and tickets_tags.name like '#{params[:tag]}'"
      join << "join taggings tickets_taggings ON tickets_taggings.taggable_id = tickets.id AND tickets_taggings.taggable_type = 'Ticket' join tags tickets_tags ON tickets_tags.id = tickets_taggings.tag_id"
    end
    order << "tickets.state Asc, tickets.urgency Desc, tickets.severity Desc, tickets.weight Desc"
    
    ids = sort_tickets.split(",")
    unless ids.empty?
      old_ids = ""
      length = Ticket.find(:all, :conditions=>condition, :joins=>join, :order=>order).size
      i = 0
      Ticket.find(:all, :conditions=>condition, :joins=>join, :order=>order).each do |ticket|
        i += 1
        old_ids << ticket.id.to_s
        old_ids << "," if i != length
      end
      old_ids = old_ids.split(",")
      
      if ids != old_ids && !ids.empty? && !old_ids.empty?
        for i in (0..length) do
          if ids[i] != old_ids[i]
            old_ind = old_ids.index(ids[i])
            new_ind = ids.index(old_ids[i])
            if old_ind < new_ind
              cur_ticket = Ticket.find(ids[new_ind])
              prev_ticket = Ticket.find(ids[new_ind - 1])
              cur_ticket.comments.create(:commentable_type =>"Ticket", :commentable_id => cur_ticket.id,
                                         :user_id => @current_user.id, :ticket_id => cur_ticket.id,
                                         :project_id =>@project.id, :account_id => @site.id,
                                         :comment => "changed",
                                         :before_state=> cur_ticket.state, :before_urgency=> cur_ticket.urgency,
                                         :before_severity=> cur_ticket.severity, :before_responsible_id=> cur_ticket.responsible_id,
                                         :before_milestone_id=> cur_ticket.milestone_id,
                                         :state => prev_ticket.state, :urgency => prev_ticket.urgency,
                                         :severity => prev_ticket.severity, :responsible_id => prev_ticket.responsible_id,
                                         :milestone_id => prev_ticket.milestone_id)
            elsif old_ind > new_ind
              cur_ticket = Ticket.find(ids[old_ind])
              prev_ticket = Ticket.find(ids[i + 1])
              cur_ticket.comments.create(:commentable_type =>"Ticket", :commentable_id => cur_ticket.id,
                                         :user_id => @current_user.id, :ticket_id => cur_ticket.id,
                                         :project_id =>@project.id, :account_id => @site.id,
                                         :comment => "changed",
                                         :before_state=> cur_ticket.state, :before_urgency=> cur_ticket.urgency,
                                         :before_severity=> cur_ticket.severity, :before_responsible_id=> cur_ticket.responsible_id,
                                         :before_milestone_id=> cur_ticket.milestone_id,
                                         :state => prev_ticket.state, :urgency => prev_ticket.urgency,
                                         :severity => prev_ticket.severity, :responsible_id => prev_ticket.responsible_id,
                                         :milestone_id => prev_ticket.milestone_id)
              
            else
              puts old_ind, " : ", new_ind
            end
            prev_weight = prev_ticket.weight
            cur_ticket.weight = prev_weight
            cur_ticket.state = prev_ticket.state
            cur_ticket.urgency = prev_ticket.severity
            cur_ticket.severity = prev_ticket.urgency
            cur_ticket.save!
            prev_ticket.save!
            break
          end
        end
      end
    end
    #
    
    if request.xhr?
#       @tickets = Ticket.find(:all, :conditions=>condition, :joins=>join, :order=>order)
      @tickets_count = Ticket.find(:all, :conditions=>condition, :joins=>join).size

      @tickets_pager = ::Paginator.new(@tickets_count, 100) do |offset, per_page|
          Ticket.find(:all, :conditions=>condition, :joins=>join, :limit => per_page, :offset => offset,
                                  :order=>order)
      end
      @tickets_page = @tickets_pager.page(params[:page])
      render :update do |page|
        page.replace_html "body", :partial=>"index"
        page.replace_html "filters", :partial=>"filters"

        page[:filters].show()
        page.replace_html "tag_cloud", :partial=>"/layouts/tag_cloud"
      end
    end
  end

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

  def str_param
    str_param = ""
    params.keys.each do |key|
      if key != 'controller' && key != 'commit' && key != 'project_id' && key != 'action' && key != 'tickets_list'
        logger.info key
        params[key].each do |value|
          if value.is_a?(Array)
            str_param << "#{key}[#{value[0]}]=#{value[1]}&"
          else
            str_param << "#{key}=#{value}&"
          end
        end
      end
    end
    return str_param
  end

  def modify_params
    unless params["tickets_list"].nil?
      ticket_params = params["tickets_list"][0]
      ticket_params.split('&').each do |param|
        unless param.empty?
          unless param.index('[').nil?
            param = param.gsub("]", "").split("[")
            params[param[0].to_sym] = {} if params[param[0].to_sym].nil?
            values = param[1].split("=")
            params[param[0].to_sym][values[0].to_sym] = values[1]
          else
            param = param.split("=")
            params[param[0].to_sym] = param[1]
          end
        end
      end
    end
  end

  def sort_tickets
    ids = ""
    unless params["tickets_list"].nil?
      i = 0
      for i in (1..(params[:tickets_list].size - 1)) do
        ids << params[:tickets_list][i].gsub("menu_ticket_", "")
        ids << "," if i != (params[:tickets_list].size - 1)
      end
    end
    return ids
  end

end
