package com.dimmdesign.utils
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.startSampling;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class DebugUtils
	{
		
		private static var _sprites:Dictionary;
		private static var _mouseUpCallbacks:Dictionary;
		private static var _reportPosition:Dictionary;
		private static var _draggingOffsetPoint:Point;
		
		private static var _lastSpriteDragged:Sprite = null;
		private static var _lockYMovement:Boolean;
		private static var _lockXMovement:Boolean;

		{
			_sprites = new Dictionary(true);
			_mouseUpCallbacks = new Dictionary(true);
			_reportPosition = new Dictionary(true);
		}
		
		/**
		 * Makes a Sprite draggable, note that the mouseChildren property is set to false
		 * You can also use the arrows keys to move the last sprite that was being dragged.
		 * 
		 * @param sprite The sprite to be draggable
		 * @param useKeys - (Optional) Boolean when set to true the last sprite that was being dragged can be moved with the arrows keys
		 * @param onMouseUpCallback - (Optional) A function that gets called when the mouse is up
		 * 
		 */
		public static function makeDraggable(sprite:Sprite, useKeys:Boolean = false, reportPosition:Boolean = true, onMouseUpCallback:Function = null):void {
			
			sprite.buttonMode = true;
			sprite.mouseEnabled = true;
			sprite.mouseChildren = false;
			
			_sprites[sprite] = sprite as Sprite;
			_reportPosition[sprite] = reportPosition;
			_mouseUpCallbacks[sprite] = onMouseUpCallback;
				
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			sprite.addEventListener(MouseEvent.ROLL_OVER, _onRollOver);
			sprite.addEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			
			if (useKeys) sprite.stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
		}
		
		public static function makeBitmapDraggable(bitmap:Bitmap, useKeys:Boolean = false, reportPosition:Boolean = true, onMouseUpCallback:Function = null):void {
			
			var container:Sprite = new Sprite();
			bitmap.parent.addChildAt(container, bitmap.parent.getChildIndex(bitmap));
			container.addChild(bitmap);
			
			makeDraggable(container, useKeys, reportPosition, onMouseUpCallback);
			
		}
		
		private static function _onRollOut(event:MouseEvent):void
		{
			event.target.filters = [];	
		}
		
		private static function _onRollOver(event:MouseEvent):void
		{
			event.target.filters = [new GlowFilter(0xFF0000, 1, 10, 10, 2, 1)];
		}

		private static function _onKeyUp(event:KeyboardEvent):void
		{
			if (_lastSpriteDragged != null) {
				
				_lastSpriteDragged.filters = [];
				
				if (event.keyCode == Keyboard.LEFT) {
					_lastSpriteDragged.x -= (event.shiftKey) ? 10 : 1;
				}
				
				if (event.keyCode == Keyboard.RIGHT) {
					_lastSpriteDragged.x += (event.shiftKey) ? 10 : 1;
				}
				
				if (event.keyCode == Keyboard.UP) {
					_lastSpriteDragged.y -= (event.shiftKey) ? 10 : 1;
				}
				
				if (event.keyCode == Keyboard.DOWN) {
					_lastSpriteDragged.y += (event.shiftKey) ? 10 : 1;
				}
				
				if (_reportPosition[_lastSpriteDragged]) trace('x:', _lastSpriteDragged.x, 'y:', _lastSpriteDragged.y);
				
				if (_mouseUpCallbacks[_lastSpriteDragged] != null) _mouseUpCallbacks[_lastSpriteDragged](_lastSpriteDragged);
			}
		}

		private static function _onMouseUp(event:MouseEvent):void
		{
			var sprite:Sprite = event.target as Sprite; // get the parent which is 
			sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			sprite.stopDrag();
			
			_lastSpriteDragged = sprite;
			
			if (_reportPosition[sprite]) trace('x:', sprite.x, 'y:', sprite.y);
			
			if (_mouseUpCallbacks[sprite] != null) _mouseUpCallbacks[sprite](sprite);
		}

		private static function _onMouseDown(event:MouseEvent):void
		{
			var sprite:Sprite = event.target as Sprite;
			sprite.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			
			sprite.startDrag();
		}

	}
}