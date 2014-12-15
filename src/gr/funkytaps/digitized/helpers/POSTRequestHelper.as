package gr.funkytaps.digitized.helpers
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import gr.funkytaps.digitized.events.POSTHelperEvent;
	
	import starling.events.EventDispatcher;
	
	public class POSTRequestHelper extends EventDispatcher
	{
		public static const POST_INITIALIZED:String = "postInitialized";
		
		public static const ACTION_REQUEST_TOP_TEN:String = "get_high_scores";
		public static const ACTION_SAVE_HIGH_SCORE:String = "save_score";
		private var _action:String; //see above
		
		private var basePath:String = "http://www.digitized.gr/game/v1.0.0/";
		private var url:String;
		private var loader:URLLoader;
		private var req:URLRequest;
		
		private var _responseHandler:Function;
		
		public function POSTRequestHelper()
		{
			super();
		}
		
		public function init(action:String):void{
			trace("INIT POST: ", action);
			url = basePath + action + ".php";
			loader = new URLLoader(); 
			addListeners(loader);
			req = new URLRequest(url);
			req.method = URLRequestMethod.POST; 

			dispatchEvent(new POSTHelperEvent(POSTRequestHelper.POST_INITIALIZED));
		}
		
		public function killHelper():void{
			removeListeners(loader);
			loader = null;
			req = null;
		}
		
		/**
		 * Adding Listeners 
		 * @param dispatcher
		 * 
		 */		
		private function addListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		/**
		 * Removing Listeners 
		 */	
		private function removeListeners(dispatcher:IEventDispatcher):void{
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(Event.OPEN, openHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		//HANDLERS
		private function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			trace("completeHandler: " + loader.data);
			
			var obj:Object = JSON.parse(loader.data);
			trace(obj);
			
			_responseHandler(obj);
			
			if(_action == POSTRequestHelper.ACTION_REQUEST_TOP_TEN){
				
			}
			else if(_action == POSTRequestHelper.ACTION_SAVE_HIGH_SCORE){
				
			}
		}
		
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		/**
		 * Requesting Top 10 
		 */		
		public function requestTopTen(handler:Function, params:URLVariables):void{
			_responseHandler = handler;
			_action = POSTRequestHelper.ACTION_REQUEST_TOP_TEN;
			try {
				if(params){
					req.data = params;
				}
				loader.load(req);
			} 
			catch (error:Error) {
				trace("Unable to get top 10.");
			}
		}
		
		/**
		 * Saving high score
		 */		
		public function saveHighScore(handler:Function, params:URLVariables):void{
			_responseHandler = handler;
			_action = POSTRequestHelper.ACTION_SAVE_HIGH_SCORE;
			try {
				if(params){
					req.data = params;
				}
				loader.load(req);
			} 
			catch (error:Error) {
				trace("Unable to save high score.");
			}
		}
	}
}