package com.dimmdesign.debugger
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	import com.adobe.serialization.json.JSON;
	import com.dimmdesign.core.IDestroyable;
	import com.dimmdesign.ui.UIScroller;
	import com.dimmdesign.ui.UISimpleButton;
	import com.dimmdesign.ui.UITextButton;
	import com.dimmdesign.utils.DateUtils;
	import com.dimmdesign.utils.DrawUtils;
	import com.dimmdesign.utils.TextUtils;
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/**
	 * Creates a visual console debugger. To be used with Trace.log(...values) or log(...values) 
	 * 
	 * @example
	 * Typical usage 
	 	<listing version="3.0">
	 		var debugger:Debugger = new Debugger();
			addChild(debugger);
			
			// Assign the debugger's textfield to the static class Trace. @see Trace class for more parameters
			Trace.console = debugger.tf;
			// Enable the log for Trace.
			logEnabled = true;
	 	</listing>
	 *  
	 * @author Dimitris Chatzieleftheriou
	 * 
	 */	
	public class Debugger extends Sprite implements IDestroyable
	{
		
		private static var _instance:Debugger;
		private static var _canInit:Boolean = true;
		
		private var STYLESHEET:String = 'p { font-size: 11; font-family: Menlo, Monaco, Tahoma; color: #CCCCCC; }' +
										'.coloured { font-size: 11; font-family: Menlo, Monaco, Tahoma; color: #e9e19a; }' +
										'.error { font-size: 11; font-family: Menlo, Monaco, Tahoma; color: #e5503c; }';
		
		private var _width:Number;
		private var _height:Number;
		
		private var _password:String = 'debug';
		private var _pressedKeys:String;
		private var _clearKeysTimer:Timer;
		
		private var _container:Sprite;
		private var _tf:TextField;
		private var _tfMask:Sprite;
		
		private var _clearButton:UITextButton;
		private var _copyToClipboardButton:UITextButton;
		private var _saveConsoleButton:UITextButton;
		
		private var _consoleEnabled:Boolean;
		private var _traceEnabled:Boolean;
		private var _showTraceOnly:Boolean;
		private var _showInBrowserConsole:Boolean;
		
		private var _useSpaceToToggleVisibility:Boolean;

		private var _header:Sprite;
		
		private var _scroller:UIScroller,
					_scrollerHolder:Sprite,
					_scrollHandle:Sprite,
					_scrollTrack:Sprite,
					
					SCROLLER_TRACK_COLOUR:Number = 0xDBDBDB,
					SCROLLER_HANDLE_COLOUR:Number = 0x999999;
		
		/**
		 * Creates a visual console debugger. To be used with Trace.log(...values) or log(...values) @see Trace  
		 * 
		 * @param width A number for the debugger's width
		 * @param height A number for the debugger's height
		 * @param consoleEnabled If <code>true</code> the console shows all logs otherwise it doesn't
		 * @param shown
		 * 
		 */					
		public function Debugger(width:Number = 570, height:Number = 260, consoleEnabled:Boolean = true)
		{
			super();
			
			_width = width;
			_height = height;
			
			_consoleEnabled = consoleEnabled;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		public function get useSpaceToToggleVisibility():Boolean { return _useSpaceToToggleVisibility; }
		public function set useSpaceToToggleVisibility(value:Boolean):void { _useSpaceToToggleVisibility = value; }

		public function get consoleEnabled():Boolean { return _consoleEnabled; }
		public function set consoleEnabled(value:Boolean):void { _consoleEnabled = value; logEnabled = _consoleEnabled; }
		
		public function get tf():TextField { return _tf; }

		private function _onAddedToStage(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			
			scrollRect = new Rectangle(0, 0, _width, _height);
			DrawUtils.drawRectangleShape(graphics, 0, 0, _width, _height, 0x000000, 0.9);
			
			_pressedKeys = '';
			
			doubleClickEnabled = true;
			
			_clearKeysTimer = new Timer(2000, 0);
			_clearKeysTimer.addEventListener(TimerEvent.TIMER, _onTimer);
			
			_container = new Sprite();
			_container.x = 3;
			_container.y = 3;
			addChild(_container);
			
			_tfMask = new Sprite();
			DrawUtils.drawRectangleShape(_tfMask.graphics, 0, 0, _width-19,_height-10);
			_container.addChild(_tfMask);
			
			_tf = TextUtils.createTextField(STYLESHEET, false, 'left', 'advanced', true, true);
			_tf.htmlText = '<p>' + 'Console initialized' + '</p>';
			_tf.width = _width - 20;
			_tf.height = height - 30;
			_tf.mouseEnabled = true;
			_tf.selectable = true;
			_container.addChild(_tf);
			
			_tf.addEventListener(Event.CHANGE, _onChange);
			
			_tf.mask = _tfMask;
			
			_buildScroller();
			
			_buildButtons();
			
		}
		
		private function _onChange(event:Event):void
		{
			if (_scroller) {
				_scroller.updateHandleHeight();
				_scroller.scrollTo(_tf.height | 0.5);
			}
		}


		private function _onTimer(event:TimerEvent):void
		{
			_pressedKeys = '';
		}
		
		private function _onKeyDown(event:KeyboardEvent):void
		{
			
			if (!_clearKeysTimer.running) _clearKeysTimer.start();
			
			var pressedChar:String = String.fromCharCode( event.charCode );
			_pressedKeys = _pressedKeys.concat(pressedChar);
			if (_pressedKeys == _password) {
				visible = !visible;
				_pressedKeys = '';
				_clearKeysTimer.stop();
				return;
			}
			
			if (_useSpaceToToggleVisibility) {
				
				if (event.keyCode == Keyboard.SPACE) {
					visible = !visible;
					_pressedKeys = '';
				}
			}
		
		}

		private function _clearLog():void 
		{
			_tf.htmlText = '<p></p>';	
		}
		
		private function _copyToClipboard():void {
			
			System.setClipboard( _tf.text );
			
		}
		
		private function _saveConsole():void {
			
			var fileRef:FileReference = new FileReference();
			
			var date:Date = new Date();
			
			var formatedDate:String = date.toString().substring(0, date.toString().indexOf('GMT')-4);
			
			var fileName:String = 'Console-' + formatedDate;
			fileName = fileName.replace(/ /gi, '-');
			fileName = fileName.replace(/:/gi, '');
			
			fileRef.save(_tf.text, fileName + '.txt');
			
		}
		
		private function _buildButtons ():void {
			
			_clearButton = new UITextButton('CLEAR', false, new TextFormat('Monaco', '9', 0xFFFFFF), 0x999999);
			_clearButton.addEventListener(MouseEvent.CLICK, _onClearClick);
			addChild(_clearButton);
			
			_copyToClipboardButton = new UITextButton('COPY', false, new TextFormat('Monaco', '9', 0xFFFFFF), 0x999999);
			_copyToClipboardButton.addEventListener(MouseEvent.CLICK, _onCopyToClipboard);
			addChild(_copyToClipboardButton);
			
			_saveConsoleButton = new UITextButton('SAVE', false, new TextFormat('Monaco', '9', 0xFFFFFF), 0x999999);
			_saveConsoleButton.addEventListener(MouseEvent.CLICK, _onSaveClick);
			addChild(_saveConsoleButton);
			
			_saveConsoleButton.x = _width - _saveConsoleButton.width - 3;
			_saveConsoleButton.y = _height - _saveConsoleButton.height - 5;
		
			_copyToClipboardButton.x = _saveConsoleButton.x - _copyToClipboardButton.width - 5;
			_copyToClipboardButton.y = _height - _copyToClipboardButton.height - 5;
			
			_clearButton.x = _copyToClipboardButton.x - _clearButton.width - 5;
			_clearButton.y = _height - _clearButton.height - 5;
		}

		private function _onSaveClick(event:MouseEvent):void
		{
			_saveConsole();	
		}
		
		protected function _onCopyToClipboard(event:MouseEvent):void
		{
			_copyToClipboard();
		}
		
		private function _onClearClick(event:MouseEvent):void
		{
			_clearLog();
			_scroller.resetScroller();
		}			
		
		private function _buildScroller ():void {
			
			_scrollerHolder = new Sprite();
			_scrollerHolder.mouseChildren = true;
			_scrollerHolder.x = _width - 10;
			_scrollerHolder.y = 2;
			addChild(_scrollerHolder);
			
			_scrollTrack = new Sprite();
			_scrollTrack.graphics.beginFill(SCROLLER_TRACK_COLOUR, 1);
			_scrollTrack.graphics.drawRect(0, 0, 8, _height-30);
			_scrollTrack.graphics.endFill();

			_scrollHandle = new Sprite();
			_scrollHandle.mouseEnabled = true;
			
			_scrollHandle.graphics.beginFill(SCROLLER_HANDLE_COLOUR, 1);
			_scrollHandle.graphics.drawRect(0, 0, 8, 40);
			_scrollHandle.graphics.endFill();
			
			_scrollHandle.y = _scrollTrack.y;
			
			_scrollerHolder.addChild(_scrollTrack);
			_scrollerHolder.addChild(_scrollHandle);

			_scroller = new UIScroller(_tf, _tfMask, _scrollHandle, _scrollTrack, stage);
			_scroller.initScroller();
			
		}
			
		public function destroy():void
		{
			while(numChildren>0){
				var child:* = removeChildAt(0);
				if (child is IDestroyable) child.destroy();
				child = null;
			}
			
			_scroller = null;
			_scrollerHolder = null;
			_scrollHandle = null;
			_scrollTrack = null;
			_tf = null;
			_tfMask = null;
			_container = null;
		}
	}
}