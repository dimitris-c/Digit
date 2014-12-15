package gr.funkytaps.digitized.events
{
	import starling.events.Event;

	public class ViewEvent extends Event
	{
		public static const DESTROY_VIEW:String = "destroyView";
		
		public function ViewEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}