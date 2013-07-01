package
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class DigitApp extends Sprite
	{
		public function DigitApp()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			trace('fuck yeah');
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
		}
	}
}