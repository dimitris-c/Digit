package com.dimmdesign.managers.display
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class ImageLoaderManager
	{
		private static var _allowInstantiation:Boolean;
		private static var _instance:ImageLoaderManager;
		
		private var _callbacksDictionary:Dictionary = new Dictionary();
		
		public function ImageLoaderManager()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use ImageLoaderManager.getInstance() instead of new.");
			}
		}
		
		
		public static function getInstance():ImageLoaderManager {
			if (_instance == null) {
				_allowInstantiation = true;
				_instance = new ImageLoaderManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public static function loadImage (url:String, completeCallback:Function , progressCallback:Function = null):void {
			getInstance()._loadImage(url, completeCallback, progressCallback);		
		}
		
		private function _loadImage (url:String, completeCallback:Function , progressCallback:Function = null):void {
			
			var req:LoaderRequest = new LoaderRequest();
			
			_callbacksDictionary[req] = completeCallback;
			
			req.loadRequest(url, _handleRequestCompletion);
			
		}
		
		private function _handleRequestCompletion (target:LoaderRequest):void {
			
			var content:Bitmap = target.content as Bitmap;
			
			var callback:Function = _callbacksDictionary[target];
			if (callback === null) {
				delete _callbacksDictionary[target];
			}
			
			if (callback !== null) callback(content);
			delete _callbacksDictionary[target];
			
		}
		
	}
}