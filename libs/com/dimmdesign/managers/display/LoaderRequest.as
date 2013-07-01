package com.dimmdesign.managers.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class LoaderRequest
	{
		private var _loader:Loader;
		private var _urlRequest:URLRequest;
		private var _url:String;
		

		private var _completeCallback:Function;
		private var _onProgressCallback:Function;
		private var _openCallback:Function;
		private var _errorCallback:Function;
		
		private var _content:*;
		
		public function LoaderRequest()
		{
		}
		
		public function get loader():Loader { return _loader; }
		
		public function get content():* { return _content; }
		
		public function loadRequest (url:String, onComplete:Function, onProgress:Function = null, onOpen:Function = null,  onError:Function = null):void {
			
			_completeCallback = onComplete;
			if (onProgress != null) _onProgressCallback = onProgress;
			if (onOpen != null) _openCallback = onOpen;
			if (onError != null) _errorCallback = onError;
			
			_url = url;
			_urlRequest = new URLRequest( _url );
			
			var loaderContext:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
			
			_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
			_loader.contentLoaderInfo.addEventListener(Event.OPEN, _onOpen);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			try{
			_loader.load( _urlRequest, loaderContext );
			}catch(e:Error) {
				trace (e);
			}
			
		}

		private function _onProgress(event:ProgressEvent):void
		{
			if (_onProgressCallback != null) _onProgressCallback(event);
		}
		
		public function closeRequest (unloadContent:Boolean = false):void {
			if (_loader) {
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _onComplete);
				_loader.contentLoaderInfo.removeEventListener(Event.OPEN, _onOpen);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
				
				try {
					_loader.close();
				} catch (e:Error) {  }
				
				if (unloadContent) {
					_loader.unload();
				}
			}
		}

		private function _onHttpStatus(event:HTTPStatusEvent):void
		{
			if (_errorCallback != null) 
				_errorCallback ( this );
		}

		private function onIoError(event:IOErrorEvent):void
		{
			if (_errorCallback != null) 
				_errorCallback ( this );
		}

		private function _onOpen(event:Event):void
		{
			if (_openCallback != null) 
				_openCallback ( this );
		}

		private function _onComplete(event:Event):void
		{
			
			_content = _loader.content;
						
			_completeCallback (this);
			_completeCallback = null;
			closeRequest( true );
		}
		
	}
}