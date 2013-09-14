package gr.funkytaps.digitized.events
{
	import starling.events.Event;
	
	public class MenuEvent extends Event
	{
		public static const MENU_CLICKED:String = "menuClicked";
		
		public static const VIEW_LEADERBOARD:String = "leaderBoard";
		public static const VIEW_CREDITS:String = "credits";
		
		public var displayOnUserDemand:Boolean;
		public var highScore:String;
		
		public var viewToOpen:String; //leaderBoard, credits
		
		public function MenuEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}