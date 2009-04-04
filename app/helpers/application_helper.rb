# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
#   include ApplicationController
  def _(text)
    text
  end

  def tagger_form_for(name, *args, &block)
    options = args.is_a?(Hash) ? args.pop : {}
    options = options.merge(:builder => TagBuilder)
    args = (args << options)
    form_for(name, *args, &block)
  end

  def projectrole(role, project = nil)
    @current_user = User.find_by_remember_token(cookies[:auth_token]) unless cookies[:auth_token].nil?
    unless project.nil?
      @roles = Role.find(:all, :joins=>"Join user_projects up On roles.id = up.role_id",
      :conditions=>["up.user_id =? and up.project_id = ? ", @current_user.id, project.id])
    end
    @user_roles = @current_user ? @roles.collect{|r| r.name} : ""
    return true if @user_roles.include?(role)
    false
  end



  def remote_link(name, *args, &block)
    options = args.is_a?(Array) ? args.pop : {}
    url = options[:url]
    options[:before] = "Element.show('spinner'); cookies.set('active_page', '#{url}')"
    options[:complete] = "Element.hide('spinner')"
    args << options
    link_to_remote(name, *args, &block)
  end

  def paginator(pager, page, link_method, params={})
    return "" if pager.number_of_pages <= 1
    pages = (1..(pager.number_of_pages > 4 ? 3 : pager.number_of_pages)).to_a
    pages+= ((page.number-2)..(page.number+2)).to_a
    pages+= ((pager.number_of_pages-2)..pager.number_of_pages).to_a
    pages = pages.uniq.delete_if{|p| p < 1 || p > pager.number_of_pages}
    prev_pg = nil
    "<div class='pagination'>#{_("Pages")}: " +
    (pages.collect do |pg|
      s = (pg != 1 && prev_pg != pg - 1 ? "... " : "")
      prev_pg = pg
      s +
      (pg == page.number ?
        "<b>#{pg}</b>" : remote_link(pg, :url=> link_method.call(params.update(:page => pg)), :method=> :get)
      )
    end).join(" ") +
    "</div>"
  end

  def err_for(obj, attr)
    return '' unless obj.errors[attr]
    "<div class='ferr'>#{h(_(obj.errors[attr].is_a?(Array) ? obj.errors[attr].join(', ') : obj.errors[attr]))}</div>"
  end

  mattr_accessor :time_class
    mattr_accessor :time_output
    
    self.time_class = Time
    self.time_output = {
      :today            => 'today',
      :yesterday        => 'yesterday',
      :tomorrow         => 'tomorrow',
      :initial_format   => '%b %d',
      :last_week_format => '%A',
      :time_format      => '%l:%M %p',
      :year_format      => ', %Y'
    }

    def relative_date(time, in_past = false)
      date  = time.to_date
      today = time_class.now.to_date
      if date == today
        time.respond_to?(:min) ? time.strftime(time_output[:time_format]) : time_output[:today]
      elsif date == (today - 1)
        time_output[:yesterday]
      elsif date == (today + 1)
        time_output[:tomorrow]
      elsif in_past && (today-6..today-2).include?(date)
        fmt = time_output[:last_week_format].dup
        time.strftime(time_output[:last_week_format])
      else
        fmt  = time_output[:initial_format].dup
        fmt << time_output[:year_format] unless date.year == today.year
        time.strftime(fmt)
      end
    end
    
    def relative_date_in_past(time)
      relative_date(time,true)
    end
    
    def relative_date_span(times)
      times = [times.first, times.last].collect!(&:to_date)
      times.sort!
      if times.first == times.last
        relative_date(times.first)
      else
        first = times.first; last = times.last; now = time_class.now
        returning [first.strftime('%b %d')] do |arr|
          arr << ", #{first.year}" unless first.year == last.year
          arr << ' - '
          arr << last.strftime('%b') << ' ' unless first.year == last.year && first.month == last.month
          arr << last.day
          arr << ", #{last.year}" unless first.year == last.year && last.year == now.year
        end.to_s
      end
    end
    
    def relative_time_span(times)
      times = [times.first, times.last].collect!(&:to_time)
      times.sort!
      if times.first == times.last
        "#{prettier_time(times.first)} #{relative_date(times.first)}"
      elsif times.first.to_date == times.last.to_date
          same_half = (times.first.hour/12 == times.last.hour/12)
          "#{prettier_time(times.first, !same_half)} - #{prettier_time(times.last)} #{relative_date(times.first)}"

      else
        first = times.first; last = times.last; now = time_class.now
        [prettier_time(first)].tap do |arr|
          arr << ' '
          arr << first.strftime('%b %d')
          arr << ", #{first.year}" unless first.year == last.year
          arr << ' - '
          arr << prettier_time(last)
          arr << ' '
          arr << last.strftime('%b') << ' ' unless first.year == last.year && first.month == last.month
          arr << last.day
          arr << ", #{last.year}" unless first.year == last.year && last.year == now.year
        end.to_s
      end
    end
    
    def prettier_time(time, ampm=true)
      time.strftime("%I:%M#{" %p" if ampm}").sub(/^0/, '')
    end

    def get_color(i, k, urgency, severity)
      background = ""
      
      if urgency == 3 && severity == 1
        background = "<div id = 'priority_#{7}' style='width: 30px; height:30px; background:#efbbb2' onclick= 'Popup.choose_color(#{7})'>"
      end
      if urgency == 3 && severity == 2
        background = "<div id = 'priority_#{8}' style='width: 30px; height:30px; background:#ff8c00' onclick= 'Popup.choose_color(#{8})'>"
      end
      if urgency == 3 && severity == 3
        background = "<div id = 'priority_#{9}' style='width: 30px; height:30px; background:#ff2400' onclick= 'Popup.choose_color(#{9})'>"
      end
      if urgency == 2 && severity == 1
        background = "<div id = 'priority_#{4}' style='width: 30px; height:30px; background:#8aff00' onclick= 'Popup.choose_color(#{4})'>"
      end
      if urgency == 2 && severity == 2
        background = "<div id = 'priority_#{5}' style='width: 30px; height:30px; background:#fff000' onclick= 'Popup.choose_color(#{5})'>"
      end
      if urgency == 2 && severity == 3
        background = "<div id = 'priority_#{6}' style='width: 30px; height:30px; background:#ff8c00' onclick= 'Popup.choose_color(#{6})'>"
      end
      if urgency == 1 && severity == 1
        background = "<div id = 'priority_#{1}' style='width: 30px; height:30px; background:#11a300' onclick= 'Popup.choose_color(#{1})'>"
      end
      if urgency == 1 && severity == 2
        background = "<div id = 'priority_#{2}' style='width: 30px; height:30px; background:#8aff00' onclick= 'Popup.choose_color(#{2})'>"
      end
      if urgency == 1 && severity == 3
        background = "<div id = 'priority_#{3}' style='width: 30px; height:30px; background:#efbbb2' onclick= 'Popup.choose_color(#{3})'>"
      end
      background
    end
  
    def priority_block(urgency = 0, severity = 0)
      str = "<table style='margin-left:50px;'>"
      g = 7
      m = g
      for i in [3,2,1]
        str << "<tr>"
        for k in (1..3)
          str << "<td>
                    #{ if(urgency == i && severity == k ) then get_color(i, k, urgency, severity) else "<div id = 'priority_#{m}' style='width: 30px; height:30px;' onclick= 'Popup.choose_color(#{m})'>" end }
                  </td>"
          m+= 1
        end
        m = g - 3
        g = m
        str << "</tr>"
      end
      str << "</table>"
    end
  
end
