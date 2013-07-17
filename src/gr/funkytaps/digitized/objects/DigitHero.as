package gr.funkytaps.digitized.objects
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
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
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
		
		private var mParticleSystems:Vector.<ParticleSystem>;
		private var mParticleSystem:ParticleSystem;
		
		public function DigitHero()
		{
			super();
		}
		
		public function get heroHeight():Number { return _heroHeight; }

		public function get heroWidth():Number { return _heroWidth; }

		override protected function _init():void
		{
			
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
			
			mParticleSystems = new <ParticleSystem>[
				new PDParticleSystem(Assets.manager.getXml('rocketflame'), Assets.manager.getTexture('flameparticle')),
				new PDParticleSystem(Assets.manager.getXml('rocketflame'), Assets.manager.getTexture('flameparticle'))
			];
			
			mParticleSystem = mParticleSystems[0];
			mParticleSystem.maxCapacity = 80;
			mParticleSystem.emitterX = 22;
			mParticleSystem.emitterY = 178;
			mParticleSystem.scaleX = mParticleSystem.scaleY = 0.65;
			mParticleSystem.start();
			
			addChild(mParticleSystem);
			Starling.juggler.add(mParticleSystem);
			
			mParticleSystem = mParticleSystems[1];
			mParticleSystem.maxCapacity = 80;
			mParticleSystem.emitterX = 187;
			mParticleSystem.emitterY = 178;
			mParticleSystem.scaleX = mParticleSystem.scaleY = 0.65;
			mParticleSystem.start();
			
			addChild(mParticleSystem);
			Starling.juggler.add(mParticleSystem);

		}
		
		public function takeOff():void {
			_heroIsFlying = true;
			
		}
		
		public function update(rollingX:Number = 0):void
		{
			if (!_heroIsFlying) {
//				if (mParticleSystems[0].emissionRate < 80) mParticleSystems[0].emissionRate += 1;
//				if (mParticleSystems[1].emissionRate < 80) mParticleSystems[1].emissionRate += 1;
			}
			
			this.x += (this.x - (this.x + rollingX * 20)) * 0.6;
			
			if (this.x < _heroLeftLimit) this.x = _heroLeftLimit;
			if (this.x > _heroRightLimit) this.x = _heroRightLimit;
		}
	}
}