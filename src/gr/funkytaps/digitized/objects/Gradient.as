package gr.funkytaps.digitized.objects
{
	import flash.display.Bitmap;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	
	public class Gradient extends AbstractObject
	{
		[Embed(source="../../../../../assets/flash/images/gradient.png")]
		public static const GradientAsset:Class;
		
		private var _gradient:Image;
		
		public function Gradient()
		{
			super();
		}
		
		override protected function _init():void{
			var grad:Bitmap = new Gradient.GradientAsset() as Bitmap;
			_gradient = Image.fromBitmap(grad);
			//_gradient.blendMode = BlendMode.NONE;
			addChild(_gradient);
		}
		
	}
}