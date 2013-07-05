package
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.System;
	
	import gr.funkytaps.digitized.DigitMain;
	
	public class DigitApp extends Sprite
	{
		private var _digitMain:DigitMain;
		
		public function DigitApp()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_digitMain = new DigitMain();
			addChild(_digitMain);
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
			
		}

		private function onExiting(event:Event):void
		{
			_digitMain.destroy();
			_digitMain = null;
			
			System.gc();
		}
	}
}