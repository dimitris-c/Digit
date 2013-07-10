package gr.funkytaps.digitized.objects
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class AbstractObject extends Sprite
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
		
		protected function _init():void{
			
		}
	}
}