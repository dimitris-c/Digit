package com.dimmdesign.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class BitmapUtils
	{
				
		
		public static function posterize (source:Bitmap, levels:uint = 5):void {
			if (levels < 2) return;
			var bitmapData:BitmapData = source.bitmapData;
			
			var red:BitmapData = makeImageFromChannel(bitmapData, BitmapDataChannel.RED);
			var green:BitmapData = makeImageFromChannel(bitmapData, BitmapDataChannel.GREEN);
			var blue:BitmapData = makeImageFromChannel(bitmapData, BitmapDataChannel.BLUE);
			
			var sourceChannels:Array = [red, green, blue];
			
			red = new BitmapData(bitmapData.width, bitmapData.height);
			green = red.clone();
			blue = red.clone();
			
			var adjustedChannels:Array = [red, green, blue];
			
			var channelData:BitmapData;
			var threshold:uint;
			var colorTransform:ColorTransform;
			var brightness:uint;
			var j:uint;
			
			levels--;
			for (var i:uint = 0; i < levels; i++) 
			{
				threshold = 255 * ((levels-i)/(levels+1));
				brightness = 255 * ((levels-1-i)/levels);
				colorTransform = new ColorTransform(1, 1, 1, 1, brightness, brightness, brightness, brightness);	
				
				for (j = 0; j < 3; j++) 
				{
					channelData = sourceChannels[j].clone();

					setLevels(channelData, threshold, threshold, threshold);
					
					adjustedChannels[j].draw(channelData, null, colorTransform, BlendMode.MULTIPLY);
				}
				
			}
			
			copyChannel(red, bitmapData, BitmapDataChannel.RED);
			copyChannel(green, bitmapData, BitmapDataChannel.GREEN);
			copyChannel(blue, bitmapData, BitmapDataChannel.BLUE);

		}
		
		/**
		 * Desaturates a bitmap. 
		 * @param source - A bitmap object
		 * 
		 */
		public static function desaturate (source:Bitmap):void {
			const matrix:Array = [	0.3, 0.59, 0.11, 0, 0,
									0.3, 0.59, 0.11, 0, 0,
									0.3, 0.59, 0.11, 0, 0,
									0,   0,    0,    1, 0
								 ];
			const colorMatrix:ColorMatrixFilter = new ColorMatrixFilter([]);
			source.bitmapData.applyFilter(source.bitmapData, source.bitmapData.rect, new Point(), new ColorMatrixFilter(matrix)); 
		}
		
		public static function desaturateMatrixArray():Array {
			return  [	0.3, 0.59, 0.11, 0, 0,
						0.3, 0.59, 0.11, 0, 0,
						0.3, 0.59, 0.11, 0, 0,
						0,   0,    0,    1, 0
					];
		}
		
		
		public static function makeImageFromChannel (bitmapData:BitmapData, channel:uint):BitmapData {
			var clone:BitmapData = bitmapData.clone();
			var rect:Rectangle = clone.rect;
			var point:Point = new Point();
			clone.copyChannel(bitmapData, rect, point, channel, BitmapDataChannel.RED);
			clone.copyChannel(bitmapData, rect, point, channel, BitmapDataChannel.GREEN);
			clone.copyChannel(bitmapData, rect, point, channel, BitmapDataChannel.BLUE);
			return clone;
		}
		
		public static function setLevels (source:BitmapData, blackPoint:uint, midPoint:uint, whitePoint:uint):void {
			var red:Array = [];
			var green:Array = [];
			var blue:Array = [];
			var i:int = 0;
			for (i = 0; i <= blackPoint; i++) {
				red.push(0);
				green.push(0);
				blue.push(0);
			}
			
			var value:uint = 0;
			var range:uint = midPoint - blackPoint;
			for (i = blackPoint+1; i <= midPoint; i++) {
				value = ((i - blackPoint)/range) * 127;
				red.push(value << 16);
				green.push(value << 8);
				blue.push(value);
			}
			
			range = whitePoint - midPoint;
			for (i = midPoint+1; i <= whitePoint; i++) {
				value = ((i - whitePoint)/range) * 128 + 127;
				red.push(value << 16);
				green.push(value << 8);
				blue.push(value);
			}
			
			for (i = whitePoint+1; i < 256; i++) 
			{
				red.push(0xFF << 16);
				green.push(0xFF << 8);
				blue.push(0xFF);
			}
			
			source.paletteMap(source, source.rect, new Point(), red, green, blue);
		}
		
		public static function copyChannel (source:BitmapData, destination:BitmapData, channel:uint):void {
			destination.copyChannel(source, source.rect, new Point(), channel, channel);	
		}
		
		public static function getCloneBitmap(source:Bitmap):Bitmap {
			return new Bitmap(source.bitmapData.clone(), 'auto', true);
		}
		
		public static function resizeBitmapData(bmpSource:BitmapData, setWidth:Number, setHeight:Number):BitmapData {
			var scaleWidth:Number = setWidth / bmpSource.width;
			var scaleHeight:Number = setHeight / bmpSource.height;
			var bmp:BitmapData = new BitmapData (setWidth, setHeight, true, 0);
			var matrix:Matrix = new Matrix ();
			matrix.scale(scaleWidth, scaleHeight);
			bmp.draw(bmpSource, matrix);
			return bmp;
		}
		
	}
	
}
