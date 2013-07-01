package com.dimmdesign.managers.data
{
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class PostDataManager
	{
		private static var _allowInstantiation:Boolean;
		private static var _instance:PostDataManager;
		
		private var _urlLoader:URLLoader;
		
		private var _callbacksDictionary:Dictionary = new Dictionary();
		private var _onPostDataCallback:Function;
		
		public function PostDataManager(target:IEventDispatcher=null)
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use PostDataManager.getInstance() instead of new.");
			}
		}
		
		public static function getInstance():PostDataManager {
			if (_instance == null) {
				_allowInstantiation = true;
				_instance = new PostDataManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public static function postData (url:String, params:Object, callback:Function):void {
			getInstance()._postData(url, params, callback);
		}
		
		/**
		 * @ private 
		 */
		private function _postData (url:String, params:Object, callback:Function):void {

			var req:DataRequest = new DataRequest();

			if (callback != null) {
				if (!_callbacksDictionary) _callbacksDictionary = new Dictionary();
				_callbacksDictionary[req] = callback;
			}

			req.callRequest(url, 'POST', _onPostDataComplete, params);
						
		}
		
		private function _onPostDataComplete(target:DataRequest):void
		{
			var callback:Function = _callbacksDictionary[target];
			if (callback === null) {
				delete _callbacksDictionary[target];
			}
			
			var data:* = target.rawResponse;
			if (callback != null) callback(data);
			
			delete _callbacksDictionary[target];
		}
		
		
	}
	
}