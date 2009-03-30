class StatusHandler < Mongrel::HttpHandler
   def initialize
      @mutex = Mutex.new
   end

   def process(request, response)
      id = request.params['PATH_INFO'].slice(1, 20)  # trim leading slash

      response.start(200) do |head, out|
         head["Content-Type"] = "application/xml"
         out.write status(id).to_xml
      end
   end

   def status(id)
      rows = @mutex.synchronize { ActiveRecord::Base.connection.select_all("select * from auctions where id=#{id.to_i}") }
      return { 'error' => ‘No such record’ } if rows.length < 1
      return rows.first
   end
end

uri "/status", :handler => StatusHandler.new, :in_front => true
