require 'active_record'

class StatusHandler < Mongrel::HttpHandler
   def process(request, response)
      updated_at = request.params['PATH_INFO'].slice(26, 40)
      current = request.params['QUERY_STRING']

      while ticket(updated_at) == current do
         sleep 0.2
      end

      response.start(200) do |head, out|
         head["Content-Type"] = "text/html"
         out.write status(updated_at)
      end
   end

   def status(updated_at)
      connection.select_value("select id, title, responsible_id, description, created_user_id, milestone_id, project_id, urgency, severity, state, permalink from tickets where updated_at > '#{id.to_datetime}'")
   end

   def connection
      ActiveRecord::Base.connection
   end
end

uri "/project/bugtrack/tickets", :handler => StatusHandler.new, :in_front => true
