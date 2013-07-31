package gr.funkytaps.digitized.views
{
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.game.GameWorld;
	import gr.funkytaps.digitized.game.objects.Background;
	import gr.funkytaps.digitized.game.objects.Dashboard;
	import gr.funkytaps.digitized.game.objects.DigitHero;
	import gr.funkytaps.digitized.managers.CollisionManager;
	import gr.funkytaps.digitized.managers.SoundManager;
	import gr.funkytaps.digitized.managers.StarsManager;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class GameView extends AbstractView
	{
		private var _gameWorld:GameWorld;
		
		private var _gameJuggler:Juggler;
		
		private var _gameContainer:Sprite;
		public function get gameContainer():Sprite { return _gameContainer };
		
		private var _background:Background;
		
		private var _takeOffLand:Image;
		
		private var _hero:DigitHero;
		public function get hero():DigitHero { return _hero; }
		
		private var _startScrollingBackground:Boolean = false;
		
		private var _gameSpeed:Number;
		public function get gameSpeed():Number { return _gameSpeed; }
		
		private static const MAX_GAME_SPEED:Number = 5; 
		
		private var _starsManager:StarsManager;
		public function get starsManager():StarsManager { return _starsManager; }

		private var _collisionManager:CollisionManager;
		public function get collisionManager():CollisionManager { return _collisionManager; }
		
		private var _gradient:Quad;
		
		private var _dashboard:Dashboard;
		public function get dashboard():Dashboard { return _dashboard; }
		
		private var _accelerometer:Accelerometer;
		private var _noAccelerometer:Boolean = false;
		
		private var _rollingX:Number = 0;

		private var _xSpeed:Number;

		private var _touch:Touch;
		private var _touchX:Number;
		private var _touchY:Number;
		
		public function GameView(gameWorld:GameWorld)
		{
			super();
			
			_gameWorld = gameWorld;
		}
		
		public function get gameJuggler():Juggler { return _gameJuggler; }

		override protected function _init():void
		{

			_gameJuggler = new Juggler();
			
//			SoundManager.stopSound('intro');
			SoundManager.playSound('game-theme', int.MAX_VALUE, 0.2);
			
			_gameSpeed = 3;
			
			_gradient = new Quad(Settings.WIDTH, 260);
			_gradient.setVertexColor(0, 0x000000);
			_gradient.setVertexAlpha(1, 0.6);
			_gradient.setVertexColor(1, 0x000000);
			_gradient.setVertexAlpha(1, 0.4);
			_gradient.setVertexColor(2, 0x000000);
			_gradient.setVertexAlpha(2, 0);
			_gradient.setVertexColor(3, 0x000000);
			_gradient.setVertexAlpha(3, 0);
			addChild(_gradient);

			_gameContainer = new Sprite();
			addChild(_gameContainer);
			
			_dashboard = new Dashboard();
			addChild(_dashboard);
			_dashboard.x = _dashboard.y = 7;
			
			_background = new Background();
			_background.maxSpeed = _gameSpeed;
			_gameContainer.addChild(_background);
			
			_takeOffLand = new Image( Assets.manager.getTexture('land') );
			_takeOffLand.pivotX = _takeOffLand.width >> 1;
			_gameContainer.addChild(_takeOffLand);
			
			_takeOffLand.x = Settings.HALF_WIDTH;
			_takeOffLand.y = Settings.HEIGHT - _takeOffLand.height;
			
			_hero = new DigitHero( _gameJuggler );
			_gameContainer.addChild(_hero);
			
			_hero.x = Settings.HALF_WIDTH;
			_hero.y = Settings.HEIGHT - _takeOffLand.height - (_hero.heroHeight >> 1);
			
			_starsManager = new StarsManager(this);
			
			// Start accelerometer if supported
			if (Accelerometer.isSupported) {
				_accelerometer = new Accelerometer();
				_accelerometer.setRequestedUpdateInterval(100);
			}
			else {
				_noAccelerometer = true;
				stage.addEventListener(TouchEvent.TOUCH, _onTouch);
			}
			
			// Take off the Hero
			_takeOff();
		}
		
		private function _onTouch(event:TouchEvent):void
		{
			_touch = event.getTouch(stage);
			if (!_touch) return;
			_rollingX = _touch.globalX;
		}
		
		private function _onAccelerometerUpdate(event:AccelerometerEvent):void {
			
			_rollingX = _rollingX * _hero.deceleration - event.accelerationX * _hero.sensitivity;
			_rollingX = (_rollingX > -_hero.maximumVelocity) ? ( _rollingX < _hero.maximumVelocity ) ? _rollingX : _hero.maximumVelocity : -_hero.maximumVelocity;
			
			if (_rollingX < -0.05) {  // tilting the device to the right
				
			} else if (_rollingX > 0.05) {  // tilting the device to the left
				
			}
			else {
				
			}
			
		}
		
		/**
		 * This is the start of the game. It makes the character take off...
		 */		
		private function _takeOff():void {
			
			var takeOff:Tween = new Tween(_hero, 1.3, Transitions.EASE_IN_BACK);
			takeOff.delay = 0.42;
			takeOff.animate('y', _hero.y - 70);
			
			_gameJuggler.add(takeOff);
			
			var moveLand:Tween = new Tween(_takeOffLand, 1.3, Transitions.EASE_IN_OUT);
			moveLand.delay = 0.423;
			moveLand.animate('y', _takeOffLand.y + 45);
			moveLand.onComplete = _onMoveLandComplete;
			moveLand.onCompleteArgs = [moveLand];
			
			if (_accelerometer) _accelerometer.addEventListener(AccelerometerEvent.UPDATE, _onAccelerometerUpdate);
			
			_gameJuggler.delayCall(_background.startScrolling, 0.8);
			
			_gameJuggler.add(moveLand);
			
		}

		override public function tweenIn():void {
			
		}

		override public function tweenOut(onComplete:Function=null, onCompleteParams:Array=null):void {
			
		}
		
		override public function update(passedTime:Number = 0):void {
			
			if (_gameJuggler) _gameJuggler.advanceTime( passedTime );
			
			if (_hero) _hero.update( _rollingX, _noAccelerometer );
			
			if (_background) if (_background.isScrolling) _background.update( passedTime );
			
			if (_starsManager) _starsManager.update( passedTime );
			
		}
		
		protected function _onMoveLandComplete(tween:Tween):void
		{
			_takeOffLand.visible = false;
			_gameJuggler.remove(tween);
			
			_hero.takeOff();
		}
		
	}
}