require 'net/http'
require 'json' 
require 'uri'

namespace :workers do
  desc 'Resolve Taxonomy for those records who had not yet been resolved.'
  task :resolve_taxonomy => :environment do
    config = YAML::load_file("#{Rails.root}/config/credentials.yml")
    ft = GData::Client::FusionTables.new
    ft.clientlogin(config["ft_username"],config["ft_password"])
    
    res = GData::Client::FusionTables::Data.parse(ft.sql_get("select ROWID,scientificName from 225363 WHERE gbifResolvedId='' and scientificName not equal to ''"))
    res.body.each do |rec|
      rowid = rec[:rowid]      
      spec_id= get_taxon_uid(rec[:scientificname])
      if(spec_id)
        puts spec_id
        taxonomy = get_taxonomy_by_uid(spec_id)
        ft.sql_post("UPDATE 225363 SET 
          gbifResolvedId='#{spec_id}',
          kingdom='#{taxonomy[:kingdom]}',
          phylum='#{taxonomy[:phylum]}',
          class='#{taxonomy[:t_class]}',
          'order'='#{taxonomy[:t_order]}',
          family='#{taxonomy[:family]}',
          genus='#{taxonomy[:genus]}'
        WHERE ROWID='#{rowid}'")
      else
        puts "not found:#{rec[:scientificname]}"
        ft.sql_post("UPDATE 225363 SET taxonomyResolved='failed' WHERE ROWID='#{rowid}'")
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