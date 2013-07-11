package gr.funkytaps.digitized.views
{
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	
	import gr.funkytaps.digitized.objects.Background;
	import gr.funkytaps.digitized.objects.Blue;
	import gr.funkytaps.digitized.objects.DigitHero;
	import gr.funkytaps.digitized.objects.Gradient;
	import gr.funkytaps.digitized.objects.Splat;
	
	public class GameView extends AbstractView
	{
		private var _gradient:Gradient;
		private var _blue:Blue;
		private var _splat:Splat;
		private var _bBack:Background;
		private var _bFront:Background;
		
		private var _hero:DigitHero;
		
		const FACTOR:Number = 0.25;
		private const INTERVAL:Number = 200;
		private var accl:Accelerometer;

		
		//private var background:Background;
		private var _gradient:Gradient;
		private var _blue:Blue;
		private var _splat:Splat;
		private var _bBack:Background;
		private var _bFront:Background;
		
		private var _hero:DigitHero;
		
		const FACTOR:Number = 0.25;
		private const INTERVAL:Number = 200;
		private var accl:Accelerometer;
		
		public function GameView()
		{
			super();
		}
		
		override protected function _init():void
		{
//			_gradient = new Gradient();
//			addChild(_gradient);
//
//			_blue = new Blue();
//			addChild(_blue);
//			
//			_splat = new Splat();
//			addChild(_splat);
//			
			_bBack = new Background(false);
			addChild(_bBack);

			_bFront = new Background(true);
			addChild(_bFront);
//
//			
//			_hero = new DigitHero();
//			addChild(_hero);
			
//			_hero.x = ((stage.stageWidth >> 1) - (_hero.width >> 1)) | 0;
//			_hero.y = 300;	
			
			
//			_hero.x = ((stage.stageWidth >> 1) - (_hero.width >> 1)) | 0;
//			_hero.y = 300;	
			
//			if (Accelerometer.isSupported) {
//				accl = new Accelerometer();
//				accl.setRequestedUpdateInterval(INTERVAL);
//				accl.addEventListener(AccelerometerEvent.UPDATE,handleAccelUpdate);
//			}
		}
		
		var rollingX:Number = 0;
		var rollingY:Number = 0;
		var rollingZ:Number = 0;
		private function handleAccelUpdate(event:AccelerometerEvent) {
			
			accelRollingAvg(event);
			var newPosX:Number = _hero.x - (rollingX*20);
			var newPosY:Number = _hero.y + (rollingY*20);
			// set the text fields for tracking
			trace("X:" + rollingX.toFixed(3) + "\nY: " + rollingY.toFixed(3) + "\nZ: " + rollingZ.toFixed(3));
			//xyzText.text = "X:" + rollingX.toFixed(3) + "\nY: " + rollingY.toFixed(3) + "\nZ: " + rollingZ.toFixed(3);
			//if ((newPosX > 0) && (newPosX < stage.stageWidth)) {
				_hero.x = newPosX;
			//}
			//if ((newPosY > 0) && (newPosY < stage.stageHeight)) {
				_hero.y = newPosY;
			//}
			
//			if (recordMode == "recording") {
//				var pos:Object = new Object();
//				pos.posX = golfBall.x;
//				pos.posY = golfBall.y;
//				pos.rollingX = rollingX;
//				pos.rollingY = rollingY;
//				pos.rollingZ = rollingZ;
//				recording.push(pos);
//			}
			
			//hero.x = ((stage.stageWidth >> 1) - (hero.width >> 1)) | 0;
			//hero.y = 300;
			

		}
		
		function accelRollingAvg(event:AccelerometerEvent):void 
		{ 
			rollingX = (event.accelerationX * FACTOR) + (rollingX * (1 - FACTOR)); 
			rollingY = (event.accelerationY * FACTOR) + (rollingY * (1 - FACTOR));
			rollingZ = (event.accelerationZ * FACTOR) + (rollingZ * (1 - FACTOR)); 
		}

		


		
		override public function update():void{
			if(_hero){
				_hero.update();
			}
			if(_bFront){
				_bFront.update();
			}
			if(_bBack){
				_bBack.update();
			}
			if(_splat){
				_splat.update();
			}
			if(_blue){
				_blue.update();
			}
			if(_gradient){
				//_gradient.update();
			}
		}
	}
}