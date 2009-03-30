class Project::Ticket::AttachmentsController < ApplicationController
  resources :comments
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access

  
end
