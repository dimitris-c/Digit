package com.dimmdesign.video
{
	import flash.events.Event;

	public class VideoLoaderEvent extends Event
	{
		public static const BUFFER_EMPTY:String = "bufferEmpty";
		public static const BUFFER_FULL:String = "bufferFull";
		public static const BUFFER_FLUSH:String = "bufferFlush";
		public static const VIDEO_LOADED:String = "movieLoaded";
		public static const SECURITY_ERROR:String = "securityError";
		public static const LOAD_PROGRESS:String = 'loadProgress';

		private var _progress:Number;

		public function VideoLoaderEvent(type:String, progress:Number = 0)
		{
			super(type,false,false);
			
			this._progress = progress;

		}
		
		public function get progress():Number
		{
			return _progress;
		}

		public override function clone():Event
		{
			return new VideoLoaderEvent(type, progress);
		}

		public override function toString():String
		{
			return formatToString("VideoLoaderEvent", progress);
		}
	}
}