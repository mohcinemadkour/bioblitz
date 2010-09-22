class Api::IdentificationsController < ApplicationController
  
  #Provide an identification
  def update
    
    #get clients location
    user_location= get_ip_location(request.remote_ip)
    
    
    
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft = GData::Client::FusionTables.new
    ft.clientlogin(config["ft_username"],config["ft_password"])
    
    if (params[:id])
      taxonomy=resolve_taxonomy(params[:id])
      
      sql="INSERT INTO #{config['ft_identifications_table']}(observationRowId,scientificName,identificationTime,author,application,colId,colLsid,kingdom
      ,phylum,class,'order',family,genus,lat,lon) VALUES(
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
        '#{taxonomy[0]['g']}',
        #{user_location['latitude']},
        #{user_location['longitude']}
      )"
    else
      
      sql="INSERT INTO #{config['ft_identifications_table']}(observationRowId,scientificName,identificationTime,author,application,lat,lon) VALUES(
        '#{params[:rowid]}',
        '#{params[:scientificName]}',
        '#{Time.now.strftime("%m-%d-%Y %H:%M:%S")}',
        '#{params[:username]}',
        'Taxonomizer',
        #{user_location['latitude']},
        #{user_location['longitude']}        
      )"
        
    end
    
    ft.sql_post(sql)
    
    sql="SELECT numIdentifications FROM #{config['ft_occurrence_table']} WHERE ROWID=#{params[:rowid]}"
    data = GData::Client::FusionTables::Data.parse(ft.sql_get(sql)).body

    numIdentifications=(data[0][:numidentifications].to_i) + 1
    


    sql="UPDATE #{config['ft_occurrence_table']} SET numIdentifications=#{numIdentifications} WHERE ROWID='#{params[:rowid]}'"
    ft.sql_post(sql)
        
    result ="ok"
    
    
    respond_to do |format|
      format.json do 
        render :json => result.to_json
      end
    end
  end

end

def get_ip_location(ip)
  conn = PGconn.connect( :dbname => 'ipinfo',:user=>'postgres' )
  result = conn.exec("SELECT * FROM geo_ips where ip_start <= inetmi('#{ip}','0.0.0.0') order by ip_start desc limit 1")
  return result[0]
end

def resolve_taxonomy(id)
  conn = PGconn.connect( :dbname => 'col',:user=>'postgres' )
  result =conn.exec("select lsid,k,c,o,p,f,id_col,g,s from taxonomy where id = #{id}")
end