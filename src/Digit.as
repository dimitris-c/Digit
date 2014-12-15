package
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import com.dimmdesign.utils.GlobalSound;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.BezierThroughPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.milkmangames.nativeextensions.GoViral;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import gr.funkytaps.digitized.core.Main;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.helpers.GameDataHelper;
	
	[SWF(frameRate="31", backgroundColor="#20213E")]
	public class Digit extends Sprite
	{
		TweenPlugin.activate([ BezierThroughPlugin ]);
		TweenLite.defaultEase = Expo.easeOut;
		
		private var _digitMain:Main;
		private var _goViral:GoViral;
		
		public function Digit()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// For use with the mute switch button on iOS
			if (Capabilities.manufacturer.indexOf('iOS') != -1) {
				SoundMixer.audioPlaybackMode = 'ambient';
			}
			
			if (GoViral.isSupported()) {
				_goViral = GoViral.create();
				
				if (GoViral.goViral.isFacebookSupported()) {
					GoViral.goViral.initFacebook(Settings.FB_APP_ID, '');
				}
				
			} else {
				trace("GoViral only works on mobile!");
			}
			
			NativeApplication.nativeApplication.executeInBackground = false;
			
			// Initializes the Main class
			_digitMain = new Main();
			addChild(_digitMain);
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
			
		}

		private function onExiting(event:Event):void
		{
			if (_digitMain) {
				_digitMain.destroy();
				_digitMain = null;
			}
			
			System.gc();
		}
	}
}