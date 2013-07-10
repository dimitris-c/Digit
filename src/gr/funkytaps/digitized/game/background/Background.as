package gr.funkytaps.digitized.game.background
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import flash.display.Bitmap;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Background extends Sprite
	{
		[Embed(source="../../../../../../assets/flash/images/sky.png")]
		public static const Sky:Class;
		
		private var sky1:Image;
		private var sky2:Image;
		
		public function Background()
		{
			super();
			var bmSky:Bitmap = new Background.Sky() as Bitmap;
			sky1 = Image.fromBitmap(bmSky);
			sky1.blendMode = BlendMode.NONE;
			addChild(sky1);

			sky2 = Image.fromBitmap(bmSky);
			sky2.blendMode = BlendMode.NONE;
			sky2.y = -800;
			addChild(sky2);
			
		}
		
		public function update():void
		{
			sky1.y += 4;
			if(sky1.y == 800)
				sky1.y = -800;
			sky2.y += 4;
			if(sky2.y == 800)
				sky2.y = -800;
		}
	}
}