require 'spec_helper'

describe "domains/new" do

  before(:each) do
    assign(:domain, Domain.new)

    allow(view).to receive(:current_user).and_return(FactoryBot.create(:admin))
  end

  it "should have a link to create a zone template if no zone templates are present" do
    assign(:zone_templates, [])

    render

    rendered.should have_selector("a[href='#{new_zone_template_path}']")
    rendered.should_not have_selector("select[name*=zone_template_id]")
  end

  it "should have a list of zone templates to select from" do
    zt = FactoryBot.create(:zone_template)
    FactoryBot.create(:template_soa, :zone_template => zt)

    render

    rendered.should have_selector("select[name*=zone_template_id]")
    rendered.should_not have_selector("a[href='#{new_zone_template_path}']")
  end

end
