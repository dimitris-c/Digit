package gr.funkytaps.digitized.ui.buttons
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import flash.geom.Rectangle;
	
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CloseLeaderBoardViewButton extends BaseButton
	{
		private var _isToggled:Boolean = true;
		
		public function CloseLeaderBoardViewButton()
		{
			super(
				Assets.manager.getTexture('back-button-normal'),
				Assets.manager.getTexture('back-button-hover')
			)
			
			_padding = 10;
		}
		
		override protected function _onTouched(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			if (!_isEnabled || touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !_isDown) {
				_isDown = true;
				_isToggled = !_isToggled;
			}
			else if (touch.phase == TouchPhase.MOVED && _isDown) {
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					_isToggled = !_isToggled;
					toggleButton();
					_isDown = false;
				}
			}
			else if (touch.phase == TouchPhase.ENDED && _isDown)
			{
				toggleButton();
				_isDown = false;
				dispatchEventWith(Event.TRIGGERED, true);
			}
			
		}
		
		public function toggleButton():void {
			if (_isToggled) 
				setNormalState();
			else
				setDownState();
			
		}
		
	}
}

