package gr.funkytaps.digitized.assets
{
	import starling.textures.Texture;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class Assets
	{
		[Embed(source="assets/flash/images/sky.png")]
		private static var sky:Class;
		
		public static var skyTexture:Texture;
		
		public static function init():void
		{
			skyTexture = Texture.fromBitmap(new sky());
		}
		
	}
}