package gr.funkytaps.digitized.game.objects {
	
	import flash.geom.Rectangle;
	
	import de.polygonal.core.ObjectPool;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.game.objects.AbstractObject;
	import gr.funkytaps.digitized.game.objects.BackgroundPlanet;
	import gr.funkytaps.digitized.utils.Mathematics;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.ParallaxLayer;
	import starling.utils.deg2rad;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	
	
	public class Background extends AbstractObject
	{
		
		private var _starsFrontLayer:ParallaxLayer;
		
		private var _starsBackLayer:ParallaxLayer;
		
		private var _glowLeftPart:Image;
		
		private var _glowRightPart:Image;
		
		private var _maxSpeed:Number = 2;
		
		public function get maxSpeed():Number { return _maxSpeed; }
		public function set maxSpeed(value:Number):void { _maxSpeed = value; }
		
		private var _baseSpeed:Number = 0;
		
		private var _isScrolling:Boolean = false;

		// Planets
		private var _planetsPool:ObjectPool;
		private var _currentPlanet:BackgroundPlanet;
		private var _lastRandomPlanetIndex:Number = -1;
		private var _nextPlanetCreation:Number = 0;
		private var _planetCreationInterval:Number = 15;
		private var _planetButtomLimit:int;
		
		/**
		 * Returns the baseSpeed value for all the elements in the background. <br />
		 * Note to update the baseSpeed value use setBaseSpeed method. 
		 */		
		public function get baseSpeed():Number { return _baseSpeed; }

		public function get isScrolling():Boolean { return _isScrolling; }
		public function set isScrolling(value:Boolean):void { _isScrolling = value; }
		
		public function Background()
		{
			super();
		}
		

		override protected function _init():void {
			
			touchable = false;
			
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
			
			_starsFrontLayer = new ParallaxLayer(Assets.manager.getTexture('stars-front'), 2, 0.5, true, false, false);
			_starsFrontLayer.baseSpeed = _baseSpeed;
			_starsFrontLayer.speedFactor = 0.842;
			_starsFrontLayer.alpha = 0.6;
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
			_planetsPool = new ObjectPool(false);
			_planetsPool.allocate(3, BackgroundPlanet);
			
			_addPlanetOnStage();
		}
		
		private function _addPlanetOnStage():void{
			
			var random:Number = Mathematics.getRandomInt(1, 6);
			
			_currentPlanet = _planetsPool.object as BackgroundPlanet;
			var speedFactor:Number = Math.random(); // get a random float number.
			_currentPlanet.createPlanet( 'planet' + random, (speedFactor < 0.18) ? 0.18 : (speedFactor > 0.3) ? 0.3 : speedFactor );
			
			_currentPlanet.y = - (_currentPlanet.planetHeight + _currentPlanet.pivotY);
			_currentPlanet.x = Mathematics.getRandomNumber(-(_currentPlanet.planetWidth >> 1), Settings.WIDTH - 30);
			addChild(_currentPlanet);
			
			_planetButtomLimit = Settings.HEIGHT + (_currentPlanet.planetHeight >> 1);
		}
		
		private function _createStardust():void {
			
		}
		
		/**
		 * Sets the baseSpeed for all the background layers. 
		 */		
		public function setBaseSpeed(speed:Number):void {
			_baseSpeed = speed;
			if (_starsBackLayer) _starsBackLayer.baseSpeed = _baseSpeed;
			if (_starsFrontLayer) _starsFrontLayer.baseSpeed = _baseSpeed;
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
			
			if (!_currentPlanet) { // start creation of the planet once there is none.
				if (_nextPlanetCreation >= _planetCreationInterval) {
					_addPlanetOnStage();
					_nextPlanetCreation = 0;
				}
				_nextPlanetCreation += passedTime;
			}
			
			if (!_currentPlanet) return; // stop here if there is no planet.
			
			_currentPlanet.y += _baseSpeed * _currentPlanet.speedFactor;
//			_currentPlanet.rotation = deg2rad(_currentPlanet.y * _currentPlanet.speedFactor * _currentPlanet.speedFactor);
			
			if (_currentPlanet.y >= _planetButtomLimit) {
				_nextPlanetCreation = 0;
				_currentPlanet.destroy();
				_currentPlanet.removeFromParent(true);
				_planetsPool.object = _currentPlanet;
				_currentPlanet = null;
			}
		}
	}
}