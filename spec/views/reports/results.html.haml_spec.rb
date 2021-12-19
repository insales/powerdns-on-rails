require 'spec_helper'

describe "reports/results" do

  let!(:admin) { FactoryBot.create(:admin) }

  it "should handle no results" do
    assign(:results, [])

    render

    response.should have_css("strong", text: "No users found")
  end

  it "should handle results within the pagination limit" do
    assign(:results, User.search( 'a', 1 ))

    render

    response.should have_css("table") do
      with_tag "a", "admin"
    end
  end

  it "should handle results with pagination and scoping" do
    1.upto(100) do |i|
      user = User.new
      user.login = "test-user-#{i}"
      expect(user.save(validate: false)).to be_truthy
    end

    assign(:results, User.search( 'test-user', 1 ))

    render

    response.should have_css("table") do
      with_tag "a", "test-user-1"
    end
  end

end
