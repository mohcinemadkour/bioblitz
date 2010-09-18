class Identification < FusionTablesClientWrapper
  
  table_name 'Bioblitz2010Identifications'
  
  field :observationRowId
  field :scientificName
  field :identificationTime
  field :author
  field :application
  field :colId
  field :colLsid
  field :kingdom
  field :phylum
  field :class
  field :order
  field :family
  field :genus
  field :lat
  field :lon

end