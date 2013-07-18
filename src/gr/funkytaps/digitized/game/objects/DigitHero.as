package gr.funkytaps.digitized.game.objects
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	
	public class DigitHero extends AbstractObject
	{
		
		private var _hero:Image;
		
		private var _heroWidth:Number;
		private var _heroHeight:Number;
		private var _limitPadding:Number = 25;
		private var _heroLeftLimit:Number;
		private var _heroRightLimit:Number;
		
		private var _heroIsFlying:Boolean = false;
		
		private var _leftRocketParticle:ParticleSystem;
		private var _rightRocketParticle:ParticleSystem;
		
		private var _gameJuggler:Juggler;
		
		public function DigitHero(gameJuggler:Juggler = null)
		{
			super();
			_gameJuggler = gameJuggler;
		}
		
		public function get heroHeight():Number { return _heroHeight; }

		public function get heroWidth():Number { return _heroWidth; }

		override protected function _init():void
		{
			
			touchable = false; // for performance.
			
			_createRocketFlames();
			
			_hero = new Image(Assets.manager.getTexture('hero-static'));
			addChild(_hero);
			
			pivotX = width >> 1;
			pivotY = height >> 1;
			
			_heroWidth = width;
			_heroHeight = height;
			_heroLeftLimit = pivotX - _limitPadding;
			_heroRightLimit = Settings.WIDTH - pivotX + _limitPadding;
			
		}
		
		private function _createRocketFlames():void {
			
			_leftRocketParticle = new PDParticleSystem(Assets.manager.getXml('rocketflame'), Assets.manager.getTexture('flameparticle'));
			_leftRocketParticle.maxCapacity = 10;
			_leftRocketParticle.emitterX = 22;
			_leftRocketParticle.emitterY = 178;
			_leftRocketParticle.scaleX = _leftRocketParticle.scaleY = 0.65;
			PDParticleSystem(_leftRocketParticle).maxNumParticles = 1;
			PDParticleSystem(_leftRocketParticle).speed = 1;
			_leftRocketParticle.start();
			
			addChild(_leftRocketParticle);
			_gameJuggler.add(_leftRocketParticle);
			
			_rightRocketParticle = new PDParticleSystem(Assets.manager.getXml('rocketflame'), Assets.manager.getTexture('flameparticle'));
			_rightRocketParticle.maxCapacity = 10;
			_rightRocketParticle.emitterX = 189;
			_rightRocketParticle.emitterY = 178;
			_rightRocketParticle.scaleX = _rightRocketParticle.scaleY = 0.65;
			PDParticleSystem(_rightRocketParticle).maxNumParticles = 1;
			PDParticleSystem(_rightRocketParticle).speed = 1;
			_rightRocketParticle.start();
			
			addChild(_rightRocketParticle);
			_gameJuggler.add(_rightRocketParticle);

		}
		
		public function takeOff():void {
			_heroIsFlying = true;
			
		}
		
		public function update(rollingX:Number = 0):void
		{
			if (!_heroIsFlying) {
				if (_leftRocketParticle) {
					if (PDParticleSystem(_leftRocketParticle).maxNumParticles < 80) PDParticleSystem(_leftRocketParticle).maxNumParticles += 3;
					if (PDParticleSystem(_leftRocketParticle).speed < 150) PDParticleSystem(_leftRocketParticle).speed += 3;
					if (PDParticleSystem(_rightRocketParticle).maxNumParticles < 80) PDParticleSystem(_rightRocketParticle).maxNumParticles += 3;
					if (PDParticleSystem(_rightRocketParticle).speed < 150) PDParticleSystem(_rightRocketParticle).speed += 3;
				}
			}
			
			this.x += (this.x - (this.x + rollingX * 20)) * 0.6;
			
			if (this.x < _heroLeftLimit) this.x = _heroLeftLimit;
			if (this.x > _heroRightLimit) this.x = _heroRightLimit;
		}
		
	}
}