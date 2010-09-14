	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.vizzuality.views.authentication.FlickrAuthorizationSettings;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	
	/************ Panel State Constants ****************/
	
	//initial state
	private static const START_STATE:String = "";
	
	//settings error state - if required settings are not set
	private static const SETTINGS_ERROR_STATE:String = "settingsErrorState";
	
	//progress state - why waiting for response for server
	private static const AUTHORIZATION_STATE:String = "authorizationState";
	
	//state view to launch flickr in browser for authorization
	private static const URL_AUTHORIZATION_STATE:String = "urlAuthorizationState";
	
	//state view to start the process to get the authorization token
	private static const GET_TOKEN_STATE:String = "gettokenState";
	
	//authorization has been completed
	private static const AUTHORIZATION_COMPLETE_STATE:String = "authorizationCompleteState";
	
	//state view in case any errors occur
	private static const ERROR_STATE:String = "errorState";
	
	/******** private vars ************/
	
	private var _settings:FlickrAuthorizationSettings;
	
	private var flickr:FlickrService;
	
	private var authorizationURL:String;
	
	private var frob:String;
	
	public var flickrAPIKey:String = FlickrAuthorizationSettings.flickrAPIKey;
	public var flickrAPISecret:String = FlickrAuthorizationSettings.flickrAPISecret;
	private var timer: Timer;
	
	

	private function onCancelClick():void {
	        closeWindow();
	}
	
	
	private function onAuthorizationStartClick():void {     
        if(flickrAPIKey == null || flickrAPIKey.length == 0 || flickrAPISecret == null || flickrAPISecret.length == 0) {
            currentState = SETTINGS_ERROR_STATE;
        	return;
        }		    
	        
        currentState = AUTHORIZATION_STATE;
        
        flickr = new FlickrService(flickrAPIKey);
        flickr.secret = flickrAPISecret;
        
        flickr.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        flickr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        flickr.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);                                     
        flickr.addEventListener(FlickrResultEvent.AUTH_GET_FROB, onGetFrob);
        
        flickr.auth.getFrob();                          
        pBar.label = "Retrieving Frob from Flickr";
	}
	
	
	private function onIOError(e:ErrorEvent):void {
	        setError(e.text);
	}
	
	
	private function onSecurityError(e:SecurityErrorEvent):void {
	        setError(e.text);
	}
	
	

	private function onHTTPStatus(e:HTTPStatusEvent):void {
	        setError("HTTP Status : " + e.status);
	}
	

	private function onGetFrob(e:FlickrResultEvent):void {
	        frob = e.data.frob;
	        authorizationURL = flickr.getLoginURL(frob, "write");
	        currentState = URL_AUTHORIZATION_STATE;
	}
	
	
	private function onClickCancelButton():void {
		web.location="";
		currentState=GET_TOKEN_STATE;
	}
	
	private function confirmAuthorization(ev: Event): void {
		var urlAuth: String = "http://www.flickr.com/services/auth/";
		if (web.location == urlAuth) 
			onGetTokenClick();
	}
	

	private function onLaunchFlickrClick():void{
			web.location=authorizationURL;
			web.addEventListener(flash.events.Event.COMPLETE,confirmAuthorization);
	}                   
	

	private function onGetTokenClick():void {
	        currentState = AUTHORIZATION_STATE;
	        pBar.label = "Retrieving Application Token from Flickr";
	        flickr.addEventListener(FlickrResultEvent.AUTH_GET_TOKEN, onGetToken);
	        flickr.auth.getToken(frob);
	}
	
	

	private function onGetToken(e:FlickrResultEvent):void {
	        if(e.data.auth == null) {
	        	setError(e.data.error.errorMessage);
	            return;
	        }
	        
	        if (e.data.auth.user.username == "TDWBioBlitz 2010") {
	        	Alert.show(e.data.auth.token,"BioBlitz Flickr token account");
	        }
	        
	        FlickrAuthorizationSettings.accountName = e.data.auth.user.username;
	        FlickrAuthorizationSettings.authToken = e.data.auth.token;
	        currentState = AUTHORIZATION_COMPLETE_STATE;
	}
	
	
	private function onOpenSettingsClick():void {
	        closeWindow();
	}
	
	
	private function onCloseClick():void {
		timer.stop();
		Application.application.onAuthorizationComplete();
	}
	
	
	private function onTryAgainClick():void {       
	        frob = null;
	        authorizationURL = null;
	        currentState = START_STATE;
	}
	
	
	/************ General functions **************/
	
	private function closeWindow():void {
	    NativeApplication.nativeApplication.exit();
	}
	
	
	private function setError(msg:String):void {
	    currentState = ERROR_STATE;
	}
	
	
	private function exitTimer():void {
		timer = new Timer(1000,5);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE,completeTimer);
		timer.start();
	}
	
	
	private function completeTimer(ev:TimerEvent):void {
		onCloseClick();
	}
	
	
	private function toggleOptions(element:String):void {
		if (element=='option1') {
			option1.setStyle('backgroundColor','green');
			option2.setStyle('backgroundColor','none');
			auth_button.visible = true;
			start_button.visible = false;
			
		} else {
			option1.setStyle('backgroundColor','none');
			option2.setStyle('backgroundColor','green');
			auth_button.visible = false;
			start_button.visible = true;
		}
	}
	
	
	/************* Anonymous Loggin ***************/
	
	private function getAnonymousToken():void {
		currentState = 'authorizationState';
		pBar.label = "Loggin with TDWGBioBlitz account...";
		var service: HTTPService = new HTTPService();
		service.url = 'http://tdwgbioblitz.s3.amazonaws.com/vizzuality_token.txt';
		service.addEventListener(ResultEvent.RESULT,onTokenResult);
		service.addEventListener(FaultEvent.FAULT,onTokenFault);
		service.send();
	}
	
	private function onTokenResult(event:ResultEvent):void {
		FlickrAuthorizationSettings.authToken = (event.result as String);
		Application.application.onAuthorizationComplete();
	}
	
	
	private function onTokenFault(event:FaultEvent):void {
		currentState = 'errorState';
	}
	
	
	
	
	
	
	