package com.dimmdesign.core
{
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	/**
	 * Lets you create a global variable that can be accessed from anywhere in your code. 
	 *  
	 */	
	public class Globals
	{
		
		private static var _global:Object;
		
		/**
		 * Initialize global dictionary
		 */	
		private static function init():void
		{
			_global = new Object();
			_global['Globals'] = new Dictionary(true);
		}
		
		/**
		 * Sets a global variable with the given name. The function also returns the newly created variable.
		 * @param $key - The name of the variable
		 * @param $obj - The object
		 * @return - The object;
		 * 
		 */		
		public static function setGlobal($key:String, $obj:*):* {
			if (_global == null) init();
			_global[$key] = $obj;
			return _global[$key];
		}
		
		/**
		 * Get a global variable with the given name.
		 * @param $key - The name of the variable.
		 * @return - An object.
		 * 
		 */		
		public static function getGlobal($key:String):* {
			if (_global == null) init();
			return _global[$key];
		}
		
		/**
		 * Revomes a variable from the global dictionany.
		 * @param $key - The name of the variable.
		 * 
		 */		
		public static function removeGlobal($key:String):void {
			if (_global == null) init();
			delete _global[$key];
			
		}
		
		/**
		 * Removes all the objects from the global dictionary. 
		 */		
		public static function destroyGlobal():void {
			
			if (_global != null) {	
				for (var i:* in _global) {
					delete _global[i];
				}
				_global = null;
			}
			
		}
	}
}