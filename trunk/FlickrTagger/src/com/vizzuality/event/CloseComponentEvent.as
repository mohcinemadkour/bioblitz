package com.vizzuality.event
{
	import flash.events.Event;

	public class CloseComponentEvent extends Event
	{
		public static const CLOSE_COMPONENT: String = "closeComponentEvent";
		public var textNumber: int;
		
		public function CloseComponentEvent(type:String, textNumber:int,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.textNumber=textNumber;
		}
		
	}
}