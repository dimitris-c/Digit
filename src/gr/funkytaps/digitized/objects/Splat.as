package gr.funkytaps.digitized.objects
{
	import flash.display.Bitmap;
	
	import starling.display.Image;

	public class Splat extends AbstractObject
	{
		[Embed(source="../../../../../assets/flash/images/splat1.png")]
		public static const Splat1:Class;
		
		[Embed(source="../../../../../assets/flash/images/splat2.png")]
		public static const Splat2:Class;
		
		private var _splat1:Image;
		private var _splat2:Image;
		
		private var _speed:Number;
		
		public function Splat()
		{
			super();
		}
		
		override protected function _init():void{
			_speed = 5;
			
			var bmSky1:Bitmap;
			var bmSky2:Bitmap;
			bmSky1 = new Splat.Splat1() as Bitmap;
			bmSky2 = new Splat.Splat2() as Bitmap;

			_splat1 = Image.fromBitmap(bmSky1);
			//_sky1.blendMode = BlendMode.NONE;
			addChild(_splat1);
			
			_splat2 = Image.fromBitmap(bmSky2);
			//_sky2.blendMode = BlendMode.NONE;
			_splat2.y = -800;
			addChild(_splat2);
			
		}
		
		public function update():void
		{
			if(_splat1){			
				_splat1.y += _speed;
				if(_splat1.y == 800){
					_splat1.y = -800;
				}
			}
			if(_splat2){
				_splat2.y += _speed;
				if(_splat2.y == 800){
					_splat2.y = -800;
				}
			}
		}
	}
}