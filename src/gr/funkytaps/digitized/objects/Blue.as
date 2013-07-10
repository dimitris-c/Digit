package gr.funkytaps.digitized.objects
{
	import flash.display.Bitmap;
	
	import starling.display.Image;
	
	public class Blue extends AbstractObject
	{
		[Embed(source="../../../../../assets/flash/images/blue1.png")]
		public static const Blue1:Class;
		
		[Embed(source="../../../../../assets/flash/images/blue2.png")]
		public static const Blue2:Class;
		
		private var _blue1:Image;
		private var _blue2:Image;
		
		private var _speed:Number;
		
		public function Blue()
		{
			super();
		}
		
		override protected function _init():void{
			_speed = 7;
			
			var bmSky1:Bitmap;
			var bmSky2:Bitmap;
			bmSky1 = new Blue.Blue1() as Bitmap;
			bmSky2 = new Blue.Blue2() as Bitmap;
			
			_blue1 = Image.fromBitmap(bmSky1);
			//_sky1.blendMode = BlendMode.NONE;
			addChild(_blue1);
			
			_blue2 = Image.fromBitmap(bmSky2);
			//_sky2.blendMode = BlendMode.NONE;
			_blue2.y = -800;
			addChild(_blue2);
			
		}
		
		public function update():void
		{
			if(_blue1){			
				_blue1.y += _speed;
				if(_blue1.y == 800){
					_blue1.y = -800;
				}
			}
			if(_blue2){
				_blue2.y += _speed;
				if(_blue2.y == 800){
					_blue2.y = -800;
				}
			}
		}
	}
}

