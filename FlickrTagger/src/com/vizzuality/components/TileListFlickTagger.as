package com.vizzuality.components
{
	import flash.display.Sprite;
	
	import mx.controls.TileList;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.mx_internal; //this import statement should appear be last
	

	public class TileListFlickTagger extends TileList
	{
		use namespace mx_internal; //tells Actionscript that mx_internal is a namespace 
		
		public function TileListFlickTagger()
		{
			super();
		}
		
		override protected function drawSelectionIndicator(
				indicator:Sprite, x:Number, y:Number,
				width:Number, height:Number, color:uint,
				itemRenderer:IListItemRenderer):void
		{
		/* You can leave this method empty or manage your own design */
		}
 
 
		// Remove the Selection indicator
		override protected function drawHighlightIndicator(
			indicator:Sprite, x:Number, y:Number,
			width:Number, height:Number, color:uint,
			itemRenderer:IListItemRenderer):void
		{
		/* You can leave this method empty or manage your own design */
		}
		
		//The array of renderers being used in this list
		public function get renderers():Array
		{
		//prefix the internal property name with its namespace
		return mx_internal::rendererArray;
		}
		
	}
}