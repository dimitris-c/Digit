package gr.funkytaps.digitized.objects
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import flash.display.Bitmap;
	
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class DigitHero extends AbstractObject
	{
		[Embed(source="../../../../../assets/flash/images/hero.png")]
		public static const Hero:Class;
		
		[Embed(source="../../../../../assets/flash/rocketflame.pex", mimeType="application/octet-stream")]
		private static const RocketFlame:Class;
		
		[Embed(source="../../../../../assets/flash/particleTexture.png")]
		private static const ParticleTexture:Class;
		
		private var _hero:Image;
		
		private var mParticleSystems:Vector.<ParticleSystem>;
		private var mParticleSystem:ParticleSystem;
		
		public function DigitHero()
		{
			super();
		}

		override protected function _init():void
		{
			
			var rocketConfig:XML = XML(new RocketFlame());
			var particleTexture:Texture = Texture.fromBitmap(new ParticleTexture());
			
			mParticleSystems = new <ParticleSystem>[
				new PDParticleSystem(rocketConfig, particleTexture),
				new PDParticleSystem(rocketConfig, particleTexture)
			];
			
			if (mParticleSystem)
			{
				mParticleSystem.stop();
				mParticleSystem.removeFromParent();
				Starling.juggler.remove(mParticleSystem);
			}
			
			mParticleSystem = mParticleSystems[0];
			PDParticleSystem(mParticleSystem).emitAngle = deg2rad( -270 );
			mParticleSystem.emitterX = 10;
			mParticleSystem.emitterY = 150;
			mParticleSystem.start();
			
			addChild(mParticleSystem);
			Starling.juggler.add(mParticleSystem);
			
			mParticleSystem = mParticleSystems[1];
			PDParticleSystem(mParticleSystem).emitAngle = deg2rad( -270 );
			mParticleSystem.emitterX = 163;
			mParticleSystem.emitterY = 150;
			mParticleSystem.start();
			
			addChild(mParticleSystem);
			Starling.juggler.add(mParticleSystem);
			
			var heroBitmap:Bitmap = new DigitHero.Hero() as Bitmap;
			_hero = Image.fromBitmap(heroBitmap);
			addChild(_hero);
			
		}
		
		public function update():void
		{
			
			//x += (Starling.current.nativeStage.mouseX - x) * 0.3;
			//y += (Starling.current.nativeStage.mouseY - y) * 0.3;
			x += (Starling.current.nativeStage.mouseX - x) * 0.5 - _hero.width*0.5;
			y += (Starling.current.nativeStage.mouseY - y) * 0.5 - _hero.height*0.5;
		}
	}
}