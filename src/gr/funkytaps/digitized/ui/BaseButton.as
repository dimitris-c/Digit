package gr.funkytaps.digitized.ui
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