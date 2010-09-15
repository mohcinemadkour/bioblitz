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
    
    sql="UPDATE 225363 SET scientificName = #{params[:scientificName]} WHERE ROWID=#{params[:ROWID]}"
    ft.sql_post(sql)
    
        
    result ="ok"
    
    
    respond_to do |format|
      format.json do 
        render :json => result.to_json
      end
    end
  end

end