require 'net/http'
require 'json' 
require 'uri'
require 'pg'

namespace :workers do
  desc 'Resolve Taxonomy for those records who had not yet been resolved.'
  task :resolve_taxonomy => :environment do
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft = GData::Client::FusionTables.new
    ft.clientlogin(config["ft_username"],config["ft_password"])
    
    res = GData::Client::FusionTables::Data.parse(ft.sql_get("select ROWID,scientificName from 225363 WHERE colId='' and scientificName not equal to ''"))
    res.body.each do |rec|
      rowid = rec[:rowid]      
      taxonomy=resolve_taxonomy(rec[:scientificname])
      if(taxonomy.any?)
        puts taxonomy[0]['id_col']
        ft.sql_post("UPDATE 225363 SET 
          colId='#{taxonomy[0]['id_col']}',
          colLsid='#{taxonomy[0]['lsid']}',
          kingdom='#{taxonomy[0]['k']}',
          phylum='#{taxonomy[0]['p']}',
          class='#{taxonomy[0]['c']}',
          'order'='#{taxonomy[0]['o']}',
          family='#{taxonomy[0]['f']}',
          genus='#{taxonomy[0]['g']}'
        WHERE ROWID='#{rowid}'")
      else
        puts "not found:#{rec[:scientificname]}"
        ft.sql_post("UPDATE 225363 SET colId='failed' WHERE ROWID='#{rowid}'")
      end
      
    end
  end
  
  desc 'Pregenerate zoomIt images'
  task :zoomit => :environment do
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft = GData::Client::FusionTables.new
    ft.clientlogin(config["ft_username"],config["ft_password"])    
    res = GData::Client::FusionTables::Data.parse(ft.sql_get("select ROWID,associatedMedia from 225363 WHERE zoomitId='' and associatedMedia not equal to ''"))
    res.body.each do |rec|
      rowid = rec[:rowid] 
      #Loop over the images on the observation
      ids= Array.new
      rec[:associatedmedia].each(" ") {|image|
        connection = Net::HTTP.new("api.zoom.it")
        res = ""
        connection.start do |http|
          req = Net::HTTP::Get.new("/v1/content/?url="+URI.escape(image))
          res = http.request(req)
        end  
        response=JSON.parse(res.body)
        ids << response['id']
        puts response['id']
      }
      ft.sql_post("UPDATE 225363 SET zoomitId='#{ids.join(" ")}' WHERE ROWID='#{rowid}'")
    end 
  end
  
  
  desc 'Import EOL Flickr pics'
  task :import_eol => :environment do
    
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft = GData::Client::FusionTables.new
    ft.clientlogin(config["ft_username"],config["ft_password"])
        
    FlickRaw.api_key="1a8e02e2fbbe211e0c03c9c7b648d5ab"
    FlickRaw.shared_secret="55852420f91848dd"
    
    flickrpics = flickr.photos.search(
                            :privacy_filter=>"1",
                            :accuracy=>"1",
                            :safe_search=>"1",
                            :content_type=>"1",
                            :machine_tags=>"taxonomy:binomial=",
                            :group_id=>"806927@N20",
                            :per_page=>200,
                            :extras=>"url_l",
                            :has_geo=>"1")
                            
    flickrpics.each do |pic|
      if(pic.respond_to?(:url_l))
        pic_url=pic.url_l
        info = flickr.photos.getInfo :photo_id => pic['id']
        scientificName=''
        info.tags.each do |tag|
          if(tag.raw.include?("taxonomy:binomial"))
            scientificName = tag.raw.gsub("taxonomy:binomial=","")
          end
        end 
        puts scientificName
      
        sql="INSERT INTO 225363(scientificName,associatedMedia) VALUES('#{scientificName}','#{pic_url}')"
        ft.sql_post(sql)
      end
    end                        
    
  end
  
end

def resolve_taxonomy(name)
  conn = PGconn.connect( :dbname => 'col',:user=>'postgres' )
  result =conn.exec("select lsid,k,c,o,p,f,id_col,g,s from taxonomy where s like '#{name}%'  limit 1")
end


















def get_taxon_uid(name)
  connection = Net::HTTP.new("es.mirror.gbif.org")
  res = ""
  connection.start do |http|
    req = Net::HTTP::Get.new("/ws/rest/taxon/list?rank=species&scientificname="+URI.escape(name))
    res = http.request(req)
  end  
  response=res.body  
  
  doc = Nokogiri::XML(response)
  if doc.xpath("//gbif:dataProvider").size > 0
    doc.xpath("//gbif:dataProvider").each do |data_provider|
      if data_provider.attr('gbifKey').to_i == 1
        if data_provider.xpath("gbif:dataResources//tc:TaxonConcept").size > 0
          return data_provider.xpath("gbif:dataResources//tc:TaxonConcept")[0].attr('gbifKey').to_i
        end
      end
    end
  end
rescue
  nil
end


def get_taxonomy_by_uid(uid)
  connection = Net::HTTP.new("es.mirror.gbif.org")
  res = ""
  connection.start do |http|
    req = Net::HTTP::Get.new("/ws/rest/taxon/get?key="+URI.escape(uid.to_s))
    res = http.request(req)
  end  
  response=res.body
  
  
  doc = Nokogiri::XML(response)
  # If the uid doesn't exist
  return nil if doc.xpath("//tc:TaxonConcept").size == 0
  result = {}
  doc.xpath("//tc:TaxonConcept").each do |concept|
    next if concept.attr('status') != 'accepted'
    # If is included in other species
    if concept.xpath("tc:hasRelationship//tc:relationshipCategory").size > 0 && concept.xpath("tc:hasRelationship//tc:relationshipCategory").map{|r| r.attr('resource')}.include?("http://rs.tdwg.org/ontology/voc/TaxonConcept#IsIncludedIn")
      concept.xpath("tc:hasRelationship//tc:Relationship").each do |relationship|
        if relationship.xpath("tc:relationshipCategory")[0].attr('resource') == 'http://rs.tdwg.org/ontology/voc/TaxonConcept#IsIncludedIn'
          if included_uid = relationship.xpath("tc:toTaxon")[0].attr('resource').split('/').last
            if included_uid != uid
              # debug
              # puts "get_taxon: #{uid} > #{included_uid}"
              return self.get_taxon(included_uid)
            end
          end
        end
      end
    else
    # Get Taxon attributes
      if concept.xpath("tc:hasRelationship//tc:relationshipCategory").size > 0 && concept.xpath("tc:hasRelationship//tc:relationshipCategory")[0].attr('resource') == "http://rs.tdwg.org/ontology/voc/TaxonConcept#IsChildTaxonOf"
        case concept.xpath("tc:hasName//tn:rankString")[0].inner_text
          when 'species'
            result[:species] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
          when 'genus'
            result[:genus] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
          when 'family'
            result[:family] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
          when 'order'
            result[:t_order] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
          when 'class'
            result[:t_class] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
          when 'phylum'
            result[:phylum] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
        end
      elsif concept.xpath("tc:hasName//tn:rankString")[0].inner_text == 'kingdom'
        result[:kingdom] = concept.xpath("tc:hasName//tn:nameComplete").inner_text
      end
    end
  end
  # debug
  # if result.keys.size < 7
  #   puts "Resultado incompleto: #{uid}"
  # end
  result
rescue
  {}
end