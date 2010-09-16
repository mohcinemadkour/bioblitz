class Api::IdentificationsController < ApplicationController

  #Provide a new Identification Request Object
  def new
    
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft = GData::Client::FusionTables.new
    ft.clientlogin(config["ft_username"], config["ft_password"])
    tables = ft.show_tables
    ft_observations  = tables.select{|t| t.id == "225363"}.first
    
    observs = ft_observations.select("ROWID,observedBy,dateTime,latitude,longitude,occurrenceRemarks,verbatimLocality,associatedMedia", "WHERE identificationRequested='Yes' LIMIT 1").first
    result = observs
    
    respond_to do |format|
      format.json do 
        render :json => result.to_json
      end
    end
    
  end
  
  #Provide an identification
  def update
    
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft = GData::Client::FusionTables.new
    ft.clientlogin(config["ft_username"],config["ft_password"])
    
    if (params[:id])
      taxonomy=resolve_taxonomy(params[:id])
      
      sql="INSERT INTO 254492(observationRowId,scientificName,identificationTime,author,application,colId,colLsid,kingdom
      ,phylum,class,'order',family,genus) VALUES(
        '#{params[:rowid]}',
        '#{taxonomy[0]['s']}',
        '#{Time.now.strftime("%m-%d-%Y %H:%M:%S")}',
        '#{params[:username]}',
        'Taxonomizer',
        '#{taxonomy[0]['id_col']}',
        '#{taxonomy[0]['lsid']}',
        '#{taxonomy[0]['k']}',
        '#{taxonomy[0]['p']}',
        '#{taxonomy[0]['c']}',
        '#{taxonomy[0]['o']}',
        '#{taxonomy[0]['f']}',
        '#{taxonomy[0]['g']}'
      )"
      
      # sql="UPDATE 225363 SET 
      #   colId='#{taxonomy[0]['id_col']}',
      #   colLsid='#{taxonomy[0]['lsid']}',
      #   kingdom='#{taxonomy[0]['k']}',
      #   phylum='#{taxonomy[0]['p']}',
      #   class='#{taxonomy[0]['c']}',
      #   'order'='#{taxonomy[0]['o']}',
      #   family='#{taxonomy[0]['f']}',
      #   genus='#{taxonomy[0]['g']}',
      #   identifiedBy='#{params[:username]}',
      #   identificationReferences='Taxonomizer',
      #   scientificName='#{taxonomy[0]['s']}'
      # WHERE ROWID='#{params[:rowid]}'"
    else
      
      sql="INSERT INTO 254492(observationRowId,scientificName,identificationTime,author,application) VALUES(
        '#{params[:rowid]}',
        '#{params[:scientificName]}',
        '#{Time.now.strftime("%m-%d-%Y %H:%M:%S")}',
        '#{params[:username]}',
        'Taxonomizer',
      )"
      
      # sql="UPDATE 225363 SET scientificName = #{params[:scientificName]},
      #       identifiedBy='#{params[:username]}', 
      #       identificationReferences='Taxonomizer',
      #       colId='failed' 
      #   WHERE ROWID=#{params[:rowid]}"
        
    end
    
    ft.sql_post(sql)
    
    #TODO
    # sql="SELECT numIdentifications FROM 225363 WHERE ROWID=#{params[:rowid]}"
    # sql="UPDATE 225363 SET numIdentifications=numIdentifications+1 WHERE ROWID=#{params[:rowid]}"
    # ft.sql_post(sql)
    
    #/api/provide_identification?rowid=2323&id=232323
    #/api/provide_identification?rowid=2323&scientificName=Pepito
    result ="ok"
    
    
    respond_to do |format|
      format.json do 
        render :json => result.to_json
      end
    end
  end

end


def resolve_taxonomy(id)
  conn = PGconn.connect( :dbname => 'col',:user=>'postgres' )
  result =conn.exec("select lsid,k,c,o,p,f,id_col,g,s from taxonomy where id = #{id}")
end