package gr.funkytaps.digitized.game.objects
{
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.views.GameView;
	
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
			_baseSpeed = _gameView.gameSpeed;
			
		}
	}
}