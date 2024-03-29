require 'spec_helper'

describe "templates/new" do

  context "and new templates" do
    before(:each) do
      assign(:zone_template, ZoneTemplate.new)
    end

    it "should have a list of users if provided" do
      FactoryBot.create(:quentin)

      render

      rendered.should have_css('select#zone_template_user_id')
    end

    it "should render without a list of users" do
      render

      rendered.should_not have_css('select#zone_template_user_id')
    end

    it "should render with a missing list of users (nil)" do
      render

      rendered.should_not have_css('select#zone_template_user_id')
    end

    it "should show the correct title" do
      render

      rendered.should have_css('h1.underline', :text => 'New Zone Template')
    end
  end

end
