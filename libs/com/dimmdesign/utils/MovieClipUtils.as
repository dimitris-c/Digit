package com.dimmdesign.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class MovieClipUtils
	{
		
		/**
		 * Finds all nested movieclips and stops them 
		 * @param movieclip The movieclip to be searchs
		 * 
		 */		
		public static function stopAll(movieclip:DisplayObjectContainer, frame:Object = null):void {
			
			var length:int = movieclip.numChildren;
			var i:int = 0;
			var child:DisplayObject;
			
			for (i = 0; i < length; ++i)
			{
				try {
					child = movieclip.getChildAt(i);
				} catch (e:Error) { }
				
				if (child && child is DisplayObjectContainer) {
					if (child is MovieClip) {
						if (frame == null) 
							MovieClip(child).stop(); 
						else 
							MovieClip(child).gotoAndStop(frame);
					}
					MovieClipUtils.stopAll(DisplayObjectContainer(child));
				}
			}
		}
		
		/**
		 * Finds all nested movieclips and plays them 
		 * @param movieclip The movieclip to be searchs
		 * 
		 */		
		public static function playAll(movieclip:DisplayObjectContainer, frame:Object = null):void {
			
			var length:int = movieclip.numChildren;
			var i:int = 0;
			var child:DisplayObject;
			
			for (i = 0; i < length; ++i)
			{
				try {
					child = movieclip.getChildAt(i);
				} catch (e:Error) { }
				
				if (child && child is DisplayObjectContainer) {
					if (child is MovieClip) {
						if (frame == null) 
							MovieClip(child).play(); 
						else 
							MovieClip(child).gotoAndPlay(frame)
					}
					MovieClipUtils.playAll(DisplayObjectContainer(child));
				}
			}
		}
		
	}
}