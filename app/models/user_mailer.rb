class UserMailer < ActionMailer::Base
helper :application

  def signup_notification(project, user, new_user, request)
    setup_email(new_user)
    @subject    += 'Bugtracer.com'

    @body[:project_name]  = project.name
    @body[:url]  = "http://bugtracker.com/activate_user/?activation_code=#{new_user.activation_code}"
    @body[:main_url] = "http://#{request.subdomains[0]}.#{CONFIG['domain']}"
  end

  def ticket_notification(project, ticket, user, new_user, request)
    setup_email(new_user)
    @subject    += 'Bugtracer.com'

    @body[:project_name]  = project.name
    @body[:title]  = ticket.title
    @body[:description] = ticket.description
    @body[:permalink] = "http://#{request.subdomains[0]}.#{CONFIG['domain']}/project/#{project.permalink}/ticket/#{ticket.permalink}/edit"
    @body[:main_url] = "http://#{request.subdomains[0]}.#{CONFIG['domain']}"
  end  
protected
  def setup_email(new_user)
    @recipients  = "#{new_user.email}"
    @from        = "sarvar.muminov@gmail.com"
#    @from        = "soqqa@soqqa.uz"
    @subject     = ""
    @sent_on     = Time.now
    @body[:user] = new_user
  end
end
