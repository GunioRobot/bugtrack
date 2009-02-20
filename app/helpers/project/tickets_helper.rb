module Account::Project::TicketsHelper
  def ticket_state(state)
    if state == Ticket::STATE_NEW
      return "<span>" + _("New") + "</span>"
    end
    if state == Ticket::STATE_OPEN
      return "<span>" + _("Open") + "</span>"
    end
    if state == Ticket::STATE_RESOLVED
      return "<span>" + _("Resolved") + "</span>"
    end
    if state == Ticket::STATE_HOLD
      return "<span>" + _("Hold") + "</span>"
    end
    if state == Ticket::STATE_INVALID
      return "<span>" + _("Invalid") + "</span>"
    end
    if state == Ticket::STATE_WORK_FOR_ME
      return "<span>" + _("Work for me") + "</span>"
    end
  end
  def ticket_priority(priority)
    if priority == Ticket::HIGH_PRIORITY
      return "<span>" + _("High") + "</span>"
    end
    if priority == Ticket::LOW_PRIORITY
      return "<span>" + _("Low") + "</span>"
    end
    if priority == Ticket::MEDIUM_PRIORITY
      return "<span>" + _("Medium") + "</span>"
    end
  end
end
