
require 'fileutils'

here = File.dirname(__FILE__)
there = defined?(RAILS_ROOT) ? RAILS_ROOT : "#{here}/../../.."

puts "Removing AjaxMessaging..."
FileUtils.rm("#{there}/public/javascripts/amq.js")
FileUtils.rm("#{there}/public/javascripts/_amq.js")
FileUtils.rm("#{there}/lib/ajax_messaging_handler.rb")
FileUtils.rm("#{there}/lib/ajax_messaging_stomp.rb")
FileUtils.rm("#{there}/A11G-README")
FileUtils.rm("#{there}/config/a11g.yml")
puts "Done."
