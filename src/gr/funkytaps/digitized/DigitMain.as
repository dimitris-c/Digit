package gr.funkytaps.digitized
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	import com.dimmdesign.core.IDestroyable;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	
	import gr.funkytaps.digitized.game.GameWorld;
	
	import starling.core.Starling;
	
	public class DigitMain extends Sprite implements IDestroyable
	{
		private var _starling:Starling;
		
		public function DigitMain()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage); 
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			Starling.multitouchEnabled = false;
			
			_starling = new Starling(GameWorld, stage);
			_starling.showStats = true;
			_starling.antiAliasing = 1;
			
			_starling.start();
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, _onActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, _onDeactivate);
			
		}
		
		protected function _onDeactivate(event:Event):void
		{
			// TODO: Implement function for deactivation
		}
		
		private function _onActivate(event:Event):void
		{
			// TODO: Implement function for activation
		}
		
		public function destroy():void
		{
			_starling.stop();
			_starling.dispose();
			_starling = null;
			
			System.gc();
		}
	}
}