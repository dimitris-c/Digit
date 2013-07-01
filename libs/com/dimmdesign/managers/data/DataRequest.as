package com.dimmdesign.managers.data
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class DataRequest
	{
		
		private var _callback:Function;
		
		private var _url:String;
		
		private var _urlRequest:URLRequest;
		
		private var _urlLoader:URLLoader;
		
		private var _rawResponse:*;
		
		private var _success:Boolean = false;
		
		public function DataRequest()
		{
		}
		
		public function get rawResponse():*	{ return _rawResponse; }
		
		public function get success():*	{ return _success; }
		
		/**
		 * Makes a url request with the specified parameters.
		 * 
		 * @param url String for the request
		 * @param method The method of the request. See <link> URLRequestMethod </link>
		 * @param callback A callback function to be used in case of completion or error
		 * @param params Any parameters for the request
		 * 
		 */		
		public function callRequest (url:String, method:String, callback:Function, params:Object = null):void {
			
			_url = url;
			_callback = callback;
			
			_urlRequest = new URLRequest( _url );
			_urlRequest.method = method;
			
			if (params == null) {
				_loadRequest();
				return;
			}
			
			var urlVariables:URLVariables = _paramsToURLVariables( params );
			_urlRequest.data = urlVariables;
			
			_loadRequest();
			
		}
		
		/**
		 * Closes the active request, if any. 
		 */		
		public function closeRequest ():void {
			
			if (_urlLoader != null) {
				
				_urlLoader.removeEventListener(Event.COMPLETE, _onURLLoaderComplete);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _onIoError);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);

				try {
					_urlLoader.close();
				} catch(error:*) { }
				
				_urlLoader = null;
			}
			
		}
			
		/**
		 * @private 
		 */		
		private function _loadRequest ():void {

			_urlLoader = new URLLoader();
			
			_urlLoader.addEventListener(Event.COMPLETE, _onURLLoaderComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, _onIoError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
		
			_urlLoader.load( _urlRequest );
			
		}

		private function _onSecurityError(event:SecurityErrorEvent):void
		{
			if (_callback != null) _callback (this);
			closeRequest();
		}

		private function _onIoError(event:IOErrorEvent):void
		{
			if (_callback != null) _callback (this);
			closeRequest();
		}

		private function _onURLLoaderComplete(event:Event):void
		{
			_rawResponse = event.target.data;
			if (_callback != null) _callback (this);
			closeRequest();
		}
		
		/**
		 * Converts an object to URLVariables. 
		 * @param params An object to be used for the conversion
		 * @return If success the result will be a URLVariables object.
		 * 
		 */		
		private function _paramsToURLVariables(params:Object):URLVariables {
			if (params) {
				var urlVariables:URLVariables = new URLVariables();
				for (var s:String in params) {
					urlVariables[s] = params[s];
				}
			}
			return urlVariables;
		}
	}
}