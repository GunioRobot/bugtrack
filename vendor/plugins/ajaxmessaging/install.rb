
require 'fileutils'

here = File.dirname(__FILE__)
there = defined?(RAILS_ROOT) ? RAILS_ROOT : "#{here}/../../.."

puts "Installing AjaxMessaging..."
FileUtils.cp("#{here}/media/_amq.js", "#{there}/public/javascripts/")
FileUtils.cp("#{here}/media/amq.js", "#{there}/public/javascripts/")
FileUtils.cp("#{here}/lib/ajax_messaging_handler.rb", "#{there}/lib/")
FileUtils.cp("#{here}/lib/ajax_messaging_stomp.rb", "#{there}/lib/")
FileUtils.cp("#{here}/A11G-README", "#{there}/")
FileUtils.cp("#{here}/media/a11g.yml", "#{there}/config/")
FileUtils.cp("#{here}/media/mongrel_conf.yml", "#{there}/config/")
puts "AjaxMessaging has been installed."
puts
puts IO.read(File.join(File.dirname(__FILE__), 'A11G-README'))
