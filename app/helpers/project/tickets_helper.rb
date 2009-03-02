module Project::TicketsHelper
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

  def ticket_severity(severity)
    if severity == Ticket::HIGH_SEVERITY
      return "<span>" + _("High") + "</span>"
    end
    if severity == Ticket::LOW_SEVERITY
      return "<span>" + _("Low") + "</span>"
    end
    if severity == Ticket::MEDIUM_SEVERITY
      return "<span>" + _("Medium") + "</span>"
    end
  end

  def ticket_urgency(urgency)
    if urgency == Ticket::HIGH_URGENCY
      return "<span>" + _("High") + "</span>"
    end
    if urgency == Ticket::LOW_URGENCY
      return "<span>" + _("Low") + "</span>"
    end
    if urgency == Ticket::MEDIUM_URGENCY
      return "<span>" + _("Medium") + "</span>"
    end
  end
end
