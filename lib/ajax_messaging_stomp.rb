require 'io/wait'
require 'socket'
require 'thread'
require 'stomp'

module Stomp

  # STOMP Connection that allow custom headers when connect
  class CustomHeaderConnection < Connection

    def CustomHeaderConnection.open(login = "", passcode = "", host='localhost', port=61613, reliable=FALSE, reconnectDelay=5, headers = {})
      CustomHeaderConnection.new login, passcode, host, port, reliable, reconnectDelay, headers        
    end

    # Create a connection, requires a login and passcode.
    # Can accept a host (default is localhost), and port
    # (default is 61613) to connect to
    # headers: allow custom headers for apache active mq when connect 
    def initialize(login, passcode, host='localhost', port=61613, reliable=false, reconnectDelay=5, headers = {})
      @host = host
      @port = port
      @login = login
      @passcode = passcode
      @transmit_semaphore = Mutex.new
      @read_semaphore = Mutex.new
      @socket_semaphore = Mutex.new
      @reliable = reliable
      @reconnectDelay = reconnectDelay
      @closed = FALSE
      @subscriptions = {}
      @failure = NIL
      socket headers
    end
    
    def socket headers = {}
      # Need to look into why the following synchronize does not work.
      #@read_semaphore.synchronize do
        s = @socket;
        while s == NIL or @failure != NIL
          @failure = NIL
          begin
            s = TCPSocket.open @host, @port
            headers[:login] = @login
            headers[:passcode] = @passcode
            _transmit(s, "CONNECT", headers)
            @connect = _receive(s)                        
            # replay any subscriptions.
            @subscriptions.each { |k,v| _transmit(s, "SUBSCRIBE", v) }
          rescue 
            @failure = $!;
            s=NIL;
            raise unless @reliable
            $stderr.print "connect failed: " + $! +" will retry in #{@reconnectDelay}\n";                
            sleep(@reconnectDelay);
          end
        end
        @socket = s
        return s;
      #end
    end
  end
end

