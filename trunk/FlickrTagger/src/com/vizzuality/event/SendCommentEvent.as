package com.vizzuality.event
{
	import flash.events.Event;

	public class SendCommentEvent extends Event
	{
		public static const COMMENT: String = "commentEvent";
		public var comment: String;
		
		public function SendCommentEvent(type:String, _comment:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			comment = _comment;
			super(type, bubbles, cancelable);
		}
		
	}
}