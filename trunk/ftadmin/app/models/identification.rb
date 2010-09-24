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
  
  def self.create_and_update_occurrences(params, location)
    location = {:lat => '', :long => ''} unless location.present?
    
    identification_attributes = {
      :observationRowId   => params[:rowid],
      :scientificName     => params[:scientificName],
      :identificationTime => Time.now.strftime("%m-%d-%Y %H:%M:%S"),
      :author             => params[:username],
      :application        => 'Taxonomizer',
      :lat                => location[:lat],
      :lon                => location[:long]
    }

    if (params[:id])
      taxonomy = resolve_taxonomy(params[:id])
      identification_attributes[:scientificName] = taxonomy[0]['s']
      identification_attributes[:colId]          = taxonomy[0]['id_col']
      identification_attributes[:colLsid]        = taxonomy[0]['lsid']
      identification_attributes[:kingdom]        = taxonomy[0]['k']
      identification_attributes[:phylum]         = taxonomy[0]['p']
      identification_attributes[:class]          = taxonomy[0]['c']
      identification_attributes[:order]          = taxonomy[0]['o']
      identification_attributes[:family]         = taxonomy[0]['f']
      identification_attributes[:genus]          = taxonomy[0]['g']
    end
    
    Identification.create(identification_attributes)
    
    occurrences = Occurrence.where("ROWID=#{params[:rowid]}")
    unless occurrences.blank?
      numIdentifications = occurrences.first[:numidentifications].to_i + 1
      Occurrence.update_attributes(:numidentifications => numidentifications)
    end
  end
  
  private
    def self.resolve_taxonomy(id)
      conn = PGconn.connect( :dbname => 'col',:user=>'postgres' )
      result =conn.exec("select lsid,k,c,o,p,f,id_col,g,s from taxonomy where id = #{id}")
    end
end