require 'cgi'
require 'json'

module AjaxMessaging
  CONFIG = YAML::load(ERB.new(IO.read("#{RAILS_ROOT}/config/a11g.yml")).result).freeze
  
  def self.send_data(channels, func, data)
    begin      
	    conn = Stomp::Connection.new CONFIG['USERNAME'], CONFIG['PASSWORD'], CONFIG['HOST'], CONFIG['PORT'], CONFIG['RELIABLE']
      out = "amq._M('" + CGI::escape(func) + "', " + JSON.unparse(Array(data)) + ");"
            
	    channels.each() {|c|
	      conn.send "/topic/#{CGI::escape(c)}", out, {'persistent'=>'false'}
	    }
    ensure
      $stdout.puts('error in send_data: ' + $!)
      conn.disconnect
    end   
  rescue
    false
  end
  
  def self.send_to(uid, func, data)
    # TODO optimize the logic here!
    uid = Array(uid)    
    uid.each(){ |user|
	    channel = "user.#{user}"
	    self.send_data([channel], func, data)
     } 
  end
  
  def self.html_and_string_escape(s)
     i = s.gsub(/[']/, '\\\\\'')
     i.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
  end
  
end