/**
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// AMQ Ajax handler
// This class provides the main API for using the Ajax features of AMQ. It
// allows JMS messages to be sent and received from javascript when used
// with the org.apache.activemq.web.MessageListenerServlet
//
var amq =
{ 
  hasFirebug: "console" in window && "firebug" in window.console && window.console.firebug.indexOf("1.0") > -1,
  
  // The URI of the MessageListenerServlet
  uri: '/amq',

  // Polling. Set to true (default) if waiting poll for messages is needed
  poll: true,
  
  // Poll delay. if set to positive integer, this is the time to wait in ms before
  // sending the next poll after the last completes.
  _pollDelay: 0,
  
  _request: 0,

  _first: true,
  
  _handlers: new Array(),

  _M: function(id, params)
  {
  	amq._first = false;
    try
    {
      var handler = amq._handlers[id]
	  amq._log('amq._M(' + id + ', [' + params + '])');
	  
	  if (handler != null) 
	  {	  	
	  	handler(params);
	  } else 
	  {
	  	amq._log('Unhandled response \'' + id + '\': [' + params + ']');
	  }
	}
    catch(e)
    {
      alert(e);
    }
  },
  
  _handlePoll: function(id, params)
  {
  	amq._request = amq._request - 1;
    if (amq._pollDelay>0)
    {
  	  setTimeout('amq._sendPoll()',amq._pollDelay);
    }
    else
    {
  	  amq._sendPoll();
    }
  },
  
  addDataHandler : function(id,handler)
  {
    amq._handlers[id]=handler;
  },

  removeDataHandler : function(id)
  {
    amq._handlers[id]=null;
  },
  
  _sendPoll: function(request)
  {
  	amq._request = amq._request + 1;
	
	if (amq._request == 0)
	{
  		var options = AjaxMessagingOptions;
		options['RESET'] = (amq._first) ? 1 : 0;  	
		new Ajax.Request(amq.uri, { method: 'get', parameters: options, onSuccess: amq._handlePoll });
	}	 
  },
  
  _startPolling : function()
  {
   if (amq.poll)
      amq._sendPoll();
  },
  
  _onError : function(msg)
  {
  	alert("A server error occurred: " + msg);
  },
  
  _log : function(msg)
  {
  	if (amq.hasFirebug)
        console.log("amq: " + msg) ;
  }
    
};

Event.observe(window, 'load', amq._startPolling);