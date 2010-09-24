class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  include AuthenticatedSystem
  
  before_filter :get_location_from_ip

  def show

  end
  
  protected
    def get_location_from_ip
      unless session[:location].present?
        begin
          user_location = get_ip_location(request.env[:REMOTE_ADDR])
          session[:location] = {
            :lat => user_location['latitude'],
            :long => user_location['longitude']
          }
        rescue Exception => e
          session[:location] = {:lat => '', :long => ''}
          logger.warn "Cannot get geo location from ip #{request.env[:REMOTE_ADDR]}. Error => #{e}"
        end
      end
    end
    
    def get_ip_location(ip)
      conn = PGconn.connect( :dbname => 'ipinfo', :user => 'postgres' )
      result = conn.exec("SELECT * FROM geo_ips where ip_start <= inetmi('#{ip}','0.0.0.0') order by ip_start desc limit 1")
      return result.first
    end
end
