package gr.funkytaps.digitized.game.objects
{
	import flash.globalization.LastOperationStatus;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
<<<<<<< Updated upstream
	import gr.funkytaps.digitized.utils.NumberUtil;
=======
	import gr.funkytaps.digitized.views.GameView;
>>>>>>> Stashed changes
	
	import starling.display.Image;
	import starling.extensions.ParallaxLayer;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	
	
	public class Background extends AbstractObject
	{
		
		private var _gameView:GameView;
		
		private var _starsFrontLayer:ParallaxLayer;
		
		private var _starsBackLayer:ParallaxLayer;
		
		private var _glowLeftPart:Image;
		
		private var _glowRightPart:Image;
		
		private var _maxSpeed:Number = 3;
		
		public function get maxSpeed():Number { return _maxSpeed; }
		public function set maxSpeed(value:Number):void { _maxSpeed = value; }
		
		private var _baseSpeed:Number = 0;
		
		private var _isScrolling:Boolean = false;

		//planets
		private var _planetsPool:Array;
		private var _curPlanet:Image;
		private var _lastRandomPlanetIndex:Number = -1;
		
		/**
		 * Returns the baseSpeed value for all the elements in the background. <br />
		 * Note to update the baseSpeed value use setBaseSpeed method. 
		 */		
		public function get baseSpeed():Number { return _baseSpeed; }

		public function get isScrolling():Boolean { return _isScrolling; }
		public function set isScrolling(value:Boolean):void { _isScrolling = value; }
		
		public function Background(gameView:GameView)
		{
			super();
			
			_gameView = gameView;
			
		}
		

		override protected function _init():void {
			
			touchable = false;
			
			_baseSpeed = _gameView.gameSpeed;
			
			_glowLeftPart = new Image(Assets.manager.getTexture('glow'));
			addChild(_glowLeftPart);
			
			_glowLeftPart.y = 20;
			
			_glowRightPart = new Image(Assets.manager.getTexture('glow'));
			addChild(_glowRightPart);
			_glowRightPart.scaleX = -1;
			_glowRightPart.scaleY = -1;
			
			_glowRightPart.x = Settings.WIDTH;
			_glowRightPart.y = _glowRightPart.height + 250;
			
			_starsBackLayer = new ParallaxLayer(Assets.manager.getTexture('stars-back'), 1, 0.1, true, false, false);
			_starsBackLayer.baseSpeed = _baseSpeed;
			_starsBackLayer.speedFactor = 0.2;
			addChild(_starsBackLayer);
			
			_starsFrontLayer = new ParallaxLayer(Assets.manager.getTexture('stars-front'), 2, 0.3, true, false, false);
			_starsFrontLayer.baseSpeed = _baseSpeed;
			_starsFrontLayer.speedFactor = 0.6;
			addChild(_starsFrontLayer);
			
			// TODO: Implement the scrolling of other elements that should be a part of the background.
			// These obstacles should not be ParallaxLayer, instead we should use an object pool that
			// will have a method to randomly select an object and place it on the display list of this class.
			// This selection should be done in a random time, and not very often 
			_initPlanets();
		}
		
		/**
		 *Planets 
		 * 
		 */		
		private function _initPlanets():void{
			//create all planets
			_planetsPool = new Array();
			var planet:Image;
			for(var i:int = 1; i<=6; i++){				
				planet = new Image(Assets.manager.getTexture('planet' + i.toString()));
				_planetsPool.push(planet);
			}
			planet = null;
			_addPlanetOnStage();			
		}
		
		private function _addPlanetOnStage():void{
			//TODO check if we need to display more than 1 planet at a time. 
			//if yes then implement a better adding-to-stage/removeing-from-stage mechanism
			
			//destroy previous planet
			if(_curPlanet){
				removeChild(_curPlanet);
				_curPlanet = null;
			}

			//get random index but make sure than it's not the same as the last 1
			var  random:Number;
			do{
				random = NumberUtil.randomNumber(0, 5);
			}
			while(random == _lastRandomPlanetIndex);			
			_lastRandomPlanetIndex = random;
			
			_curPlanet = _planetsPool[random];
			
			//random scaling
			var scaleFactor:Number = NumberUtil.randomNumber(0.7, 1.3);
			//random positioning
			var xPos:Number = NumberUtil.randomNumber(_curPlanet.width*0.5*scaleFactor, this.stage.stageWidth - (_curPlanet.width*0.5*scaleFactor));
			
			_curPlanet.scaleX = _curPlanet.scaleY = scaleFactor;
			_curPlanet.y = -_curPlanet.height*scaleFactor;
			_curPlanet.x = xPos;
			addChild(_curPlanet);
			
		}
		
		private function _removePlanetFromStage():void{
			
		}
		
		
		private function _createPlanet():void {
			
		}
		
		private function _createStardust():void {
			
		}
		
		/**
		 * Sets the baseSpeed for all the background layers. 
		 */		
		public function setBaseSpeed(speed:Number):void {
			_baseSpeed = speed;
			if (_starsBackLayer) _starsBackLayer.baseSpeed = _gameView.gameSpeed;
			if (_starsFrontLayer) _starsFrontLayer.baseSpeed = _gameView.gameSpeed;
		}

		/**
		 * Starts the scrolling of the background with the speed being zero 
		 */		
		public function startScrolling():void {
			
			_isScrolling = true;
			
		}
		
		public function update(passedTime:Number = 0):void
		{
			if (_baseSpeed <= _maxSpeed) _baseSpeed += 0.08;
			_starsBackLayer.advanceStep(_baseSpeed);
			_starsFrontLayer.advanceStep(_baseSpeed);
<<<<<<< Updated upstream
			
			_curPlanet.y += _baseSpeed;
			if(_curPlanet.y >= this.stage.stageHeight){
				_addPlanetOnStage();
			}
=======
			_baseSpeed = _gameView.gameSpeed;
			
>>>>>>> Stashed changes
		}
	}
}