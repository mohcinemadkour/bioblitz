package com.vizzuality.event
{
	import flash.events.Event;
	
	
	public class GetTokenEvent extends Event
	{
        public static const KO_TOKEN : String = "onGetTokenKO";
        public static const OK_TOKEN:  String = "onGetTokenOK";

        public function GetTokenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
                super(type, bubbles, cancelable);
        }       
	}
}