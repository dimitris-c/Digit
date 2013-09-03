package gr.funkytaps.digitized.events
{
	import starling.events.Event;
	
	public class POSTHelperEvent extends Event
	{
		public static const POST_INITIALIZED:String = "initiliazedPOST";
		
		public function POSTHelperEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}

