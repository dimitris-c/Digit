package com.dimmdesign.managers.data
{
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	public class DataLoaderManager
	{
		private static var _allowInstantiation:Boolean;
		private static var _instance:DataLoaderManager;
		
		private var _callbacksDictionary:Dictionary = new Dictionary();
		
		public function DataLoaderManager()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use DataLoaderManager.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():DataLoaderManager {
			if (_instance == null) {
				_allowInstantiation = true;
				_instance = new DataLoaderManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/**
		 * Loads data from the passed url. 
		 * @param url A string defining the url to be loaded
		 * @param onCompleteCallback A function that will be called when the request is completed.
		 */		
		public static function loadData(url:String, onCompleteCallback:Function):void {
			
			getInstance()._loadData(url, onCompleteCallback);
			
		}
		
		
		/**
		 * @private 
		 */		
		protected function _loadData(url:String, onCompleteCallback:Function):void {
				
			var req:DataRequest = new DataRequest();
			
			if (onCompleteCallback !== null) _callbacksDictionary[req] = onCompleteCallback;
						
			req.callRequest(url, URLRequestMethod.GET, _onRequestComplete, null);
					
		}
				
		/**
		 * @private 
		 */	
		private function _onRequestComplete(target:DataRequest):void
		{
			var success:* = target.rawResponse;
			
			var callback:Function = _callbacksDictionary[target];
			if (callback === null) {
				delete _callbacksDictionary[target];
			}
			
			if (callback !== null) callback(success);
			delete _callbacksDictionary[target];
			
						
		}
			
	}
}