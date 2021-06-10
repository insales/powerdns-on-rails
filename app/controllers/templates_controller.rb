class TemplatesController < InheritedResources::Base

  defaults :resource_class => ZoneTemplate, :collection_name => 'zone_templates', :instance_name => 'zone_template'
  respond_to :html, :xml, :json

  protected

  def collection
    @zone_templates = ZoneTemplate.user(current_user).to_a
  end

  public

  def create
    @zone_template = ZoneTemplate.new(params[:zone_template])
    @zone_template.user = current_user unless current_user.admin?

    create! { zone_template_path( @zone_template ) if @zone_template.persisted? }
  end

end
