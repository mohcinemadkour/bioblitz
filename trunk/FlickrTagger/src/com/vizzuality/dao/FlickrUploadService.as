package com.vizzuality.dao
{
	import com.adobe.utils.DateUtil;
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.events.*;
	import com.adobe.webapis.flickr.methodgroups.Upload;
	import com.vizzuality.components.URLEncoding;
	import com.vizzuality.views.authentication.FlickrAuthorizationSettings;
	
	import flash.desktop.*;
	import flash.events.DataEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class FlickrUploadService
	{
		
		//Necessary data for upload to FusionTables and Flickr
		
		//observationData - params
		// -> lat, lon, scientific (taxon name), timestamp, pathString (all images url separate by comma),id.
		
		
		private var observationData: Object = new Object();		// Object with all data referent to observation data (taxon,group_id,lat,lon,timestamp,...)
		private var modeUpload: int = 0;						// Kind of upload (0 -> single, 1 -> group)
		private var googleService:HTTPService = new HTTPService();						
		private var AuthString:String;
		private var SERVICE_URL:String = "http://tables.googlelabs.com/api/query";
		
		
		public function FlickrUploadService() {
			googleService = new HTTPService();
			googleService.url = "https://www.google.com/accounts/ClientLogin";		
			googleService.method = "POST";
			googleService.contentType = "application/x-www-form-urlencoded";
			googleService.request.account = "GOOGLE";
			googleService.request.Email = "vizzualitybioblitz@gmail.com";
			googleService.request.Passwd = "tdwgbioblitz";
			googleService.request.source = "ImageTagger";
			googleService.request.service = "fusiontables";
			googleService.addEventListener(ResultEvent.RESULT,handleGoogleLogin);
			googleService.addEventListener(FaultEvent.FAULT,function(ev:FaultEvent):void {trace(ev.message)});
			googleService.send();
		}
		
		
		private function handleGoogleLogin(event:ResultEvent):void {  
           var textindex:int;
           AuthString = event.result.toString();
           textindex = AuthString.search("Auth");
           AuthString = AuthString.substring(textindex);
           AuthString = AuthString.replace("Auth=","");
           textindex = AuthString.length;
           textindex = textindex - 1;
           AuthString = AuthString.substring(0,textindex);
        }
		
		
		
		private function saveToFusionTables():void {
		   var obj:Object = new Object();
		   var scientific:String = (observationData.taxon!=null && observationData.taxon!="Not recognized")?observationData.taxon:"";
		   var takenDate: String = (observationData.timestamp!=null && observationData.timestamp!=undefined)?DateUtil.toW3CDTF(observationData.timestamp):"";
		   var lat:String = (observationData.lat!=null)?observationData.lat:"";
		   var lon:String = (observationData.lon!=null)?observationData.lon:"";
		   obj.sql = URLEncoding.decode("INSERT INTO 248798 (scientificName,latitude,longitude," +
			   "observedBy,recordedBy,identifiedBy,dateTime,associatedMedia,recording_app) VALUES ('"+
				scientific+"','"+
				lat+"','"+
				lon+"','"+
		   		FlickrAuthorizationSettings.accountName +"','"+
		   		FlickrAuthorizationSettings.accountName +"','"+
		   		FlickrAuthorizationSettings.accountName +"','"+
		   		takenDate +"','"+
		   		observationData.pathString+"','flickrtagger')");
		   		trace(obj.sql);
			
		   var userRequest: HTTPService = new HTTPService();
		   userRequest.contentType = "application/x-www-form-urlencoded";
           userRequest.headers = {Authorization:"GoogleLogin auth="+AuthString.toString()};               
           userRequest.url = SERVICE_URL;
           userRequest.method = "POST";
           userRequest.addEventListener(ResultEvent.RESULT,function(ev:ResultEvent):void {
           	trace(ev.message);
           });
           userRequest.addEventListener(FaultEvent.FAULT,function(ev:FaultEvent):void {
           	trace(ev.message);
           });
           userRequest.send(obj);
		}
		
		
		
		public function resolveTagsFlickr(_observationData:Object):void {
			modeUpload = 0;
			observationData = _observationData;
			observationData.pathString = "";
			var tag:String = "bioblitz2010:author=\""+FlickrAuthorizationSettings.accountName+"\",bioblitz2010:source=flickrtagger";
			if (observationData.taxon!=null && observationData.taxon!="Not recognized") {
				tag = tag + ",bioblitz2010:scientificName=\""+ observationData.taxon +"\"";
			}
			sendImageFlickr(tag, _observationData.path);
		}
		
		
		public function resolveGroupTagsFlickr(_observationData:Object):void {
			modeUpload = 1;
			observationData.group_id = observationData.id;
			observationData.pathString = "";
			var dao: DataAccessObject = new DataAccessObject();
			var sqlSentence: String = "SELECT path FROM photos WHERE group_id = '"+ observationData.group_id_ +"'";
			dao.openConnection(sqlSentence);
			observationData.images = dao.dbResult;
			nextImageFromGroup();
		}
		
		
		private function nextImageFromGroup():void {
			if (observationData.images.length==0) {
				saveToFusionTables();
				Application.application.principalView.imagesState.deleteGroup(observationData.group_id);
			} else {
				var tag:String = "bioblitz2010:author=\""+FlickrAuthorizationSettings.accountName+"\",bioblitz2010:source=flickrtagger";
				if (observationData.taxon!=null && observationData.taxon!="Not recognized") {
					tag = tag + ",bioblitz2010:scientificName=\""+ observationData.taxon +"\"";
				}
				sendImageFlickr(tag, observationData.images[0].path);
				observationData.images.removeItemAt(0);
			}
		}


		private function sendImageFlickr(tag: String, dir:String):void {	
			var imageFile:File= new File();
			imageFile.url=dir;
			imageFile.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onResult);
			imageFile.addEventListener(IOErrorEvent.NETWORK_ERROR,onErrorStatus);
			imageFile.addEventListener(IOErrorEvent.IO_ERROR,onErrorStatus);
			var service:FlickrService = new FlickrService(FlickrAuthorizationSettings.flickrAPIKey);
			service.secret = FlickrAuthorizationSettings.flickrAPISecret;
			service.token = FlickrAuthorizationSettings.authToken;
			var uploader:Upload = new Upload(service);
			uploader.upload(imageFile,((observationData.taxon!=null && observationData.taxon!="Not recognized")?observationData.taxon:""),"Image uploaded at TDWGBioBlitz 2010",tag,true);
		}
		
		
		
		private function onResult(ev: DataEvent):void {
			var xml: XML = new XML(ev.data);
			var photoID: String = "";
		   	for each( var id:XML in xml..photoid ) {
				 photoID = id;
				 var flickr:FlickrService = new FlickrService(FlickrAuthorizationSettings.flickrAPIKey);
				 flickr.addEventListener(FlickrResultEvent.PHOTOS_GET_INFO,onGetPhotoInfo);
				 flickr.image_url = "file://" + escape(ev.currentTarget.nativePath.toString());
				 flickr.photos.getInfo(photoID,FlickrAuthorizationSettings.flickrAPISecret);
			}
			
		}
		
		
		private function onGetPhotoInfo(event:FlickrResultEvent):void {
			observationData.pathString = observationData.pathString + "http://farm"+ event.data.photo.farm +".static.flickr.com/"+ event.data.photo.server +"/"+ 
			event.data.photo.id +"_"+ event.data.photo.secret +"_b.jpg ";
			setImageLocation(event.data.photo.id,event.target.image_url as String);
			trace(observationData.pathString);
		}
		

		
		private function onErrorStatus(ev: IOErrorEvent):void {
			Alert.show("Error at uploading image to Flickr, please try again later or check your Internet connection","Error");
		}
		
		
		private function setImageLocation(photoID:String, path:String):void {


    		if (observationData.lat != null) {
	    		var flickr: FlickrService = new FlickrService(FlickrAuthorizationSettings.flickrAPIKey);
	    		flickr.secret = FlickrAuthorizationSettings.flickrAPISecret;
	    		flickr.token  = FlickrAuthorizationSettings.flickrAPIKey;
	    		flickr.permission = AuthPerm.WRITE;
	    		
	    		flickr.addEventListener(FlickrResultEvent.SET_LOCATION_RESULT,onFlickrSetLocationResult);
	    		flickr.photos.setLocation(photoID,observationData.lat,observationData.lon);		
    		}
			
			if (modeUpload==1) {
				Application.application.principalView.imagesState.deleteImagefromGroup(path,1);
				nextImageFromGroup();
			} else {
				saveToFusionTables();
    			Application.application.principalView.imagesState.deleteImage(path,1);
			}
			DockIcon(NativeApplication.nativeApplication.icon).bounce();
		}	
		
		private function onFlickrSetLocationResult(ev: FlickrResultEvent):void {
			trace(ev.success);
		}	
		

	}
}