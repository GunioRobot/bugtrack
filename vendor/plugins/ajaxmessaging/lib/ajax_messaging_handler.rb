require 'rubygems'
require 'ajax_messaging_stomp'
#require 'cache'
require 'timeout'
require 'ajax_messaging'
require 'ajax_messaging_helper'

CONFIG = YAML::load(ERB.new(IO.read("config/a11g.yml")).result).freeze

module AjaxMessaging
	class AjaxMesagingHandler < Mongrel::HttpHandler
	  include AjaxMessaging
    #class << self; attr_accessor :cache end
    
    def initialize()
      #@cache = Cache.new(:max_num => 100, :expiration => 120) {|key, conn|
      #  logger.debug "stomp: remove connection [#{key}]"
      #  conn.disconnect
      #}
    end

    # process HTTP Request
	  def process(request, response)
	    logger.debug "handle AJAX request"
	    
	    query = Mongrel::HttpRequest.query_parse(request.params["QUERY_STRING"])
	    method = request.params["REQUEST_METHOD"]
	    
	    if method == 'POST'
	      process_post(request, response, query)
	    else
	      process_get(request, response, query)
	    end
	  end
	  
	  # Handle POST
	  def process_post(request, response, query)
      body = request.body.read()
      query = HttpRequest.query_parse(body)
      process_get(request, response, query)
	  end

	  # Handle GET
	  def process_get(request, response, query)	    
      channels = query['CHANNELS']
      uid = query['UID']
      headers = {}
      headers[:ack] = 'auto'
      headers['activemq.subcriptionName'] = uid if query['RESET'] == 1
      
      if channels.nil? ||  channels == ''
        write_response(response, "amq._onError('No channels specified.')")
        return
      end

      if uid.nil? || uid == ''
        write_response(response, "amq._onError('No uid specified.')")
        return
      end
      
      
      msg = ""
      
      begin
	      logger.debug "connecting stomp"
	      conn = get_connection(uid)
      rescue
        logger.debug "connection to stomp failed: #{$!}"
        write_response(response, "amq._onError('Cannot connect to messaging server!')")
        return
      end
      
	    begin        
        channels.each() { |channel| 
          channel = "#{CONFIG['CHANNEL_ROOT']}#{HttpRequest.escape(channel)}"
          logger.debug "subscribe : #{channel}"
          conn.subscribe channel, headers
        }
        
	      timeout = query['timeout'] || CONFIG['TIMEOUT']
	      Timeout::timeout(timeout + 0.1) {
	        msg = receive_messages(conn)
	      }        

	      write_response(response,  msg)
      rescue Timeout::Error      
        logger.debug "timeout occurred"
        write_response(response, "")
	    rescue
	      logger.error "an error occurred: #{$!}"      
	      write_response(response, "amq._onError('An error occurred: #{HttpRequest.escape($!)}')")
      ensure
        conn.disconnect
	    end
	  end
	  
	  private 
    def get_connection(uid)
      #if @cache[uid].nil?
      #  logger.debug "stomp: new connection [#{uid}]"
      #else
      #  logger.debug "stomp: cached connection [#{uid}]"
      #end
      
      #@cache[uid] ||= Stomp::Connection.new CONFIG['USERNAME'], CONFIG['PASSWORD'], CONFIG['HOST'], CONFIG['PORT'], CONFIG['RELIABLE']
      Stomp::CustomHeaderConnection.new CONFIG['USERNAME'], CONFIG['PASSWORD'], CONFIG['HOST'], CONFIG['PORT'], CONFIG['RELIABLE'], CONFIG['RECONNECT_DELAY'], { "client-id" => uid }
    end
    
	  # Return all pending message
	  def receive_messages(conn)
	    output = ""
	    msg = conn.receive
      
	    begin
	      Timeout::timeout(0.1) {
	        while !msg.nil?
	          output += msg.body
	          msg = conn.receive
	        end
	      }

	    rescue Timeout::Error
	      # do nothing, timeout is expected
	    end
      
	    logger.debug "receive messages: #{output}"
	    return output
	  end
	  
	  def write_response(response, output)
	    response.start(200) do |head, out|    
	      head["Content-Type"] = "text/javascript"
	      out.write output
	    end
	  end
    
	  def logger()
	    @@logger = Logger.new(STDOUT) unless defined?(@logger)
	    @@logger
	  end    
	end
end

uri CONFIG['BASE_URL'], :handler => AjaxMessaging::AjaxMesagingHandler.new, :in_front => true
