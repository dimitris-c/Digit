package com.dimmdesign.core
{
	import flash.display.DisplayObject;
	
	/**
	 * An interface to work around the lack of interface for display objects.
	 */
	public interface IDisplayObject
	{
		/** 
		 * Returns a representation of the object as a DisplayObject.
		 * Usually would return the object itself.
		 */ 
		function view():DisplayObject; 
		
		/**
		 * Implements the getters/setters of a DisplayObject 
		 */		
		
		/**
		 */		
		function get height():Number;
		
		function set height(value:Number):void;
		
		function get x():Number;
		
		function set x(value:Number):void;
		
		function get y():Number;
		
		function set y(value:Number):void;
		
		function get visible():Boolean;
		
		function set visible(value:Boolean):void;
		
		function get alpha():Number;
		
		function set alpha(value:Number):void;
		
		function get scaleX():Number;
		
		function set scaleX(value:Number):void;
		
		function get scaleY():Number;
		
		function set scaleY(value:Number):void;

		function get width():Number;
		
		function set width(value:Number):void;
		
		function get rotation():Number;
		
		function set rotation(value:Number):void;
		
	}
}