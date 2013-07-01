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
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class UIToggleButton extends UISimpleButton implements IDestroyable
	{
		
		protected var _normalState:Bitmap;
		protected var _selectedState:Bitmap;
		
		private var _callback:Function = null;
		
		protected var _isSelected:Boolean = true;
		
		public function UIToggleButton(normalState:Bitmap, selectedState:Bitmap, callback:Function = null)
		{
			super(normalState, selectedState);
			
			_normalState = normalState;
			_selectedState = selectedState;
			
			_callback = callback;
			
		}

		public function get isSelected():Boolean {
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void {
			_isSelected = value;
			_toggleVisibilityButton();
		}

		override protected function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_isSelected = false;
			
			initButton();
			
		}
		
		override protected function initButton():void {
						
			addChild(_normalState);
			addChild(_selectedState);
			
			_normalState.visible = true;
			_selectedState.visible = false;
			
			addEventListener(MouseEvent.CLICK, _onClick);
			
		}

		protected function _onClick(event:MouseEvent):void
		{
			
			_isSelected = !_isSelected;

			_toggleVisibilityButton();
			
			if (_callback != null) _callback();
			
		}
		
		private function _toggleVisibilityButton():void {

			_normalState.visible = (_isSelected) ? false : true;
			_selectedState.visible = (_isSelected) ? true : false;
			
		}
		
		override public function destroy():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, _onClick); 
			
			while (numChildren > 0) {
				var child:* = removeChildAt(0);
				if (child is Bitmap) child.bitmapData.dispose();
				child = null;
			}
			
			_normalState = null;
			_selectedState = null;
		}
	}
}