package com.fnicollet {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

 	public class BitmapDataCacher {

    	private static var bitmapDatasCache:Array = [];
    	private static var extractionsCache:Array = [];
    	private static const POINT:Point = new Point;
    	private static var _extractionsCacheSize:int = 0;
		private static var _stAttribute:SubTextureAttributes;
	
    	public static var CACHE_MAX_SIZE:int = 50;
		
    	public function BitmapDataCacher() {
    	}
		
		public static function cacheBitmap(cacheId:String, bitmap:Bitmap, atlasXml:XML = null):void {
			cacheBitmapData(cacheId, bitmap.bitmapData, atlasXml);
		}
		
		public static function cacheBitmapData(cacheId:String, bitmapData:BitmapData, atlasXml:XML = null):void {
			// store the BitmapData, only extract it once it is requested
			bitmapDatasCache[cacheId] = [bitmapData, atlasXml];
		}

	    /**
	    *  if in the atlas, the name is FISH_SWIM_004, pass FISH_SWIM, 4 to this method as texturePrefix and textureIndex
	    */
	    public static function getBitmapData(cacheId:String, texturePrefix:String, textureIndex:int = 0):BitmapData {
			if (!_stAttribute) _stAttribute = new SubTextureAttributes();
			var i:int = 0;
		    var infos:Array = bitmapDatasCache[cacheId];
			if (!infos || infos.length < 1) {
				return null;
			}
			var bitmapData:BitmapData = BitmapData(infos[0]);
			var atlasXml:XML = infos[1];
			if (!atlasXml) {
				// we have just been storing bitmapDatas
				return bitmapData;
			}
			
			for each (var subTexture:XML in atlasXml.SubTexture){
				var name:String = subTexture.attribute("name");
				if (name.indexOf(texturePrefix) != 0) continue;
				  
				if (i == textureIndex) {
					var extractionCacheId:String = cacheId + "__" + name;
					var fromCache:BitmapData = extractionsCache[extractionCacheId];
					// return the data from cache
					if (fromCache) return fromCache;
					
					// we found the right texture, let's extract it
					_stAttribute.x = parseFloat(subTexture.attribute("x"));
					_stAttribute.y = parseFloat(subTexture.attribute("y"));
					_stAttribute.width = parseFloat(subTexture.attribute("width"));
					_stAttribute.height = parseFloat(subTexture.attribute("height"));
					_stAttribute.frameX = parseFloat(subTexture.attribute("frameX"));
					_stAttribute.frameY = parseFloat(subTexture.attribute("frameY"));
					_stAttribute.frameWidth = parseFloat(subTexture.attribute("frameWidth"));
					_stAttribute.frameHeight = parseFloat(subTexture.attribute("frameHeight"));
					
					// clean
					if (_extractionsCacheSize > CACHE_MAX_SIZE) {
						extractionsCache.length = 0;
					}
					// extract the right part of the Bitmap
					var extraction:BitmapData = new BitmapData(_stAttribute.width, _stAttribute.height, true, 0);
					extraction.copyPixels(bitmapData, _stAttribute.region(), POINT);
					var framedExtraction:BitmapData = new BitmapData(_stAttribute.frameWidth, _stAttribute.frameHeight, true, 0);
					framedExtraction.draw(extraction, new Matrix(1, 0, 0, 1, -_stAttribute.frameX, -_stAttribute.frameY));
					
					extractionsCache[extractionCacheId] = framedExtraction;
					_extractionsCacheSize++;
					return framedExtraction;
				}
				i++;
			}
			return null;
		}
	}
}

import flash.geom.Rectangle;

internal class SubTextureAttributes {
	
	public var x:Number;
	public var y:Number;
	public var width:Number;
	public var height:Number;
	public var frameX:Number;
	public var frameY:Number;
	public var frameWidth:Number;
	public var frameHeight:Number;
	
	public function SubTextureAttributes () {
		
	}
	
	public function region():Rectangle { 
		return new Rectangle(x, y, width, height);
	}
	
	public function frame():Rectangle {
		return new Rectangle(frameX, frameY, frameWidth, frameHeight);
	}
}
