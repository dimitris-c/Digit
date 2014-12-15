package gr.funkytaps.digitized.core
{
	import flash.display.Bitmap;
	
	import starling.utils.AssetManager;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class Assets
	{
		/**
		 * Static AssetsMananger reference to handle all the texture/atlases etc that need for the game 
		 */		
		public static var manager:AssetManager;
		
		/**
		 * Images that we need to be embeded
		 */		
		
		[Embed(source="../../../../../assets/flash/Default-568h@2x.png")]
		public static const Default568h:Class;
		
		[Embed(source="../../../../../assets/flash/Default@2x.png")]
		public static const DefaultHD:Class;
		
		[Embed(source="../../../../../assets/flash/Default.png")]
		public static const Default:Class;
		
		[Embed(source="../../../../../assets/flash/DefaultGeneric-bg.jpg")]
		public static const DefaultGenericBG:Class;
		
		[Embed(source="../../../../../assets/flash/DefaultGeneric-glow.png")]
		public static const DefaultGenericGlow:Class;
		
		[Embed(source="../../../../../assets/flash/digitizedlogo.png")]
		public static const DigitizedLogo:Class;
		
		/**
		 * Returns a bitmap for the give name. 
		 */		
		public static function getBitmap(name:String):Bitmap {
			return new Assets[name]() as Bitmap;
		}
		
		public static function getClass(name:String):Class {
			return Assets[name] as Class;
		}
		
		
	}
}