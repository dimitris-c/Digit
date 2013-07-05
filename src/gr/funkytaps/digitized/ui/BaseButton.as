package gr.funkytaps.digitized.ui
{
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class BaseButton extends Sprite
	{
		
		
		/**
		 * Base class for the Buttons. 
		 * For use with Starling display list.
		 */		
		public function BaseButton()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			
		}
	}
}