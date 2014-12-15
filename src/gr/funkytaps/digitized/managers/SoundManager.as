package gr.funkytaps.digitized.managers
{
	import flash.media.Sound;
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
		private static var _currentSounds:Dictionary = new Dictionary();
		
		/**
		 * Plays a sound.
		 * 
		 * @param name - The name of the sound
		 * @param loop - The number of loops that the sound should make
		 * @param volume - The volume of the sound
		 * @param keepInCache - If <code>true</code> then the sound will be stored in a private dictionary for later use, perhaps for stopping the sound.
		 */		
		public static function playSound(name:String, loop:int = 0, volume:Number = 1, resume:Boolean = false, keepInCache:Boolean = true):void {

			if (!Assets.manager.getSound(name)) return;
			
			var _st:SoundTransform = new SoundTransform();
			
			if (_currentSounds[name]) {
				_st.volume = volume;
				_currentSounds[name].volume = volume;
				var pausePosition:Number = (resume) ? 0 : _currentSounds[name].pausePosition;
				_currentSounds[name].soundChannel = _currentSounds[name].sound.play(pausePosition, loop, _st);
				_currentSounds[name].isPlaying = true;
				return;
			}
				
			_st.volume = volume
			
			var sound:Sound = Assets.manager.getSound(name);
			var soundChannel:SoundChannel = sound.play(0, loop, _st);
			
			if (keepInCache) {
				_currentSounds[name] = new SoundObject();
				_currentSounds[name].sound = sound;
				_currentSounds[name].soundChannel = soundChannel;
				_currentSounds[name].volume = volume;
				_currentSounds[name].isPlaying = true;
				_currentSounds[name].pausePosition = 0;
			}
			
		}
		
		/**
		 * Stops a certain sound from being playing 
		 */		
		public static function stopSound(name:String):void {
			if (_currentSounds[name]) {
				_currentSounds[name].pausePosition = 0;
				_currentSounds[name].soundChannel.stop();
				_currentSounds[name].isPlaying = false;
			}
		}
		
		public static function pauseSound(name:String):void {
			if (_currentSounds[name]) {
				_currentSounds[name].pausePosition = _currentSounds[name].soundChannel.position;
				_currentSounds[name].soundChannel.stop();
				_currentSounds[name].isPlaying = false;
			}
		}
		
		public static function stopAllSounds():void {
			for (var name:String in _currentSounds) {
				stopSound(name);
			}
		}
		
		public static function pauseAllSounds():void {
			for (var name:String in _currentSounds) {
				pauseSound(name);
			}
		}
		
		public static function getSound(name:String):SoundObject {
			return _currentSounds[name] as SoundObject;
		}
		
		public static function setVolume(name:String, volume:Number):void {
			if (!_currentSounds[name]) return;
			var s:SoundTransform = new SoundTransform();
			s.volume = volume;
			_currentSounds[name].soundChannel.soundTransform = s;
		}
		
		/**
		 * Plays an effect sound.
		 * 
		 * @param name - The name of the effect cound
		 * @param volume - The volume of the effect sound
		 * 
		 */		
		public static function playSoundFX(name:String, volume:Number = 1):void {
			playSound(name, 0, volume, true);
		}
		
		public static function tweenSound(name:String, tweenDuration:Number, volume:Number = 0, shouldStopSound:Boolean = true):void {
			if (!_currentSounds[name]) return;
				
			var s:SoundTransform = new SoundTransform();
			
			Starling.juggler.tween(_currentSounds[name], tweenDuration, {
				volume: volume,
				onUpdate: function():void {
					s.volume = _currentSounds[name].volume;
					SoundChannel(_currentSounds[name].soundChannel).soundTransform = s;
				},
				onComplete: function():void {
					if (shouldStopSound) {
						stopSound(name);
					}
				}
			});
		}
	}
}
import flash.media.Sound;
import flash.media.SoundChannel;

internal class SoundObject {
	public var sound:Sound;
	public var soundChannel:SoundChannel;
	public var isPlaying:Boolean;
	public var pausePosition:Number;
	public var volume:Number;
	public function SoundObject() {
		
	}
}
