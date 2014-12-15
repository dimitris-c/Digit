package gr.funkytaps.digitized.managers
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/

	/**
	 * Helper class to easilly change the current systemIdleMode. <br />
	 * Use the public methods keepAwakeMode and normalMode to change the system's idle mode.
	 * 
	 * @see flash.desktop.SystemIdleMode
	 *  
	 * @author Dimitris Chatzieleftheriou
	 * 
	 */	
	public class SystemIdleMonitor
	{
		private static var _currentMode:String = SystemIdleMode.NORMAL;
		
		/**
		 * Returns a <code>String</code> based on @see flash.desktop.SystemIdleMode.
		 */		
		public static function get currentMode():String { return _currentMode; }

		/**
		 * Puts the system's idle mode to not to sleep mode after a while. 
		 * Useful for game's that rely on the accelerometer for their gameplay.
		 */		
		public static function keepAwakeMode():void {
			_currentMode = SystemIdleMode.KEEP_AWAKE;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		/**
		 * Puts the idle mode back to normal.
		 */	
		public static function normalMode():void {
			_currentMode = SystemIdleMode.NORMAL;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
	}
}