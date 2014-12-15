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
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class BaseButton extends Sprite implements IDestroyable
	{
		protected static const MAX_DRAG_DIST:Number = 10;
		
		protected var _holder:Sprite;
		
		protected var _background:Image;
		protected var _normalState:Texture;
		protected var _downState:Texture;
		
		protected var _isDown:Boolean;
		protected var _isEnabled:Boolean;
		
		protected var _backgroundWidth:Number;
		protected var _backgroundHeight:Number;
		
		protected var _padding:Number = 0;
		
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
			
			addEventListener(TouchEvent.TOUCH, _onTouched);
		}
		
		override public function get width():Number {
			return _backgroundWidth;
		}
		
		override public function get height():Number {
			return _backgroundHeight;
		}
		
		public function setNormalState():void { 
			_isDown = false;
			_background.texture = _normalState;
		}
		
		public function setDownState():void {
			_isDown = true;
			_background.texture = _downState;
		}
		
		protected function _onTouched(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (!_isEnabled || touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !_isDown) {
				setDownState();
			}
			else if (touch.phase == TouchPhase.MOVED && _isDown) { 
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					setNormalState();
				}
			}
			else if (touch.phase == TouchPhase.ENDED && _isDown)
			{
				setNormalState();
				dispatchEventWith(Event.TRIGGERED, true);
			}
			
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject {
			// on a touch test, invisible or untouchable objects cause the test to fail
			if (forTouch && (!visible || !touchable)) return null;
			
			var theBounds:Rectangle = getBounds(this);
			theBounds.inflate(_padding, _padding);
			
			if (theBounds.containsPoint(localPoint)) return this;
			return null;
		}
		
		public function get padding():Number { return _padding; }
		public function set padding(value:Number):void {
			_padding = value;
		}

		public function get isEnabled():Boolean { return _isEnabled; }
		public function set isEnabled(value:Boolean):void { _isEnabled = value; }
		
		public function destroy():void {
			
			removeEventListener(TouchEvent.TOUCH, _onTouched);
			
			_holder.removeFromParent(true);
			_background.removeFromParent(true);
			
			_normalState = null;
			_downState = null;
			
			_holder = null;
			_background = null;
		}
	}
}