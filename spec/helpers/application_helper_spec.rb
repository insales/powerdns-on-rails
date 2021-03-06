require 'spec_helper'

describe ApplicationHelper do
  describe "link_to_cancel" do
    it "on new records should link to index" do
      html = helper.link_to_cancel( Macro.new )
      html.should have_css('a[href="/macros"]', :text => 'Cancel')
    end

    it "on existing records should link to show" do
      macro = FactoryBot.create(:macro)
      html = helper.link_to_cancel( macro )
      html.should have_css("a[href='/macros/#{macro.id}']", :text => 'Cancel')
    end
  end

end
