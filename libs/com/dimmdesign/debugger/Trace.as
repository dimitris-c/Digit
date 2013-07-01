package com.dimmdesign.debugger
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.text.TextField;

	/**
	 *  
	 * @author Dimitris Chatzieleftheriou
	 * 
	 */	
	public final class Trace
	{
		private static var _console:TextField;
		private static var _traceEnabled:Boolean;
		private static var _showTraceOnly:Boolean;
		private static var _showInBrowserConsole:Boolean;
		
		public static function get console():TextField { return _console; }
		public static function set console(value:TextField):void { _console = value; }
		
		public static function get traceEnabled():Boolean { return _traceEnabled; }
		public static function set traceEnabled(value:Boolean):void { _traceEnabled = value; }
		
		public static function get showTraceOnly():Boolean { return _showTraceOnly; }
		public static function set showTraceOnly(value:Boolean):void { _showTraceOnly = value; }
		
		public static function get showInBrowserConsole():Boolean { return _showInBrowserConsole; }
		public static function set showInBrowserConsole(value:Boolean):void { _showInBrowserConsole = value; }

		/**
		 * Alternative logging class.  
		 */		
		public function Trace():void {
			
		}
		
		public static function log(values:Array):void {
			
			if (!_console) { 
				trace('You have not assigned a textfield console to log');
			}
			
			var len:uint = values.length;
			var i:int = 0;
			for (i; i < len; ++i)
				_log(values[i]);
		}
		
		private static function _log(value:*):void {
			
			if (showTraceOnly) {
				trace(value);
				return;
			}
			
			if (traceEnabled) trace(value);
			
			if (value == null) value = 'null';
			if (value == undefined) value = 'undefined';
			if ((value is Error) || (value is ErrorEvent)) {
				
				_console.htmlText = _console.htmlText +  "<span class='error'> — Error — </span><p></p>" + "\n"; 
				
				_console.htmlText = _console.htmlText +  "<span class='error'>" + value  + "</span><p></p>" + "\n";
				
				_console.htmlText = _console.htmlText +  "<span class='error'> — Error — </span><p></p>" + "\n";
				_console.dispatchEvent(new Event(Event.CHANGE, true, true));
				return;
			}
			if (value is Array && !(value is String) && !(value is Number)) {
				if (value.length > 0) {
					
					_console.htmlText = _console.htmlText +  "<span class='coloured'> Array output start ("+value.length+") </span><p></p>" + "\n"; 
					
					_logArray( value );
					
					_console.htmlText = _console.htmlText +  "<span class='coloured'> Array output end </span><p></p>" + "\n";
					_console.dispatchEvent(new Event(Event.CHANGE, true, true));
					return;
				}
				else{
					_console.htmlText = _console.htmlText +  "<span class='coloured'> Array has no elements </span><p></p>" + "\n";
					_console.dispatchEvent(new Event(Event.CHANGE, true, true));
					return;
				}
			}
			if (value is Object && !(value is String) && !(value is Number)) {
				_console.htmlText = _console.htmlText +  "<span class='coloured'> Object output start </span><p></p>" + "\n"; 
				
				_logObject( value );
				
				_console.htmlText = _console.htmlText +  "<span class='coloured'> Object output end </span><p></p>" + "\n";
				_console.dispatchEvent(new Event(Event.CHANGE, true, true));
				return;
			}
			value = value.toString();
			
			if (_showInBrowserConsole) {
				if (ExternalInterface.available) {
					ExternalInterface.call("function (values) { if (typeof(console) != 'undefined' && console != null) { console.log ('fl: ' + values); } }", value);
				}
			}
			
			_console.htmlText = _console.htmlText +  '<p>' + value +  '</p>' + '\n';
			_console.dispatchEvent(new Event(Event.CHANGE, true, true));
		}
		
		private static function _logObject(value:Object):void {
			for (var key:String in value) 
			{
				trace('Object output -', 'key:', key,  '>', value[key]);
				_console.htmlText = _console.htmlText +  '<p>Key > ' + key + ' : ' + value[key] +  '</p>' + '\n'; 
			}
		}
		
		private static function _logArray(value:Array):void {
			var arrayIndex:int = 0;
			var len:uint = value.length;
			var j:int = 0
			for (j; j < len; ++j) 
			{
				trace('Array output', arrayIndex, '>', value[j]);
//				if (isObject(value[j])) value[j] = value[j];
				_console.htmlText = _console.htmlText +  '<p>' + arrayIndex + ' > ' + value[j] +  '</p>' + '\n'; 
				arrayIndex++;
			}
		}
		
		private static function isObject(obj:*):Boolean {
			return ((obj is Object && !(obj is String) && !(obj is Number)))
		}
		
		private static function isArray(obj:*):Boolean {
			return (obj is Array);
		}
		
	}
}