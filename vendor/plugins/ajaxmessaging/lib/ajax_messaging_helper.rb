module AjaxMessaging
  module AjaxMessagingHelper
    def a11g_listen_to(channels = nil, unique_id = nil)      
      unique_id ||= session.session_id
      channels = Array(channels || AjaxMessaging::CONFIG["DEFAULT_CHANNELS"])
      channels << "user.#{unique_id}"
      channels = channels.map { |c| CGI.escape(c.to_s) }.to_json
      
      output = javascript_tag %{var AjaxMessagingOptions = {UID: "#{unique_id}", CHANNELS: #{channels} };} 
      output += javascript_include_tag "_amq"
      output += javascript_tag %{
amq.uri = '#{AjaxMessaging::CONFIG["BASE_URL"]}';
amq._pollDelay = #{AjaxMessaging::CONFIG["POLL_DELAY"]};}      
      output
    end    
  end
end