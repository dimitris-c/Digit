package gr.funkytaps.digitized.ui.buttons
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import com.dimmdesign.core.IDestroyable;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class BaseButton extends Sprite implements IDestroyable
	{
		private static const MAX_DRAG_DIST:Number = 50;
		
		protected var _holder:Sprite;
		
		protected var _background:Image;
		protected var _normalState:Texture;
		protected var _downState:Texture;
		
		protected var _isDown:Boolean;
		protected var _isEnabled:Boolean;
		
		protected var _backgroundWidth:Number;
		protected var _backgroundHeight:Number;
		
		/**
		 * Base class for the Buttons. 
		 * For use with Starling display list.
		 */		
		public function BaseButton(normalState:Texture, downState:Texture = null)
		{
			super();
			
			_normalState = normalState;
			_downState = downState ? downState : normalState;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		protected function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_isEnabled = true;
			
			_holder = new Sprite();
			
			_background = new Image(_normalState);
			_holder.addChild(_background);
			addChild(_holder);
			
			_backgroundWidth = _background.width;
			_backgroundHeight = _background.height;
			
			addEventListener(TouchEvent.TOUCH, onTouched);
		}
		
		protected function _setNormalState():void { 
			_isDown = false;
			_background.texture = _normalState;
		}
		
		protected function _setDownState():void {
			_isDown = true;
			_background.texture = _downState;
		}
		
		protected function onTouched(evt:TouchEvent):void
		{
			
			var touch:Touch = evt.getTouch(this);
			if (!_isEnabled || touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !_isDown) {
				_setDownState();
			}
			else if (touch.phase == TouchPhase.MOVED && _isDown) { 
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					_setNormalState();
				}
			}
			else if (touch.phase == TouchPhase.ENDED && _isDown)
			{
				_setNormalState();
				dispatchEventWith(Event.TRIGGERED, true);
			}
		}
		
		public function get isEnabled():Boolean { return _isEnabled; }
		public function set isEnabled(value:Boolean):void { _isEnabled = value; }
		
		public function destroy():void {
			
			removeEventListener(TouchEvent.TOUCH, onTouched);
			
			_holder.removeFromParent(true);
			_background.removeFromParent(true);
			
			_normalState = null;
			_downState = null;
			
			_holder = null;
			_background = null;
		}
	}
}