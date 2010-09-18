require 'spec_helper'

describe 'Identification model' do
  it "should return all records" do
    results = Identification.all
    results.should_not be_empty
  end
end
