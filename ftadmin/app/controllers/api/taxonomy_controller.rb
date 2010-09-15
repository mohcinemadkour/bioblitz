class Api::TaxonomyController < ApplicationController
  
  
  def index
    conn = PGconn.connect( :dbname => 'col',:user=>'postgres' )
    limit = (params[:limit])?params[:limit]:3
    
    result =conn.exec("select id,lsid,k,c,o,p,f,id_col,g,s from taxonomy where s like '#{escape_sql(params[:query]).capitalize}%'  limit #{escape_sql(limit)}")
    
    respond_to do |format|
      format.json do 
        render :json => result.to_json, :callback => params[:callback]
      end
    end
    
  end
  
  def escape_sql(input)
    input.gsub(/\\/, '\&\&').gsub(/'/, "''")
  end
end