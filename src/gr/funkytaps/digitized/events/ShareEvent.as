package gr.funkytaps.digitized.events
{
	import starling.events.Event;

	public class ShareEvent extends Event
	{
		
		public static const SHARE_COMPLETED:String = "shareCompleted";
		public static const SHARE_FAILED:String = "shareFailed";
		
		public function ShareEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}