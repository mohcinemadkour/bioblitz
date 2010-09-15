require 'zip/zipfilesystem'

class Api::DwcArchiveController < ApplicationController
  
    def new
      
      tmp_file_name = "dwca_#{randomFileNameSuffix(7)}"
      open("#{Rails.root}/tmp/#{tmp_file_name}.zip", "wb") { |file|
        file.write(Net::HTTP.get(URI.parse(params[:url])))
      }
      
      unzip("#{Rails.root}/tmp/#{tmp_file_name}.zip","#{Rails.root}/tmp/#{tmp_file_name}")
      
      FasterCSV.foreach("#{Rails.root}/tmp/#{tmp_file_name}/DarwinCore.txt") do |line|
        puts line
      end
      # #Now connnect to Fusion Tables
      # config = YAML::load_file("#{Rails.root}/config/credentials.yml")
      # ft = GData::Client::FusionTables.new
      # ft.clientlogin(config["ft_username"], config["ft_password"])

      result="ok"
      respond_to do |format|
        format.json do 
          render :json => result.to_json
        end
      end
      
      
    end
    
end

def randomFileNameSuffix (numberOfRandomchars)
  s = ""
  numberOfRandomchars.times { s << (65 + rand(26))  }
  s
end



def unzip (zip_file_path,to_folder_path)
  if File.exists?( zip_file_path ) == false
    puts "Zip file #{zip_file_path} does not exist!"
    return
  end

  if File.exists?( to_folder_path ) == false
    FileUtils.mkdir( to_folder_path )
  end

  zip_file = Zip::ZipFile.open( zip_file_path )
  Zip::ZipFile.foreach( zip_file_path ) do | entry |
    file_path = File.join( to_folder_path, entry.to_s )
    if File.exists?( file_path )
      FileUtils.rm( file_path )
    end
    zip_file.extract( entry, file_path )
  end

end