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
	
	public class UICheckBox extends Sprite implements IDestroyable
	{
		
		private var _uncheckedStateImage:Bitmap;
		private var _checkedStateImage:Bitmap;

		private var _callback:Function;
		
		private var _isSelected:Boolean = false;
		
		public function UICheckBox(uncheckedStateImage:Bitmap, checkedStateImage:Bitmap, callback:Function = null)
		{
			super();
			
			_uncheckedStateImage = uncheckedStateImage;
			_checkedStateImage = checkedStateImage;
			
			_callback = callback;
			
			mouseChildren = false;
			mouseEnabled = true;
			buttonMode = true;
			useHandCursor = true;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
		}
		
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
			if (_uncheckedStateImage) {
				_uncheckedStateImage.visible = (_isSelected) ? false : true;
				_checkedStateImage.visible = (_isSelected) ? true : false;
			}
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_uncheckedStateImage.visible = true;
			_checkedStateImage.visible = false;
			
			addChild(_uncheckedStateImage);
			addChild(_checkedStateImage);
			
			addEventListener(MouseEvent.CLICK, _onClick);
		}

		private function _onClick(event:MouseEvent):void
		{
			_isSelected = !_isSelected;
			
			_uncheckedStateImage.visible = (_isSelected) ? false : true;
			_checkedStateImage.visible = (_isSelected) ? true : false;
			
			if (_callback != null) _callback();
			
		}
		
		public function destroy():void
		{
			while(numChildren>0) {
				removeChildAt(0);
			}
			
			_isSelected = false;
			
			_uncheckedStateImage = null;
			_checkedStateImage = null;
			
		}
	}
}