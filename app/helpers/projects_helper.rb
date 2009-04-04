module ProjectsHelper
  def from_type_to_link(type, id)
    if type.to_s == "Ticket"
      unless Ticket.find(id).nil?
        @instance = Ticket.find(id)
        if @instance.state == Ticket::STATE_RESOLVED
          return remote_link("<s>" + truncate(@instance.title, :length =>40) + "</s>", :url=> project_ticket_path(@project, @instance), :method=> :get)
        else
          return remote_link(truncate(@instance.title, :length =>40), :url=> project_ticket_path(@project, @instance), :method=> :get)
        end
      end
    end
    if type.to_s == "User"
      @instance = User.find(id)
      return remote_link(@instance.name.blank? ? @instance.email : @instance.name, :url=> project_tickets_path(@project, :user=> @instance.id), :method=> :get)
    end
    if type.to_s == "Page"
      @instance = Page.find(id)
      #return remote_link(@instance.name.blank? ? @instance.email : @instance.name, :url=> user_path(@instance), :method=> :get)
    end
    if type.to_s == "Milestone"
      @instance = Milestone.find(id)
      return remote_link(@instance.name, :url=> project_milestone_path(@project, @instance), :method=> :get)
    end
  end

  def to_user_or_to_project_link(type, id, action_id)
    @action = Action.find(action_id)
    if type.to_s == "Ticket"
      @user = User.find(@action.user_id)
      return remote_link(@user.name.blank? ? @user.email : @user.name, :url=>project_tickets_path(@project, :user=> @user.id), :method=> :get)
    end
    if type.to_s == "User"
      @instance = User.find(id)
      return remote_link(@project.name, :url=> project_path(@project), :method=> :get)
    end
    if type.to_s == "Page"
      @instance = Page.find(id)
      #return remote_link(@instance.name.blank? ? @instance.email : @instance.name, :url=> user_path(@instance), :method=> :get)
    end
    if type.to_s == "Milestone"
      @user = @action.user
      return remote_link(@user.name.blank? ? @user.email : @user.name, :url=> user_path(@user), :method=> :get)
    end
  end

  def color_from_type(type)
    if type=="Ticket"
      "<span style='text-align:center'>" + type + "</span>"
    end
#     type
  end
end
