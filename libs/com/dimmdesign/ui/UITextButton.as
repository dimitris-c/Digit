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
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UITextButton extends Sprite implements IDestroyable
	{
		
		private var _tf:TextField;
		
		private var _backgroundShape:Shape;
		private var _backgroundColour:Number;
		
		private var _textFormat:TextFormat;
		private var _embedFonts:Boolean;
		
		private var _text:String;
		
		public function UITextButton(text:String, embedFonts:Boolean = false, textFormat:TextFormat = null, backgroundColour:Number = 0x000000)
		{
			_text = text;
			
			_textFormat = textFormat;
			_embedFonts = embedFonts;
			
			_backgroundColour = backgroundColour;
			
			mouseEnabled = true;
			mouseChildren = false;
			buttonMode = true;
			useHandCursor = true;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_configUI();
			
		}
		
		protected function _configUI ():void { 
			
			_tf = new TextField();
			if (_textFormat) _tf.defaultTextFormat = _textFormat;
			
			_tf.text = _text;
			_tf.antiAliasType = 'advanced';
			_tf.type = 'input';
			_tf.embedFonts = _embedFonts;
			_tf.autoSize = 'left';
			_tf.multiline = false;
			_tf.selectable = false;
			_tf.wordWrap = false;
			_tf.antiAliasType = 'advanced'
			
			if (_backgroundColour) {
				_backgroundShape = new Shape();
				_backgroundShape.graphics.beginFill(_backgroundColour, 1);
				_backgroundShape.graphics.drawRect(0, 0, _tf.textWidth + 8, _tf.textHeight + 8);
				_backgroundShape.graphics.endFill();
			}
			
			if (_backgroundShape) addChild(_backgroundShape);
			
			_tf.x = ((width >> 1) - (_tf.width >> 1)) | 0.5;
			_tf.y = ((height >> 1) - (_tf.height >> 1)) | 0.5;
			
			addChild(_tf);
			
		}
		
		public function destroy():void
		{
			while(numChildren>0)
				removeChildAt(0);
			
			_tf = null;
		}
	}
}