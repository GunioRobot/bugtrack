class UserMailer < ActionMailer::Base
helper :application

  def add_user_notification(project, user, new_user, request)
    setup_email(new_user)
    @subject    += 'Bugtracer.com'
    @body[:project]  = project.name
    @body[:account_url] = "http://#{request.subdomains[0]}.#{CONFIG['domain']}"
  end

  def signup_notification(project, user, new_user, request)
    setup_email(new_user)
    @subject    += 'Bugtracer.com'

    @body[:project_name]  = project.name
    @body[:url]  = "http://bugtracker.com/activate_user/?activation_code=#{new_user.activation_code}"
    @body[:main_url] = "http://#{request.subdomains[0]}.#{CONFIG['domain']}"
  end

  def new_user_notification(new_user, request)
    setup_email(new_user)
    @subject    += 'Bugtracer.com'

    @body[:login]  = new_user.email
    @body[:password] = new_user.password
    @body[:main_url] = "http://#{request.subdomains[0]}.#{CONFIG['domain']}"
  end

  def ticket_notification(project, ticket, emails, account_name)
    @recipients  = "#{emails}"
    @from        = "sarvar.muminov@gmail.com"
#    @from        = "soqqa@soqqa.uz"
    @subject     = ""
    @sent_on     = Time.now
    @subject    += 'Bugtracer.com'

    @body[:project_name]  = project.name
    @body[:title]  = ticket.title
    @body[:description] = ticket.description
    @body[:permalink] = "http://#{account_name}.#{CONFIG['domain']}/project/#{project.permalink}"
    @body[:main_url] = "http://#{account_name}.#{CONFIG['domain']}"
  end

  def updated_ticket_notification(project, ticket, emails, account_name)
    @recipients  = "#{emails}"
    @from        = "sarvar.muminov@gmail.com"
    @subject     = ""
    @sent_on     = Time.now
    @subject    += 'Bugtracer.com'

    @body[:project_name]  = project.name
    @body[:title]  = ticket.title
    @body[:description] = ticket.description
    @body[:permalink] = "http://#{account_name}.#{CONFIG['domain']}/project/#{project.permalink}/ticket/#{ticket.permalink}/edit"
    @body[:main_url] = "http://#{account_name}.#{CONFIG['domain']}"
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
