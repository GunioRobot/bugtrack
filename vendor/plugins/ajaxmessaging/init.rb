require 'ajax_messaging'
require 'ajax_messaging_helper'

ActionView::Base.send(:include, AjaxMessaging::AjaxMessagingHelper)
