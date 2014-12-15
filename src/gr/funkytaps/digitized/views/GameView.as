package gr.funkytaps.digitized.views
{
	
	import flash.events.AccelerometerEvent;
	import flash.net.URLVariables;
	import flash.sensors.Accelerometer;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.events.MenuEvent;
	import gr.funkytaps.digitized.game.GameWorld;
	import gr.funkytaps.digitized.game.items.IItem;
	import gr.funkytaps.digitized.game.objects.Background;
	import gr.funkytaps.digitized.game.objects.Dashboard;
	import gr.funkytaps.digitized.game.objects.DigitHero;
	import gr.funkytaps.digitized.helpers.GameDataHelper;
	import gr.funkytaps.digitized.helpers.POSTRequestHelper;
	import gr.funkytaps.digitized.managers.ChunkManager;
	import gr.funkytaps.digitized.managers.SoundManager;
	import gr.funkytaps.digitized.utils.DisplayUtils;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class GameView extends AbstractView
	{
		private var _gameWorld:GameWorld;
		
		private var _gameJuggler:Juggler;
		
		private var _gameContainer:Sprite;

		public function get gameContainer():Sprite { return _gameContainer };
		
		public var pauseEnergyDescrease:Boolean;
		
		private var _currentEnergyRatio:Number = 1;
		
		public function get currentEnergyRatio():Number { return _currentEnergyRatio; }

		public function set currentEnergyRatio(value:Number):void { _currentEnergyRatio = value; }

		
		private var _background:Background;
		
		private var _takeOffLand:Image;
		
		private var _hero:DigitHero;
		public function get hero():DigitHero { return _hero; }
		
		private var _startScrollingBackground:Boolean = false;
		
		private static const MAX_GAME_SPEED:Number = 15; 
		
		private var _speedPowerGrowth:Number = 0.8;
		
		private var _speedDecreaseValue:Number = 0.32;
		
		private var _gameSpeed:Number;
		public function get gameSpeed():Number { return _gameSpeed; }
		
		private var _chunkManager:ChunkManager;
		public function get starsManager():ChunkManager { return _chunkManager; }

		private var _gradient:Image;
		
		private var _dashboard:Dashboard;
		public function get dashboard():Dashboard { return _dashboard; }
		
		private var _accelerometer:Accelerometer;
		private var _noAccelerometer:Boolean = false;
		
		private var _rollingX:Number = 0;

		private var _xSpeed:Number;
		
		private var _gameSessionTime:Number = 0;

		private var _touch:Touch;
		private var _touchX:Number;
		private var _touchY:Number;
		
		private var _gameEnded:Boolean;
		
		//POST
		private var _score:String;
		private var postHelper:POSTRequestHelper;
		
		public function GameView(gameWorld:GameWorld)
		{
			super();
			
			_gameWorld = gameWorld;
		}
		
		public function get gameJuggler():Juggler { return _gameJuggler; }

		override protected function _init():void
		{

			_gameJuggler = new Juggler();
			
			SoundManager.stopSound('intro');
			SoundManager.playSound('game-theme', int.MAX_VALUE, 0.2);
			
			_gameSpeed = 7;
			
			_gradient = new Image(Assets.manager.getTexture('gradient'));
			addChild(_gradient);

			_gameContainer = new Sprite();
			_gameContainer.touchable = false;
			_gameContainer.alpha = 0.99999;
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
			
			_hero = new DigitHero( _gameJuggler, this );
			addChild(_hero);
			
			_hero.x = Settings.HALF_WIDTH;
			_hero.y = Settings.HEIGHT - _takeOffLand.height - 20;
			
			_chunkManager = new ChunkManager(this, _onBombCollision);
			
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
			
//			if (_rollingX < -0.05) {  // tilting the device to the right
//				
//			} else if (_rollingX > 0.05) {  // tilting the device to the left
//				
//			}
//			else {
//				
//			}
			
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
		
		private function _onBombCollision(bomb:IItem):void
		{
			_gameEnded = true;
			SoundManager.tweenSound('game-theme', 1, 0);
			
		}
		
		override public function update(passedTime:Number = 0):void {
			
			if (_gameEnded) {
				// decrease the speed of the game and the background
				if (_background.baseSpeed <= 0) _background.setBaseSpeed(0) else _background.setBaseSpeed(_background.baseSpeed - _speedDecreaseValue);
				if (_gameSpeed <= 0) _gameSpeed = 0 else _gameSpeed = _gameSpeed - _speedDecreaseValue;
				
				if (_gameSpeed == 0) {
					if (_accelerometer) _accelerometer.removeEventListener(AccelerometerEvent.UPDATE, _onAccelerometerUpdate);
					else stage.removeEventListener(TouchEvent.TOUCH, _onTouch);
					_gameWorld.gamePaused = true;
					_gameWorld.gameEnded = true;
					Starling.juggler.delayCall(_gameWorld.showMenuOnGameEnd, 0.32);
//					_gameWorld.showMenuOnGameEnd();
				}
			}
			
			if (!_gameEnded && _currentEnergyRatio > 0) {
				if (_gameSpeed < MAX_GAME_SPEED) { 
					_gameSpeed += 0.1 * passedTime * _speedPowerGrowth * Math.pow(_gameSpeed, (_speedPowerGrowth - 1.0) / _speedPowerGrowth);
					_background.setBaseSpeed(_gameSpeed);
					
					if (!pauseEnergyDescrease) {
						if (_currentEnergyRatio > 0)
							_currentEnergyRatio -= 0.12 * (passedTime * 0.2);
						
						if (_currentEnergyRatio <= 0) {
							if (_accelerometer) _accelerometer.removeEventListener(AccelerometerEvent.UPDATE, _onAccelerometerUpdate);
							else stage.removeEventListener(TouchEvent.TOUCH, _onTouch);
							SoundManager.playSoundFX('power-down', 0.5);
							_gameEnded = true;
							_speedDecreaseValue = 0.1;
							_hero.lostEnergy();
						}
					}
					
				}
			}
			
			if (_gameJuggler) _gameJuggler.advanceTime( passedTime );
			
			if (_hero) _hero.update( _rollingX, _noAccelerometer );
			
			if (_dashboard) _dashboard.updateEnergyBar( _currentEnergyRatio );
			
			if (_background) if (_background.isScrolling) _background.update( passedTime );
			
			if (_chunkManager) _chunkManager.update( passedTime );
			
		}
		
		protected function _onMoveLandComplete(tween:Tween):void
		{
			_takeOffLand.visible = false;
			_gameJuggler.remove(tween);
			
			_hero.takeOff();
		}
		
		/**
		 * On Game over 
		 */		
		private function _onGameOver():void{
			trace("onGameOver::::::::");
			
			_score = _dashboard.currentScore.toString();
			
			//TODO save score if 
			var user:Object = GameDataHelper.getUser();
			trace("-----------------------");
			trace("user is type: ", user);
			trace("user_uid:", user["user_uid"]);
			trace("name:", user["name"]);
			trace("email:", user["email"]);
			trace("high score:", user["highScore"]);
			trace("-----------------------");
			
			if(user && user["user_uid"]){
				var savedScore:int = int(user["highScore"]);
				if(savedScore <= int(_score)){
					//HIGH SCORE - save score	
					_initPOST();
				}
				else{
					//NOT A HIGH SCORE - do nothing 
					_notifyParent();
				}
			}
			else{
				//do nothing - will save the score if the user registers in leaderboard
				_notifyParent(_score);
			}
		}
		
		private function _initPOST():void{
			postHelper = new POSTRequestHelper();
			postHelper.addEventListener(POSTRequestHelper.POST_INITIALIZED, _onInit);
			
			postHelper.init(POSTRequestHelper.ACTION_SAVE_HIGH_SCORE);
		}
		
		private function _onInit(e:Event):void {
			postHelper.removeEventListener(POSTRequestHelper.POST_INITIALIZED, _onInit);
			_saveHighScore();
		}
		
		private function _saveHighScore():void{
			trace("Saving high score:", _score);
			//TODO
			//The user has already registered and the high score is sent OLNy if it's greater than the one in db
			var user:Object = GameDataHelper.getUser();
			var uid:String = user["user_uid"];
			var params:URLVariables = new URLVariables();
			params.user_uid = uid;
			params.high_score = _score;
			
			postHelper.saveHighScore(_saveHighScoreResponseHandler, params);
		}
		
		private function _saveHighScoreResponseHandler(data:Object):void{
			if(data && data["success"]){
				if(data["success"] == "1") {
					//ok high score saved in db now save it locally
					var user:Object = data["user"];
					GameDataHelper.saveHighScore(user["high_score"]);
					_notifyParent();
				}
				else{
					//error
				}
			}
			else{
				//error
			}
		}
		
		private function _notifyParent(highScore:String = null):void{
			var ev:MenuEvent = new MenuEvent(MenuEvent.MENU_CLICKED, true);
			ev.displayOnUserDemand = false;
			ev.highScore = highScore;
			this.dispatchEvent(ev);
			
		}
		
		override public function destroy():void {
			DisplayUtils.removeAllChildren(this, true, true, true);
			
			_chunkManager.destroy();
			_chunkManager = null;
			
			if (_accelerometer) _accelerometer.removeEventListener(AccelerometerEvent.UPDATE, _onAccelerometerUpdate);
			if (_noAccelerometer) stage.removeEventListener(TouchEvent.TOUCH, _onTouch);
			_dashboard = null;
			_gameContainer = null;
			_accelerometer = null;
			
		}
		
	}
}