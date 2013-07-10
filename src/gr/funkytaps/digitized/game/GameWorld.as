package gr.funkytaps.digitized.game
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import gr.funkytaps.digitized.views.GameView;
	import gr.funkytaps.digitized.interfaces.IView;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameWorld extends Sprite
	{
		public static const MENU_STATE:int = 0;
		public static const PLAY_STATE:int = 1;
		public static const GAME_OVER_STATE:int = 2;
		
		private var _curView:IView;
		
		public function GameWorld()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(Event.ENTER_FRAME, update);
			
			//implement state logic
			
			_curView = new GameView();
			addChild(Sprite(_curView));
		}
		
		private function update(event:Event):void
		{
			if(_curView){				
				_curView.update();
			}
		}
	}
}