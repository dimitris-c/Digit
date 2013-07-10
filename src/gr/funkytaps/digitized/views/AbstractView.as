package gr.funkytaps.digitized.views
{
	import starling.display.Sprite;
	import starling.events.Event;
	import gr.funkytaps.digitized.interfaces.IView;
	
	public class AbstractView extends Sprite implements IView
	{
		public function AbstractView()
		{
			super();addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_init();
		}
		
		protected function _init():void{
			//override
		}
		
		public function update():void{
			//override
		}
		
		public function destroy():void{
			//override
		}
	}
}