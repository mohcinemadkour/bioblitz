package com.vizzuality.dao
{
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.events.*;
	import com.adobe.webapis.flickr.methodgroups.Upload;
	import com.vizzuality.views.authentication.FlickrAuthorizationSettings;
	
	import flash.desktop.*;
	import flash.events.DataEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	
	public class FlickrUploadService
	{
		
		private var imageData : ArrayCollection;
		private var taxon : String;
		private var arrayImages: ArrayCollection = new ArrayCollection();
		private var arrayImagesData: ArrayCollection = new ArrayCollection();
		private var group_id: String;
		private var modeUpload: int = 0;
		
		
		public function FlickrUploadService() {}
		
		
		public function resolveTagsFlickr(path:String,name:String):void {
			modeUpload = 0;
			taxon = name;
			var tag:String = "bioblitz2010:author=\""+FlickrAuthorizationSettings.accountName+"\",bioblitz2010:source=flickrtagger";
			tag = tag + ",bioblitz2010:scientificName=\""+taxon+"\"";
			sendImageFlickr(tag, path);
		}
		
		
		public function resolveGroupTagsFlickr(group_id_:String,name:String):void {
			modeUpload = 1;
			group_id = group_id_;
			taxon = name;
			var dao: DataAccessObject = new DataAccessObject();
			var sqlSentence: String = "SELECT path FROM photos WHERE group_id = '"+group_id_+"'";
			dao.openConnection(sqlSentence);
			arrayImages = dao.dbResult;
			nextImageFromGroup();
		}
		
		
		private function nextImageFromGroup():void {
			if (arrayImages.length==0) {
				Application.application.principalView.imagesState.deleteGroup(group_id);
			} else {
				var tag:String = "bioblitz2010:author=\""+FlickrAuthorizationSettings.accountName+"\",bioblitz2010:source=flickrtagger";
				tag = tag + ",bioblitz2010:scientificName=\""+taxon+"\"";
				sendImageFlickr(tag, arrayImages[0].path);
				arrayImages.removeItemAt(0);
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
			uploader.upload(imageFile,taxon,"Image uploaded at TDWGBioBlitz 2010",tag,true);
		}
		
		
		private function saveToFusionTable():void {
			
		}
		
		
		private function onResult(ev: DataEvent):void {
			var xml: XML = new XML(ev.data);
			var photoID: String = "";
		   	for each( var id:XML in xml..photoid ) {
				 photoID = id;
				 var flickr:FlickrService = new FlickrService(FlickrAuthorizationSettings.flickrAPIKey);
				 flickr.addEventListener(FlickrResultEvent.PHOTOS_GET_INFO,onGetPhotoInfo);
				 if (group_id!=null) {
				 	flickr.group = true;
				 } else {
				 	flickr.group = false;
				 }
				 flickr.photos.getInfo(photoID,FlickrAuthorizationSettings.flickrAPISecret);
			}
			
			setImageLocation(photoID,"file://" + escape(ev.currentTarget.nativePath.toString()));
		}
		
		
		private function onGetPhotoInfo(event:FlickrResultEvent):void {
			
		}
		
		
		private function onErrorStatus(ev: IOErrorEvent):void {
			Alert.show("Error at uploading image to Flickr, please try again later or check your Internet connection","Error");
		}
		
		
		private function setImageLocation(photoID:String,path:String):void {
			
			var dao: DataAccessObject = new DataAccessObject();
			var sqlSentence: String = "SELECT lat,lon FROM photos WHERE path = '"+path+"'";
			dao.openConnection(sqlSentence);
			imageData = dao.dbResult;

    		if (imageData[0].lat != null) {
	    		var flickr: FlickrService = new FlickrService(FlickrAuthorizationSettings.flickrAPIKey);
	    		flickr.secret = FlickrAuthorizationSettings.flickrAPISecret;
	    		flickr.token  = FlickrAuthorizationSettings.flickrAPIKey;
	    		flickr.permission = AuthPerm.WRITE;
	    		
	    		flickr.addEventListener(FlickrResultEvent.SET_LOCATION_RESULT,onFlickrSetLocationResult);
	    		flickr.photos.setLocation(photoID,imageData[0].lat,imageData[0].lon,imageData[0].zoom);		
    		}
			
			if (modeUpload==1) {
				Application.application.principalView.imagesState.deleteImagefromGroup(path,1);
				nextImageFromGroup();
			} else {
    			Application.application.principalView.imagesState.deleteImage(path,1);
			}
			DockIcon(NativeApplication.nativeApplication.icon).bounce();
		}	
		
		private function onFlickrSetLocationResult(ev: FlickrResultEvent):void {
			
		}	
	}
}