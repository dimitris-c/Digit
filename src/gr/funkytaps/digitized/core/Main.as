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
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.System;
	
	import gr.funkytaps.digitized.game.GameWorld;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
	public class Main extends Sprite implements IDestroyable
	{
		private var _mStarling:Starling;
		
		private var iOS:Boolean;
		private var _background:Bitmap;
		
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
			
			Starling.multitouchEnabled = false;
			Starling.handleLostContext = !iOS;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
				ScaleMode.SHOW_ALL, iOS);
			
			var iPhone5:Boolean = (screenHeight == 1136);
			var isPad:Boolean = (screenWidth == 768 || screenWidth == 1536);
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2;
			var appDir:File = File.applicationDirectory;
			
			Settings.HEIGHT = (iPhone5) ? 568 : 480;
			Settings.HALF_HEIGHT = (iPhone5) ? 284 : 240;
			
			var assetsManager:AssetManager = new AssetManager(scaleFactor);
			assetsManager.verbose = false;
			
			assetsManager.enqueue( 
				appDir.resolvePath( 'assets/stars' ),
				appDir.resolvePath( 'assets/sounds' ),
				appDir.resolvePath( formatString('assets/fonts/{0}x', scaleFactor) ),
				appDir.resolvePath( formatString('assets/atlases/{0}x', scaleFactor) )
			);
			
			// Assign the assetsManager to a global static variable for easy access
			Assets.manager = assetsManager;
			
			_background = scaleFactor == 1 ? Assets.getBitmap('Default') : (iPhone5) ? Assets.getBitmap('Default568h') : Assets.getBitmap('DefaultHD');
			_background.smoothing = true;
			addChild(_background);
			
			// Create the starling instance.
			_mStarling = new Starling(GameWorld, stage, new Rectangle(0, 0, screenWidth, screenHeight));
			_mStarling.stage.stageWidth = stageWidth;
			_mStarling.stage.stageHeight = iPhone5 ? 568 : stageHeight;
			_mStarling.antiAliasing = 1;
			
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			
			_mStarling.addEventListener(starling.events.Event.ROOT_CREATED, _handleRootCreated);
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, _onActivate);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, _onDeactivate);

		}
		
		protected function onDoubleClick(event:MouseEvent):void
		{
			_mStarling.showStats = !_mStarling.showStats;
		}
		
		private function _handleRootCreated(event:Object, app:GameWorld):void
		{
			_mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, _handleRootCreated);
			
			var background:Texture = starling.textures.Texture.fromBitmap(_background, false, false, Starling.contentScaleFactor);
			
			removeChild(_background);
			_background = null;
			
			app.start(background);
			_mStarling.start();
			
			background = null;
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
			SoundMixer.stopAll();
			
			_mStarling.stop();
			_mStarling.dispose();
			_mStarling = null;
			
			System.gc();
		}
	}
}