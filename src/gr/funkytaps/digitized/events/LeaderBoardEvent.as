package gr.funkytaps.digitized.events
{
	import starling.events.Event;
	
	public class LeaderBoardEvent extends Event
	{
		public static const OPEN_LEADERBOARD:String = "openLeaderBoard";
		
		public var displayOnUserDemand:Boolean;
		public var highScore:String;
		
		public function LeaderBoardEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}