package com.vizzuality.event
{
	import flash.events.Event;

	public class SelectedSpecieEvent extends Event
	{
		
		public static const SELECTED_TAXON: String = "selectedTaxon";
		public var taxon:String;
		
		public function SelectedSpecieEvent(type:String, _taxon:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			taxon = _taxon;
			super(type, bubbles, cancelable);
		}
		
	}
}