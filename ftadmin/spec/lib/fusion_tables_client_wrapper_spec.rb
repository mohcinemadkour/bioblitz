require 'spec_helper'
require 'fusion_tables_client_wrapper'

describe 'Fusion Tables client wrapper' do
  context "Selecting data" do
    before do
      FusionTablesClientWrapper.table_name 'Bioblitz2010Identifications'
      FusionTablesClientWrapper.field :observationRowId
      FusionTablesClientWrapper.field :scientificName
      FusionTablesClientWrapper.field :identificationTime
      FusionTablesClientWrapper.field :author
      FusionTablesClientWrapper.field :application
      FusionTablesClientWrapper.field :colId
      FusionTablesClientWrapper.field :colLsid
      FusionTablesClientWrapper.field :kingdom
      FusionTablesClientWrapper.field :phylum
      FusionTablesClientWrapper.field :class
      FusionTablesClientWrapper.field :order
      FusionTablesClientWrapper.field :family
      FusionTablesClientWrapper.field :genus
      FusionTablesClientWrapper.field :lat
      FusionTablesClientWrapper.field :lon
    end

    it "returns all data from fusion table" do
      results = FusionTablesClientWrapper.all
      results.should_not be_empty
    end
    
    it "returns filtered data from fusin table" do
      results = FusionTablesClientWrapper.where("phylum='Chordata'")
      results.should_not be_empty
    end
  end
end
