package gr.funkytaps.digitized.views
{
	import gr.funkytaps.digitized.interfaces.IView;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class AbstractView extends Sprite implements IView
	{
		public function AbstractView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			_init();
			
		}
		
		protected function _init():void{
			//override
		}
		
		public function tweenIn():void {
			//override
		}
		
		public function tweenOut(onComplete:Function = null, onCompleteParams:Array = null):void {
			//override
		}
		
		public function view():DisplayObject {
			return this as DisplayObject
		}
		
		public function update(passedTime:Number = 0):void{
			//override
		}
		
		public function destroy():void{
			//override
		}
	}
}