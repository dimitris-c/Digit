package com.dimmdesign.ui
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	import com.dimmdesign.core.IDestroyable;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class UIScroller extends Sprite implements IDestroyable
	{
		protected var 
				_stage:Stage,
				
				_handle:Sprite,
				_track:Sprite,

				_content:*, // can be anything, bitmap, sprite, movieclip...
				_contentMask:Sprite,
				
				_startY:Number,
				_minY:Number,
				_maxY:Number,
				
				_yOffset:Number,
				
				_mouseOffsetY:Number,
				_draggingAreaRect:Rectangle;
		
		
		/**
		 * A scroller wrapper.
		 * @param content The content that will be scroller.
		 * @param contentMask The content mask
		 * @param handle The handle for the scroller
		 * @param track The tracking area for the handle of the scroller
		 * @param stage The stage that will be used for the scroller.
		 * @param yOffset If a value is passed it will subtract the value from the minY and maxY.
		 * 
		 */			
		public function UIScroller(content:*, contentMask:Sprite, handle:Sprite, track:Sprite, stage:Stage)
		{
			super();
			
			_content = content;
			_contentMask = contentMask;
			_handle = handle;
			_track = track;
		
			_stage = stage;
		}
		
		/**
		 * Setters 
		 */				
		
		public function set handle (value:Sprite):void { _handle = value; }
		
		public function set track (value:Sprite):void {	_track = value;	}
		
		public function set content (value:*):void { _content = value; }
		
		public function set contentMask (value:Sprite):void { _contentMask = value; }
		
		/**
		 * Initializes the scroller.  
		 */		
		public function initScroller():void
		{
			
			_minY = _handle.y;
			_maxY = _track.height - (_handle.height - _minY);
			_startY = _content.y;
			
			_draggingAreaRect = new Rectangle(_track.x, _minY, 0, _maxY);
			
			_handle.buttonMode = true;
			
			resetScroller();
			
			_track.addEventListener(MouseEvent.CLICK, _onTrackClick);
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, _onHandleMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
			
		}
		
		/**
		 * Places the scroller and the content to the desired position
		 * @param pos - A number representing the scroll position.
		 * 
		 */
		public function scrollTo (pos:Number):void {
			
			if (pos <= 0) return;
			// find the percantage from the given number. 
			var percentFromPos:Number = ( pos / (_content.height - _contentMask.height) );
			// limit the percentage
			if (percentFromPos > 1) {
				percentFromPos = 1;
			} else if (percentFromPos < 0) {
				percentFromPos = 0;
			}
			
			var handleY:Number = ((_maxY - _startY) * percentFromPos) - _startY;
			
			_handle.y = handleY;
			
			if (handleY <= _minY) _handle.y = _minY;
			if (handleY >= _maxY) _handle.y = _maxY;
						
			var targetY:Number = _contentMask.y + (- percentFromPos * (_content.height - _contentMask.height));
			
			_content.y = targetY;
			
		}
		
		/** 
		 * Resets the scroller to the top and resizes the handle as well.
		 */		
		public function resetScroller ():void {
			
			_handle.y = _minY;
			
			updateHandleHeight();
			
			_updatePosition();
			
		}
		
		public function updateTrackHeight ($trackHeight:Number = 0):void {
			
			var _trackHeight:Number = ($trackHeight > 0) ? $trackHeight : _contentMask.height;
			_track.height = (_trackHeight < 20) ? 20 : _trackHeight;
			
			_maxY = _track.height - (_handle.height - _minY);
			
		}
		
		public function updateHandleHeight ():void {
			
			var handleHeight:Number = (_contentMask.height / _content.height) * _track.height;
			_handle.height = (handleHeight < 20) ? 20 : handleHeight;
			
			_maxY = _track.height - (_handle.height - _minY);
			
		}
		
		/**
		 * @private 
		 */		
		private function _updatePosition ():void {
			
			if (_content.height <= _contentMask.height) { 
				_handle.visible = false;
				
			} else {
				_handle.visible = true;
			
				if (_handle.y <= _minY) _handle.y = _minY;
				if (_handle.y >= _maxY) _handle.y = _maxY;
				
				var scrollPercent:Number = (_handle.y - _startY) / (_maxY - _startY);
				
				var targetY:Number = _contentMask.y + (- scrollPercent * (_content.height - _contentMask.height));
				
				_content.y = targetY;
			}
		}
		
		private function _onMouseWheel(event:MouseEvent):void
		{
			if (_contentMask.hitTestPoint(_stage.mouseX, _stage.mouseY)) { 
				_handle.y = _handle.y - event.delta;
				
				if (_handle.y <= _minY)	_handle.y = _minY;
				if (_handle.y >= _maxY)	_handle.y = _maxY;
				
				_updatePosition();
				
				event.updateAfterEvent();
			}
		}

		private function _onHandleMouseDown(event:MouseEvent):void
		{
			_mouseOffsetY = mouseY - _handle.y;
			
			_handle.startDrag(false, _draggingAreaRect);
			
			_handle.removeEventListener(MouseEvent.MOUSE_DOWN, _onHandleMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}

		private function _onMouseUp(event:MouseEvent):void
		{
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, _onHandleMouseDown);
			
			_handle.stopDrag();
			
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}

		private function _onMouseMove(event:MouseEvent):void
		{
			_handle.y = mouseY - _mouseOffsetY;
			
			_updatePosition();
			
			event.updateAfterEvent();
		}

		private function _onTrackClick(event:MouseEvent):void
		{
			var scrollTo:Number = 0;
			var top:Number = _track.y;
			var bottom:Number = _track.y - _track.height;
			
			if (mouseY <= _handle.y)
			{
				scrollTo = mouseY;
			}
			else if (mouseY >= bottom)
			{
				scrollTo = mouseY - _handle.height;
			}
			
			_handle.y = scrollTo;
			
			_updatePosition();
		}
		
		public function destroy():void
		{
			if (_track) _track.removeEventListener(MouseEvent.CLICK, _onTrackClick);
			if (_handle) _handle.removeEventListener(MouseEvent.MOUSE_DOWN, _onHandleMouseDown);
			if (_stage) _stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			if (_stage) _stage.removeEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
		}
	}
} 