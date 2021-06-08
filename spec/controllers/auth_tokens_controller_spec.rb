require 'spec_helper'

describe AuthTokensController do

  it "should not allow access to admins or owners" do
    sign_in( FactoryGirl.create(:admin) )
    post :create
    response.code.should eql("302")

    sign_in(FactoryGirl.create(:quentin))
    post :create
    response.code.should eql("302")
  end

  it "should bail cleanly on missing auth_token" do
    sign_in(FactoryGirl.create(:token_user))

    post :create

    response.code.should eql("422")
  end

  it "should bail cleanly on missing domains" do
    sign_in(FactoryGirl.create(:token_user))

    post :create, :auth_token => { :domain => 'example.org' }

    response.code.should eql("404")
  end

  it "bail cleanly on invalid requests" do
    domain = FactoryGirl.create(:domain)

    sign_in(FactoryGirl.create(:token_user))

    post :create, :auth_token => { :domain => domain.name }
    response.should have_selector('error')
  end

  describe "generating tokens" do

    let(:domain) { FactoryGirl.create(:domain) }
    before(:each) do
      sign_in(FactoryGirl.create(:token_user))

      @domain = domain
      @params = { :domain => @domain.name, :expires_at => 1.hour.since.to_s(:rfc822) }
    end

    it "with allow_new set" do
      post :create, :auth_token => @params.merge(:allow_new => 'true')

      response.should have_selector('token > expires')
      response.should have_selector('token > auth_token')
      response.should have_selector('token > url')

      assigns(:auth_token).should_not be_nil
      assigns(:auth_token).domain.should eql( @domain )
      assigns(:auth_token).should be_allow_new_records
    end

    it "with remove set" do
      a = FactoryGirl.create(:www, :domain => @domain)
      post :create, :auth_token => @params.merge(:remove => 'true', :record => ["www.#{domain.name}"])

      response.should have_selector('token > expires')
      response.should have_selector('token > auth_token')
      response.should have_selector('token > url')

      assigns(:auth_token).remove_records?.should be_truthy
      assigns(:auth_token).can_remove?( a ).should be_truthy
    end

    it "with policy set" do
      post :create, :auth_token => @params.merge(:policy => 'allow')

      response.should have_selector('token > expires')
      response.should have_selector('token > auth_token')
      response.should have_selector('token > url')

      assigns(:auth_token).policy.should eql(:allow)
    end

    it "with protected records" do
      a = FactoryGirl.create(:a, :domain => @domain)
      www = FactoryGirl.create(:www, :domain => @domain)
      mx = FactoryGirl.create(:mx, :domain => @domain)

      post :create, :auth_token => @params.merge(
        :protect => ["#{domain.name}:A", "www.#{domain.name}"],
        :policy => 'allow'
      )

      response.should have_selector('token > expires')
      response.should have_selector('token > auth_token')
      response.should have_selector('token > url')

      assigns(:auth_token).should_not be_nil
      assigns(:auth_token).can_change?( a ).should be_falsey
      assigns(:auth_token).can_change?( mx ).should be_truthy
      assigns(:auth_token).can_change?( www ).should be_falsey
    end

    it "with protected record types" do
      mx = FactoryGirl.create(:mx, :domain => @domain)

      post :create, :auth_token => @params.merge(:policy => 'allow', :protect_type => ['MX'])

      assigns(:auth_token).can_change?( mx ).should be_falsey
    end

    it "with allowed records" do
      a = FactoryGirl.create(:a, :domain => @domain)
      www = FactoryGirl.create(:www, :domain => @domain)
      mx = FactoryGirl.create(:mx, :domain => @domain)

      post :create, :auth_token => @params.merge(:record => [domain.name])

      assigns(:auth_token).can_change?( www ).should be_falsey
      assigns(:auth_token).can_change?( a ).should be_truthy
      assigns(:auth_token).can_change?( mx ).should be_truthy
    end

  end
end
