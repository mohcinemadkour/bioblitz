require 'spec_helper'
require 'fusion_tables_client_wrapper'

describe 'Fusion Tables client wrapper' do
  context "Identifications table" do
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
    
    it "returns filtered data from fusion table" do
      results = FusionTablesClientWrapper.where("phylum='Chordata'")
      results.should_not be_empty
    end
    
    it "inserts one row in fusion table" do
      max_id = FusionTablesClientWrapper.next(:observationrowid)

      assert_difference "FusionTablesClientWrapper.all.length", 1 do
        FusionTablesClientWrapper.create(
          :observationRowId => max_id,
          :author           => 'Test',
          :phylum           => 'Chordata',
          :class            => 'Mammalia',
          :order            => 'Carnivora',
          :colId            => 1
        )
        
      end

      inserted_record = FusionTablesClientWrapper.where("'observationRowId'=#{max_id}").first

      inserted_record[:author].should match(/Test/)
      inserted_record[:phylum].should match(/Chordata/)
      inserted_record[:class].should match(/Mammalia/)
      inserted_record[:order].should match(/Carnivora/)
      inserted_record[:colid].should match(/1/)

    end
    
    it "updates one row in fusion table" do
      row_id = FusionTablesClientWrapper.max(:rowid)
      
      FusionTablesClientWrapper.update_attributes({:phylum => 'Arthropoda', :class => 'Insecta'}, row_id)
      updated_record = FusionTablesClientWrapper.where("rowid = #{row_id}").first
      
      updated_record[:phylum].should match(/Arthropoda/)
      updated_record[:class].should match(/Insecta/)
    end
  end
end
