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
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.utils.deg2rad;
	
	public class DigitHero extends AbstractObject
	{
		
		private var _hero:Image;
		
		private var _heroWidth:Number;
		private var _heroHeight:Number;
		private var _limitPadding:Number = 25;
		private var _heroLeftLimit:Number;
		private var _heroRightLimit:Number;
		
		private var _heroPosition:Number;
		private var _deceleration:Number = 0.09;
		public function get deceleration():Number { return _deceleration; }

		private var _sensitivity:Number = 20;
		public function get sensitivity():Number { return _sensitivity; }

		private var _maximumVelocity:Number = 80;
		public function get maximumVelocity():Number { return _maximumVelocity; }
		
		private var _heroIsFlying:Boolean = false;
		
		private var _leftRocketFire:MovieClip;
		private var _rightRocketFire:MovieClip;
		
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
				
			_leftRocketFire = new MovieClip(Assets.manager.getTextures('fire7'), 10);
			addChild(_leftRocketFire);
			_leftRocketFire.play();
			
			_rightRocketFire = new MovieClip(Assets.manager.getTextures('fire7'), 10);
			addChild(_rightRocketFire);
			_rightRocketFire.play();
			
			_gameJuggler.add(_rightRocketFire);
			_gameJuggler.add(_leftRocketFire);
			
			_hero = new Image(Assets.manager.getTexture('hero-static'));
			addChild(_hero);
			
			_heroWidth = width;
			_heroHeight = height;
			
			_hero.pivotX = _heroWidth >> 1;
			_hero.pivotY = _heroHeight >> 1;
			
			_leftRocketFire.x = -_hero.pivotX;
			_leftRocketFire.y = _hero.pivotY - 6;
			
			_rightRocketFire.x = _hero.pivotX - 10;
			_rightRocketFire.y = _hero.pivotY - 7;
			
			_heroLeftLimit = _hero.pivotX - _limitPadding;
			_heroRightLimit = Settings.WIDTH - _hero.pivotY + _limitPadding;
			
		}
		
		public function takeOff():void {
			_heroIsFlying = true;
			
		}
		
		public function update(rollingX:Number = 0, noAcceletometer:Boolean = false):void
		{
			if (!_heroIsFlying) {
				
			}
			
			_heroPosition = this.x;
			_heroPosition += rollingX;
			
			if (this.x < 0) {
				_heroPosition = Settings.WIDTH;
			}
			if (this.x > Settings.WIDTH) {
				_heroPosition = 0;
			}
			
			if (!noAcceletometer) this.rotation = deg2rad(rollingX * 0.85);
			
			if (!noAcceletometer) this.x = _heroPosition;
			else this.x -= (this.x - rollingX) * 0.3;
			
		}
		
	}
}