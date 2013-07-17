package gr.funkytaps.digitized.objects
{
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	
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
		
		private var _starsFrontLayer:ParallaxLayer;
		
		private var _starsBackLayer:ParallaxLayer;
		
		private var _glowLeftPart:Image;
		
		private var _glowRightPart:Image;
		
		private var _speed:Number;
		
		private var _isScrolling:Boolean = false;
		
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
			_glowRightPart.y = _glowRightPart.height + 250
			
			_starsBackLayer = new ParallaxLayer(Assets.manager.getTexture('stars-back'), 1, 0.1, true, false, false);
			_starsBackLayer.baseSpeed = 1;
			_starsBackLayer.speedFactor = 0.2;
			addChild(_starsBackLayer);
			
			_starsFrontLayer = new ParallaxLayer(Assets.manager.getTexture('stars-front'), 2, 0.5, true, false, false);
			_starsFrontLayer.baseSpeed = 2;
			_starsFrontLayer.speedFactor = 0.8;
			addChild(_starsFrontLayer);
			
		}
		
		public function update(passedTime:Number = 0):void
		{
			_starsBackLayer.advanceStep(_starsBackLayer.baseSpeed);
			_starsFrontLayer.advanceStep(_starsFrontLayer.baseSpeed);
		}
	}
}