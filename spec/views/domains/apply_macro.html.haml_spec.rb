require 'spec_helper'

describe "domains/apply_macro" do
  before(:each) do
    @domain = FactoryBot.create(:domain)
    @macro = FactoryBot.create(:macro)

    assign(:domain, @domain)
    assign(:macros, Macro.all)

    render
  end

  it "should have a selection of macros" do
    rendered.should have_css('select[name=macro_id]')
  end

end
