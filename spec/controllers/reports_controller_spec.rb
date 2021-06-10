require 'spec_helper'

describe ReportsController, "index" do
  before(:each) do
    sign_in(FactoryBot.create(:admin))

    FactoryBot.create(:domain)
    q = FactoryBot.create(:quentin)
    FactoryBot.create(:domain, :name => 'example.net', :user => q)
  end

  it "should display all users to the admin" do
    get 'index'

    response.should render_template('reports/index')
    assigns(:users).should_not be_empty
    assigns(:users).size.should be(1)
  end

  it "should display total system domains and total domains to the admin" do
    get 'index'

    response.should render_template('reports/index')
    assigns(:total_domains).should be(Domain.count)
    assigns(:system_domains).should be(1)
  end
end

describe ReportsController, "results" do
  before(:each) do
    sign_in(FactoryBot.create(:admin))
  end

  it "should display a list of users for a search hit" do
    FactoryBot.create(:aaron)
    FactoryBot.create(:api_client_user)

    get 'results', params: { :q => "a" }

    response.should render_template('reports/results')
    assigns(:results).should_not be_empty
    assigns(:results).size.should be(3)
  end

  it "should redirect to reports/index if the search query is empty" do
    get 'results', params: { :q => "" }

    response.should be_redirect
    response.should redirect_to( reports_path )
  end

end

describe ReportsController , "view" do
  before(:each) do
    sign_in(FactoryBot.create(:admin))
  end

  it "should show a user reports" do
    get "view", params: { :id => FactoryBot.create(:aaron).id }

    response.should render_template("reports/view")
    assigns(:user).should_not be_nil
    assigns(:user).login.should == 'aaron'
  end

end

