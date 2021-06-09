require 'spec_helper'

describe "templates/show.html.haml" do
  context "for complete templates" do
    before(:each) do
      @zone_template = FactoryBot.create(:zone_template)
      FactoryBot.create(:template_soa, :zone_template => @zone_template)

      assign(:zone_template, @zone_template)
      assign(:record_template, RecordTemplate.new( :record_type => 'A' ))

      render
    end

    it "should have the template name" do
      rendered.should have_css('h1', :text => @zone_template.name)
    end

    it "should have a table with template overview" do
      rendered.should have_selector('table.grid td', :text => 'Name')
      rendered.should have_selector('table.grid td', :text => 'TTL')
    end

    it "should have the record templates" do
      rendered.should have_selector('h1', :text => 'Record templates')
      rendered.should have_selector('table#record-table')
    end

    it "should not have an SOA warning" do
      violated "ZoneTemplate does not have SOA" unless @zone_template.has_soa?

      rendered.should_not have_selector('div#soa-warning')
    end
  end


  context "for partial templates" do
    before(:each) do
      @zone_template = FactoryBot.create(:zone_template)
      assign(:zone_template, @zone_template)
      assign(:record_template, RecordTemplate.new( :record_type => 'A' ))

      render
    end

    it "should have an SOA warning" do
      rendered.should have_css('div#soa-warning')
    end

  end
end
