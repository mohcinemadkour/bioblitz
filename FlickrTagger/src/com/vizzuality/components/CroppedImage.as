package com.vizzuality.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import mx.controls.Image;
	import mx.core.Application;

	public class CroppedImage extends Image
	{
		
		private var path:String;
		private var loader:Loader;
		
		public function CroppedImage()
		{
			super();
		}
		
		public function set pathImage(_path:String):void {
			if (_path!=this.path) {
				this.path=_path;
				if (path!="") {				
					if(Application.application.croppedImagesDictionary[_path]!=null) {
						var dic:Dictionary =Application.application.croppedImagesDictionary;
						source = new Bitmap(Application.application.croppedImagesDictionary[_path] as BitmapData);
					} else {
						loader = new Loader();
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadedFinished);
						loader.load(new URLRequest(this.path));											
					}
				} else {
					source = null;
				}
			}
			
		}
		
		private function onLoadedFinished(event:Event):void {
			loader.removeEventListener(Event.COMPLETE,onLoadedFinished);
			var bitmap:Bitmap = Bitmap(event.target.content);
			var bitmapData:BitmapData = bitmap.bitmapData;
			
		 				
		 	var originalWidth:Number = bitmapData.width;
		 	var originalHeight:Number = bitmapData.height;
		 	var newWidth:Number = 500;
		 	var newHeight:Number = 350;
		 			
		 	var m:Matrix = new Matrix();
		 
	  		var sx:Number =  newWidth / originalWidth;
	  		var sy:Number = newHeight / originalHeight;
	  		var scale:Number = Math.min(sx, sy);
	  		newWidth = originalWidth * scale;
	  		newHeight = originalHeight * scale;	


		 	m.scale(scale, scale);
		 	var bmd2:BitmapData = new BitmapData( newWidth,newHeight); 
		 				
		 	bmd2.draw(bitmapData, m);

			
			var startPoint:Point = new Point(((newWidth/2)-85), ((newHeight/2)-63));
			
			
			var newBitmapData:BitmapData = new BitmapData(170,126);
			newBitmapData.copyPixels(bmd2, 
				new Rectangle(startPoint.x,startPoint.y,170,126), 
                new Point(0,0));
                    
          	source = new Bitmap(newBitmapData);  
			Application.application.croppedImagesDictionary[this.path] = newBitmapData;          		
		}
		
	}
}