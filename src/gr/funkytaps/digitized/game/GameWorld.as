package gr.funkytaps.digitized.game
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameWorld extends Sprite
	{
		public function GameWorld()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			var hero:DigitHero = new DigitHero();
			addChild(hero);
			
			hero.x = ((stage.stageWidth >> 1) - (hero.width >> 1)) | 0;
			hero.y = 300;	
		}
	}
}