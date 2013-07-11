package gr.funkytaps.digitized.game
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.interfaces.IView;
	import gr.funkytaps.digitized.views.GameView;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class GameWorld extends Sprite
	{

		
		public static const MENU_STATE:int = 0;
		public static const PLAY_STATE:int = 1;
		public static const GAME_OVER_STATE:int = 2;

		
		private var _curView:IView;
		
		private var _assets:AssetManager;
		
		public function GameWorld()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			Assets.manager.loadQueue( _onProgress );
			
			//TODO: implement state logic
			
		}
		
		private function _onProgress(progress:Number):void
		{
			trace("progress=", progress);
			
			if (progress == 1.0) {
				// init the freaking world
				_initWorld();
			}

		}
		
		private function _initWorld():void {
			
			_curView = new GameView();
			addChild(Sprite(_curView));
			addEventListener(Event.ENTER_FRAME, update);

		}
		
		private function update(event:Event):void
		{
			if(_curView){				
				_curView.update();
			}
		}
	}
}