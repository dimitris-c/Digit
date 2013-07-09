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
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import avmplus.INCLUDE_ACCESSORS;
	
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.game.GameWorld;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class DigitMain extends Sprite implements IDestroyable
	{
		private var _mStarling:Starling;
		
		private var iOS:Boolean;
		
		public function DigitMain()
		{
			super();
			
			addEventListener(flash.events.Event.ADDED_TO_STAGE, _onAddedToStage);
			
		}
		
		private function _onAddedToStage(event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, _onAddedToStage);
			
			var stageWidth:Number = Settings.WIDTH;
			var stageHeight:Number = Settings.HEIGHT;
			
			iOS = (Capabilities.manufacturer.indexOf('iOS') != -1);
			
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = !iOS;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
				ScaleMode.NO_BORDER, iOS);
			
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2;
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = new AssetManager(scaleFactor);
			
			// TODO: add assets to assetsManager
			
			_mStarling = new Starling(GameWorld, stage, viewPort);
			_mStarling.stage.stageWidth = stageWidth;
			_mStarling.stage.stageHeight = stageHeight;
			_mStarling.showStats = true;
			_mStarling.antiAliasing = 1;
		
			_mStarling.addEventListener(starling.events.Event.ROOT_CREATED, _handleRootCreated);
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, _onActivate);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, _onDeactivate);

		}
		
		private function _handleRootCreated(event:Object, app:GameWorld):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function _onDeactivate(event:flash.events.Event):void
		{
			// Stops Starling, when the app becomes deactivated
			_mStarling.stop();
		}
		
		private function _onActivate(event:flash.events.Event):void
		{
			// Starts Starling, when the app becomes active
			_mStarling.start();
		}
		
		public function destroy():void
		{
			_mStarling.stop();
			_mStarling.dispose();
			_mStarling = null;
			
			System.gc();
		}
	}
}