package com.dimmdesign.video
{
	import com.dimmdesign.core.IDestroyable;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class VideoLoader extends EventDispatcher implements IDestroyable
	{
		
		public static const LOADING:int = 0;
		public static const VIDEO_PLAYING:int = 1;
		public static const VIDEO_PAUSED:int = 2;
		public static const VIDEO_STOPPED:int = 3;
		
		
		private var _netConnection:NetConnection;

		private var _netStream:NetStream;
		public function get netStream():NetStream { return _netStream; }
		
		private var _bufferTime:Number;

		public function get bufferTime():Number { return _bufferTime; }
		public function set bufferTime(value:Number):void { 
			_bufferTime = value; 
			if (_netStream) _netStream.bufferTime = value;
		}
		
		private var _bufferTimeMax:Number;
		
		public function get bufferTimeMax():Number { return _bufferTimeMax; }
		public function set bufferTimeMax(value:Number):void { _bufferTimeMax = value; }
		
		private var _videoPath:String;

		public function get videoPath():String { return _videoPath; }
		public function set videoPath(value:String):void { _videoPath = value; }
		
		private var _isRTMP:Boolean;
		
		public function get isRTMP():Boolean { return _isRTMP; }
		public function set isRTMP(value:Boolean):void { _isRTMP = value; }
		
		private var _rtmpCommand:String;

		public function get rtmpCommand():String { return _rtmpCommand; }
		public function set rtmpCommand(value:String):void { _rtmpCommand = value; }
		
		private var _rtmpVideoName:String;

		public function get rtmpVideoName():String { return _rtmpVideoName; }
		public function set rtmpVideoName(value:String):void { _rtmpVideoName = value; }
		
		private var _name:String;

		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
		
		private var _videoContainer:Sprite;

		public function get videoContainer():Sprite { return _videoContainer; }
		public function set videoContainer(value:Sprite):void { _videoContainer = value; if (_video) _videoContainer.addChild( _video ); }
		
		private var _video:Video;
		public function get video():Video { return _video; }
		
		private var _videoWidth:Number;
		public function get videoWidth():Number { return _videoWidth; }

		private var _videoHeight:Number;
		public function get videoHeight():Number { return _videoHeight; }

		private var _volume:Number = 1;

		public function get volume():Number { return _volume; }

		public function set volume(value:Number):void {
			_volume = value;
			if (!_netStream) return;
			_netStream.soundTransform = new SoundTransform(_volume, 0);
		}
		
		
		private var _bytesLoaded:Number;

		public function get bytesLoaded():Number { return _bytesLoaded; }
		
		private var _bytesTotal:Number;
		
		public function get bytesTotal():Number { return _bytesTotal; }

		private var _loadProgress:Number;
		
		public function get loadProgress():Number { return _loadProgress; }
		
		private var _status:int;

		public function get status():int { return _status; }

		private var _isLoaded:Boolean;

		public function get isLoaded():Boolean { return _isLoaded; }
		
		
		/**
		 * @private Helper, for enterFrame listener 
		 */		
		private var _pulse:Shape = new Shape();

		
		/**
		 * @private The function to be used when a cuepoint is fired 
		 */		
		public var cuePointHandler:Function = null;
		
		private var _cuesDict:Dictionary;

		/**
		 * Used to store the cue points in a dictionary for fast seek 
		 */
		public function get cuesDict():Dictionary { return _cuesDict; }

		
		private var _videoPlaying:Boolean;
		private var _autoPlay:Boolean;
		private var _playStarted:Boolean;
		private var _dispatchProgress:Boolean;

		private var _seekID:Number;

		/**
		 * Creates a VideoLoader!
		 *  
		 * @param videoContainer - The container in which the video object will be added! Set to null, if you don't want the video to be added immediatelly
		 * @param videoWidth - The video width
		 * @param videoHeight - The video height
		 * @param autoPlay - Indicates if the video will start playing immediatelly
		 * 
		 */		
		public function VideoLoader(videoContainer:Sprite, videoWidth:Number, videoHeight:Number, autoPlay:Boolean = false )
		{
			
			_videoContainer = videoContainer;
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
			
			_autoPlay = autoPlay;
			
			_isLoaded = false;
			
			// Create the netConnection
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, _netStatusHandler);
			_netConnection.objectEncoding = ObjectEncoding.AMF0;
			_netConnection.client = this;
			
			// create the Video object
			_video = new Video(_videoWidth, _videoHeight);
			_video.smoothing = true;
			
			if (_videoContainer) {
				_videoContainer.addChild(_video);
				_videoContainer.scrollRect = new Rectangle(0, 0, _videoWidth, _videoHeight);
			}
			
			_netConnection.connect( null );
			
			_videoContainer.scrollRect = new Rectangle(0, 0, videoWidth, videoHeight);
			
			_pulse.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}

		/**
		 * 
		 * rtmp:[//host][:port]/[appname]/[video filename]
		 */		
		public function load(url:String):void
		{
			_videoPath = url;
			_name = url;
			
			_isRTMP = ( (_videoPath.substr(0, 7) == 'rtmp://'));
			if (_isRTMP) {
				_rtmpVideoName = _videoPath.substring(_videoPath.lastIndexOf("/") + 1);
				if (_videoPath.substr(-4) == '.flv') {
					_rtmpCommand = _videoPath.substr(0, _videoPath.length-4);
				}
				// connect to the streaming server
				_netConnection.close();
				_netConnection.connect( _rtmpCommand );
				
				_name = _rtmpVideoName;
				
			} else {
				if (_netStream) {
					
					_status = LOADING;
					
					_netStream.play( _videoPath );
					if (!_autoPlay) _netStream.pause();
					
				}
			}

		}
		
		public function playVideo():void {
			if (_netStream) _netStream.resume();
			_videoPlaying = true;
			_status = VIDEO_PLAYING;
		}
		
		public function pauseVideo():void {
			if (_netStream) _netStream.pause();
			_videoPlaying = false;
			_status = VIDEO_PAUSED;
		}
		
		public function seek (time:Number):void {
			if (_netStream) {
				if (time == 0 || time >= 0) {
					_netStream.bufferTime = 0.1;
					_netStream.seek( time );
				}
			}
		}
		
		public function gotoVideoCuePoint(name:String, forcePlay:Boolean = false):void {
			if  (_netStream) {
//				pauseVideo();
				seek( _cuesDict[name] );
				if (forcePlay) playVideo();
			}
		}
		
		/**
		 * @protected
		 */		
		protected function _netStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
					break;
				
				case "NetStream.Play.Start":
					
					break;
				
				case "NetStream.Play.Stop":
					_status = VIDEO_STOPPED;
					break;
				
				case "NetStream.Buffer.Full":
					dispatchEvent(new VideoLoaderEvent(VideoLoaderEvent.BUFFER_FULL));
					break;
				
				case "NetStream.Buffer.Empty":
					dispatchEvent(new VideoLoaderEvent(VideoLoaderEvent.BUFFER_EMPTY));
					break;
				
				case "NetStream.Seek.Notify":
					break;
				
				case "NetStream.Seek.Complete":
					break;
				
				// NetConnection
				case "NetConnection.Connect.Success":
					// create the netStream object upon receiving this event from the netConnection object
					_createNetStream();
					
					if (isRTMP) {
						_netStream.play( _rtmpVideoName );
					} else {
						_netStream.play( _videoPath );
					}
					
					if (!_autoPlay) _netStream.pause();
					break;
				
				case "NetConnection.Connect.Failed":
					break;
				
				case "NetStream.Play.Reset":
				case "NetStream.Pause.Notify":
					break;
				
				default:
				{
					break;
				}
			}
		}
		
		/**
		 * Creates the netStream and the video object
		 */		
		protected function _createNetStream():void
		{
			if (_netStream) return;
			
			// create the netStream object
			_netStream = new NetStream(_netConnection);
			_netStream.checkPolicyFile = true;
			_netStream.soundTransform = new SoundTransform(_volume);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, _netStatusHandler);
			_netStream.client = {onMetaData:_onMetaData, onCuePoint:_onCuePoint};
			_netStream.bufferTime = _bufferTime;
			_netStream.bufferTimeMax = _bufferTimeMax;
			_netStream.backBufferTime = 5;
			
			_video.attachNetStream(_netStream);
			
			if (_videoContainer) _videoContainer.addChild(_video);
			
		}

		private function _onEnterFrame(event:Event):void
		{
			if (_netStream) {
				if (_bytesLoaded == _netStream.bytesLoaded) return;
				_bytesLoaded = _netStream.bytesLoaded;
				_bytesTotal = _netStream.bytesTotal;
				_loadProgress = _netStream.bytesLoaded / _netStream.bytesTotal;
				if (_bytesLoaded == _bytesTotal) {
					_loadProgress = 1;
					_isLoaded = true;
					_pulse.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
					dispatchEvent(new VideoLoaderEvent(VideoLoaderEvent.VIDEO_LOADED));
				} else {
					if (_dispatchProgress) {
						dispatchEvent(new VideoLoaderEvent(VideoLoaderEvent.LOAD_PROGRESS, _loadProgress));
					}
				}
			}
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			if (type == VideoLoaderEvent.LOAD_PROGRESS) {
				_dispatchProgress = true;
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * When we receive the metadata we parse the cue points to a dictionary which will be used later on @see gotoVideoCuePoint('cue point name'); 
		 */		
		protected function _onMetaData(info:Object):void {
			//trace("onMeta:", _videoPath);
//			trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			
			if (info) {
				if (!info.cuePoints) return; 
				// if _cuesDict exists the metadata was called twice and if this happens we do nothing...
				if (_cuesDict) _cuesDict = null;
				_cuesDict = new Dictionary();
				var i:int = 0;
				var len:int = info.cuePoints.length;
				for (i = 0; i < len; ++i)
				{
					_cuesDict[info.cuePoints[i].name] = Number(info.cuePoints[i].time);
				}
			}
		}
		
		/**
		 * Handles the received cuepoints as the video plays 
		 */		
		protected function _onCuePoint(info:Object):void {
//			trace("cuepoint: time=" + info.time + "name=" + info.name + " type=" + info.type);
			if (cuePointHandler != null) cuePointHandler(info);
		}
		
		/**
		 * just for the flash player not to complain 
		 */		
		public function onXMPData(info:Object):void { }
		public function onBWCheck(...args):Number  { return 0; }
		
		public function onBWDone (...args):void
		{
			if (args.length > 0) {
				var bandwidth:Number = args[0];
			}
		}
		
		override public function toString():String {
			return '[CustomVideoLoader (name: ' + name + ', width: ' + _videoWidth + ', height: ' + _videoHeight + ')]';
		}

		public function destroy():void
		{
			pauseVideo();
			_video.clear();
			
			_netStream.close();
			_netConnection.close();
			
			_pulse = null;
			_video = null;
			
			_netStream = null;
			_netConnection = null;
			
			_cuesDict = null;
			
		}
		
		
	}
}