package gr.funkytaps.digitized.core
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
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
	
	import gr.funkytaps.digitized.game.GameWorld;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
	public class Main extends Sprite implements IDestroyable
	{
		private var _mStarling:Starling;
		
		private var iOS:Boolean;
		
		public function Main()
		{
			super();
			
			addEventListener(flash.events.Event.ADDED_TO_STAGE, _onAddedToStage);
			
		}
		
		private function _onAddedToStage(event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, _onAddedToStage);
			
			var stageWidth:Number = Settings.WIDTH;
			var stageHeight:Number = Settings.HEIGHT;
			
			var screenWidth:Number = stage.fullScreenWidth;
			var screenHeight:Number = stage.fullScreenHeight;
			
			iOS = (Capabilities.manufacturer.indexOf('iOS') != -1);
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = !iOS;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
				ScaleMode.SHOW_ALL, iOS);
			
			var iPhone5:Boolean = (screenHeight == 1136);
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2;
			var appDir:File = File.applicationDirectory;
			var assetsManager:AssetManager = new AssetManager(scaleFactor);
			assetsManager.verbose = true;
			assetsManager.enqueue( 
				appDir.resolvePath( 'atlases/temp' ),
				appDir.resolvePath( formatString('atlases/{0}x', scaleFactor) )
			);
			
			Assets.manager = assetsManager;
			
			_mStarling = new Starling(GameWorld, stage, new Rectangle(0, 0, screenWidth, screenHeight));
			_mStarling.stage.stageWidth = stageWidth;
			_mStarling.stage.stageHeight = iPhone5 ? 568 : stageHeight;
			_mStarling.showStats = Capabilities.isDebugger;
			_mStarling.antiAliasing = 1;
		
			_mStarling.addEventListener(starling.events.Event.ROOT_CREATED, _handleRootCreated);
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, _onActivate);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, _onDeactivate);

		}
		
		private function _handleRootCreated(event:Object, app:GameWorld):void
		{
			_mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, _handleRootCreated);
			
			// TODO: Remove background (we should have created one)
			
			_mStarling.start();
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