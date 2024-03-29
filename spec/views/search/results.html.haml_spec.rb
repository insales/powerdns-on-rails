require 'spec_helper'

describe "search/results" do

  before(:each) do
    @admin = FactoryBot.create(:admin)
    allow(view).to receive(:current_user).and_return(@admin)
    allow(view).to receive(:current_token).and_return(nil)
  end

  it "should handle no results" do
    assign(:results, [])

    render

    rendered.should have_css("strong", :text => "No domains found")
  end

  it "should handle results within the pagination limit" do
    1.upto(4) do |i|
      zone = Domain.new
      zone.id = i
      zone.name = "zone-#{i}.com"
      zone.save( :validate => false ).should be_truthy
    end

    assign(:results, Domain.search( 'zone', 1, @admin ))

    render 

    rendered.should have_css("table a", :text => "zone-1.com")
  end

  it "should handle results with pagination and scoping" do
    1.upto(100) do |i|
      zone = Domain.new
      zone.id = i
      zone.name = "domain-#{i}.com"
      zone.save( :validate => false ).should be_truthy
    end

    assign(:results, Domain.search( 'domain', 1, @admin ))

    render

    rendered.should have_css("table a", :text => "domain-1.com")
  end

end
