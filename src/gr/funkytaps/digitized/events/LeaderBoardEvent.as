package gr.funkytaps.digitized.events
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import starling.events.Event;
	
	public class LeaderBoardEvent extends Event
	{
		public static var OPEN_LEADERBOARD:String = 'openLeaderboard';
		
		public var displayOnUserDemand:*;
		public var highScore:*;
		
		public function LeaderBoardEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}