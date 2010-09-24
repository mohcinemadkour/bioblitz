require 'spec_helper'

describe Api::IdentificationsController do
  include RSpec::Rails::ControllerExampleGroup
  
  before do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  it "should add a new identification with taxonomer ip geo-location" do
    assert_difference "Identification.all.length", 1 do
      request.env[:REMOTE_ADDR]  = '208.67.222.222'
      get 'update', :username => 'Test', :rowid => 6017, :id => 1164692
    end
    max_rowid = Identification.max(:rowid)
    identification = Identification.where("rowid=#{max_rowid}").first

    identification[:author].should == 'Test'
    identification[:lat].should == '37.7898'
    identification[:lon].should == '-122.394'

    response.should be_success
  end
end