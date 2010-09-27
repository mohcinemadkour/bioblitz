package com.vizzuality.event
{
	import flash.events.Event;
	import flash.geom.Point;

	public class GetTaxonEvent extends Event
	{
		
		public static const RESULT: String = "resultEvent";
		public var taxon: String;
		public var coords: Point;
		
		public function GetTaxonEvent(type:String, _taxon:String, _coords:Point, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.taxon = _taxon;
			this.coords = _coords;
			super(type, bubbles, cancelable);
		}
		
	}
}