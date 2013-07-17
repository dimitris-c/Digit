package starling.extensions
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Gauge extends Sprite
	{
		protected var mImage:Image;
		protected var mRatio:Number;
		protected var mPoint:Point = new Point();
		
		public function Gauge(texture:Texture)
		{
			mRatio = 1.0;
			mImage = new Image(texture);
			addChild(mImage);
		}
		
		protected function update():void
		{
			mImage.scaleX = mRatio;
			mPoint.x = mRatio;
			mPoint.y = 0.0;
			mImage.setTexCoords(1, mPoint);
			mPoint.x = mRatio;
			mPoint.y = 1.0;
			mImage.setTexCoords(3, mPoint);
		}
		
		public function get ratio():Number { return mRatio; }
		public function set ratio(value:Number):void 
		{
			mRatio = Math.max(0.0, Math.min(1.0, value));
			update();
		}
	}
}