package gr.funkytaps.digitized.managers
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.core.Starling;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class SoundManager
	{
		
		// holds the soundchannels created
		private static var _currentSounds:Dictionary = new Dictionary(true);
		
		/**
		 * Plays a sound.
		 * 
		 * @param name - The name of the sound
		 * @param loop - The number of loops that the sound should make
		 * @param volume - The volume of the sound
		 * @param keepInCache - If <code>true</code> then the sound will be stored in a private dictionary for later use, perhaps for stopping the sound.
		 */		
		public static function playSound(name:String, loop:int = 0, volume:Number = 1, keepInCache:Boolean = true):void {

			if (!Assets.manager.getSound(name)) return;
			
			if (_currentSounds[name]) {
				_currentSounds[name] = Assets.manager.getSound(name).play(0, loop);
				return;
			}
				
			if (volume != 1) var st:SoundTransform = new SoundTransform(volume);
			var soundChannel:SoundChannel = Assets.manager.getSound(name).play(0, loop, st);
			
			if (keepInCache) _currentSounds[name] = soundChannel;
			
		}
		
		public static function stopSound(name:String):void {
			if (_currentSounds[name]) _currentSounds[name].stop();
		}
		
		/**
		 * Plays an effect sound.
		 * 
		 * @param name - The name of the effect cound
		 * @param volume - The volume of the effect sound
		 * 
		 */		
		public static function playSoundFX(name:String, volume:Number = 1):void {
			stopSound(name);
			playSound(name, 0, volume, false);
		}
		
		
	}
}