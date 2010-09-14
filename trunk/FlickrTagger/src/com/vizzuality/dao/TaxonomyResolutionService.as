package com.vizzuality.dao
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.webapis.flickr.events.*;
	import com.vizzuality.event.ResultJsonEvent;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
		
	public class TaxonomyResolutionService extends UIComponent
	{
		public var result:ArrayCollection;
		private var animal: String;
		
		
		public function TaxonomyResolutionService() {
		}
		
		
		public function resolveTaxonomy(scientific:String):void {
			animal = scientific;
			var gbifTaxonomicService: HTTPService = new HTTPService();
			gbifTaxonomicService.method = "get";
			gbifTaxonomicService.resultFormat = "text";
			
			var gbifUrl:String = "http://data.gbif.org/species/classificationSearch?view=json&allowUnconfirmed=false&providerId=2&query="+escape(animal);
			gbifTaxonomicService.url=gbifUrl;
			gbifTaxonomicService.addEventListener(ResultEvent.RESULT,onGbifTaxonomicServiceResult);
			gbifTaxonomicService.addEventListener(FaultEvent.FAULT,onGbifTaxonomicServiceFault);
 			gbifTaxonomicService.send();
		}
		
		private function onGbifTaxonomicServiceResult(ev: ResultEvent): void {
 	        var data:String = String(ev.result);
 			var object:Object = JSON.decode(data);
 			var auxArray: Array = new Array();
 			auxArray = object.classificationSearch.classification;
 			jsonData(auxArray);
		}
		
		private function onGbifTaxonomicServiceFault(ev: FaultEvent): void {
		 	var auxArray: Array = new Array();
 			jsonData(auxArray);
		}
		
		private function jsonData(jsonArray: Array):void {
			var count:int = jsonArray.length;	
			var taxonomyArray: Array= new Array({kingdom:"",phylum:"",clas:"",orde:"",family:"",genus:"",binomial:""});
						
			if 	(jsonArray!=null) {	
				for(var i:int=0;i<count;i++) {
					var str: String;
					str = jsonArray[i].scientificName;
					
					if (str.toLowerCase()!=animal.toLowerCase()) {	
						trace(jsonArray[i].rank + "-> "+jsonArray[i].scientificName);
						switch(i) {
						    case 0:
						        taxonomyArray[0].kingdom = jsonArray[i].scientificName;
						        break;
						    case 1:
						        taxonomyArray[0].phylum = jsonArray[i].scientificName;
						        break;
						    case 2:
						        taxonomyArray[0].clas = jsonArray[i].scientificName;
						        break;
						    case 3:
						        taxonomyArray[0].orde = jsonArray[i].scientificName;
						        break;
						    case 4:
						        taxonomyArray[0].family = jsonArray[i].scientificName;
						        break;
						    case 5:
						        taxonomyArray[0].genus = jsonArray[i].scientificName;
						        break;
						    default:
						        taxonomyArray[0].binomial = jsonArray[i].scientificName;
						        break;
						}
					} else {
						taxonomyArray[0].binomial = jsonArray[i].scientificName;
						i=count;
					}
				}			
				
			} 
			var out:ResultJsonEvent = new ResultJsonEvent(ResultJsonEvent.JSON_RESULT);
			out.jsonData = taxonomyArray;
	        dispatchEvent(out);
			
		}
 
	}
	
}