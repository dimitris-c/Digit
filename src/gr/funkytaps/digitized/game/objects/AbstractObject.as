package gr.funkytaps.digitized.game.objects
{
	import com.dimmdesign.core.IDestroyable;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class AbstractObject extends Sprite implements IDestroyable
	{
		public function AbstractObject()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		protected function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_init();
		}
		
		/**
		 * Initialize the object once it's added to the stage 
		 */		
		protected function _init():void{
			
		}
		
		public function destroy():void {
			
		}
	}
}