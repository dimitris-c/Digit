package com.dimmdesign.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class BaseAssets
	{
		
		private static var assetsDictionary:Dictionary;
		
		private static var Assets:Class;
		
		{
			// Static costructor 
			assetsDictionary = new Dictionary();
		}
		
		/**
		 * METHODS 
		 */		
		
		/**
		 * Sets the Assets Class to be used 
		 * @param className A Class where all the assets are included
		 * 
		 */		
		public static function setAssetsClass(className:Class):void {
			Assets = className;
		}
		
		/**
		 * Recycles the bitmaps using a dictionary so that they don't get created each time.
		 * Creates a bitmap object based on the passed name and return the created Bitmap.
		 * @param name A string for the name of the bitmap to be created.
		 * @return A bitmap.
		 * 
		 */		
		public static function getBitmap(name:String):Bitmap {
			
			if (assetsDictionary[name] == undefined)
			{
				var obj:Object = new Assets[name]();
				var bmp:Bitmap = obj as Bitmap;
				bmp.smoothing = true;
				assetsDictionary[name] = bmp;
			}
			
			return assetsDictionary[name]; 
		}
		
		/**
		 * Creates unique bitmap from the passed name. 
		 * @param name A string to be used as the name of the bitmap to be created
		 * @return An object that is type of Bitmap
		 * 
		 */		
		public static function getUniqueBitmap(name:String):Bitmap {
			var obj:Object = new Assets[name]();
			var bmp:Bitmap = obj as Bitmap;
			bmp.smoothing = true;
			return bmp;
		}
		
		public static function getUniqueBitmapData(name:String):BitmapData {
			return BaseAssets.getUniqueBitmap(name).bitmapData;
		}
		
		public static function removeFromDictionary(bmp:Bitmap):void {
			for (var obj:String in assetsDictionary) {
				var value:Bitmap = assetsDictionary[obj];
				if (value == bmp) { 
					assetsDictionary[obj] = null;
					delete assetsDictionary[obj];
					return;
				}
			}
		}

	}
}