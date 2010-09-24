class Api::IdentificationsController < ApplicationController
  
  #Provide an identification
  def update

    Identification.create_and_update_occurrences(params, session[:location])
    
    respond_to do |format|
      format.json { render :json => 'ok'.to_json }
    end
  end

end