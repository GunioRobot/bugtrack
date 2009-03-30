class Project::Ticket::TagController < ApplicationController
  resource
  def before_destroy
    @tag = Tag.find(params[:tag_id])
    @ticket.taggings.find(:first, :conditions=>["tag_id = ?", @tag.id]).destroy
  end
  def after_destroy    
    xhr_render_tag
  end

  def xhr_render_tag
    if request.xhr?
      render :update do |page|
        page.replace_html :tags, :partial=>"tags"
        page.replace_html "tag_cloud", :partial=>"/layouts/tag_cloud"
      end
    end
  end
end
