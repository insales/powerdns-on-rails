require 'spec_helper'

describe MacroStepsController do

  before(:each) do
    sign_in(FactoryBot.create(:admin))

    @macro = FactoryBot.create(:macro)
    @step = FactoryBot.create(:macro_step_create,
                    :macro => @macro,
                    :name => 'localhost',
                    :content => '127.0.0.1')
  end

  it "should create a valid step" do
    expect {
      post :create, params: { :macro_id => @macro.id, :macro_step => {
          :action => 'create',
          :record_type => 'A',
          :name => 'www',
          :content => '127.0.0.1'
        }, :format => 'js' }
        @macro.macro_steps.reload
    }.to change(@macro.macro_steps, :count)

    response.should render_template('macro_steps/create')
  end

  it "should position a valid step correctly" do
    post :create, params: { :macro_id => @macro.id, :macro_step => {
      :action => 'create',
      :record_type => 'A',
      :name => 'www',
      :content => '127.0.0.1',
      :position => '1'
    }, :format => 'js' }

    assigns(:macro_step).position.should == 1
  end

  it "should not create an invalid step" do
    expect {
      post :create, params: { :macro_id => @macro.id, :macro_step => {
          :position => '1',
          :record_type => 'A'
        }, :format => 'js' }
        @macro.macro_steps.reload
    }.to_not change(@macro.macro_steps, :count)

    response.should render_template('macro_steps/create')
  end

  it "should accept valid updates to steps" do
    put :update, params: { :macro_id => @macro.id, :id => @step.id, :macro_step => {
        :name => 'local'
      }, :format => 'js' }

    response.should render_template('macro_steps/update')

    @step.reload.name.should == 'local'
  end

  it "should not accept valid updates" do
    put :update, params: { :macro_id => @macro.id, :id => @step.id, :macro_step => {
        :name => ''
      }, :format => 'js' }

    response.should render_template('macro_steps/update')
  end

  it "should re-position existing steps" do
    FactoryBot.create(:macro_step_create, :macro => @macro)

    put :update, params: {
      :macro_id => @macro.id, :id => @step.id,
      :macro_step => { :position => '2' }
    }, xhr: true

    @step.reload.position.should == 2
  end

  it "should remove selected steps when asked" do
    delete :destroy, params: { :macro_id => @macro, :id => @step.id, :format => 'js' }

    flash[:info].should_not be_blank
    response.should be_redirect
    response.should redirect_to(macro_path(@macro))

    expect { @step.reload }.to raise_error( ActiveRecord::RecordNotFound )
  end

end
