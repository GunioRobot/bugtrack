class Project::MilestonesController < ApplicationController
  resources :milestones
  logged_in_access
  domain_existens_access
  account_member_access
  project_member_access
  layout "projects"
end
