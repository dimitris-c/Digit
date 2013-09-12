package gr.funkytaps.digitized.game.objects
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.utils.Mathematics;
	import gr.funkytaps.digitized.views.GameView;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.utils.deg2rad;
	
	public class DigitHero extends AbstractObject
	{
		
		private var _hero:Image;
		
		private var _heroWidth:Number;
		private var _heroHeight:Number;
		private var _limitPadding:Number = 0;
		private var _heroLeftLimit:Number;
		private var _heroRightLimit:Number;
		
		private var _heroPosition:Number;
		private var _deceleration:Number = 0.099;
		public function get deceleration():Number { return _deceleration; }

		private var _sensitivity:Number = 15;
		public function get sensitivity():Number { return _sensitivity; }

		private var _maximumVelocity:Number = 70;
		public function get maximumVelocity():Number { return _maximumVelocity; }
		
		private var _heroIsFlying:Boolean = false;
		private var _crashed:Boolean = false;

		public function get crashed():Boolean { return _crashed; }
		
		private var _leftRocketFire:MovieClip;
		private var _rightRocketFire:MovieClip;
		
		private var _gameJuggler:Juggler;
		private var _gameView:GameView;
		
		public function DigitHero(gameJuggler:Juggler = null, gameView:GameView = null)
		{
			super();
			_gameJuggler = gameJuggler;
			_gameView = gameView;
		}
		
		public function get heroHeight():Number { return _heroHeight; }

		public function get heroWidth():Number { return _heroWidth; }

		override protected function _init():void
		{
			
			touchable = false; // for performance.
				
			_hero = new Image(Assets.manager.getTexture('hero-static'));
			addChild(_hero);
			
			_leftRocketFire = new MovieClip(Assets.manager.getTextures('fire7'), 10);
			addChild(_leftRocketFire);
			_leftRocketFire.play();
			
			_rightRocketFire = new MovieClip(Assets.manager.getTextures('fire7'), 10);
			addChild(_rightRocketFire);
			_rightRocketFire.play();
			
			_gameJuggler.add(_rightRocketFire);
			_gameJuggler.add(_leftRocketFire);
			
			_heroWidth = width;
			_heroHeight = height;
			
			_hero.pivotX = (_heroWidth >> 1) - 4;
			_hero.pivotY = _heroHeight >> 1;
			
			_leftRocketFire.x = -(_hero.pivotX - 17);
			_leftRocketFire.y = _hero.pivotY - 32;
			
			_rightRocketFire.x = _hero.pivotX - ((Starling.contentScaleFactor == 1) ? 19 : 17);
			_rightRocketFire.y = _hero.pivotY - 33;
			
			_heroLeftLimit = _hero.pivotX + _limitPadding;
			_heroRightLimit = Settings.WIDTH + _hero.pivotX + _limitPadding;
		
		}
		
		public function takeOff():void {
			_heroIsFlying = true;
			
		}
		
		public function crashHero():void {
			_crashed = true;
			_leftRocketFire.visible = false;
			_rightRocketFire.visible = false;
			TweenLite.to(this, 3, {y:100, rotation:deg2rad(-8),  ease:Linear.easeNone});
		}
		
		public function update(rollingX:Number = 0, noAcceletometer:Boolean = false):void
		{
			if (_crashed) return;
			if (!_heroIsFlying) {
				
			}
			_heroPosition = this.x;
			_heroPosition += rollingX;
			
			if (this.x < -_heroLeftLimit) _heroPosition = _heroRightLimit;
			if (this.x > _heroRightLimit) _heroPosition = -_heroLeftLimit;
			
			if (!noAcceletometer) this.rotation = deg2rad(rollingX * 0.85);
			
			if (!noAcceletometer) this.x = _heroPosition;
			else this.x -= (this.x - rollingX) * 0.3;
			
		}
		
	}
}