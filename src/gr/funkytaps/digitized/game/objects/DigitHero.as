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
	import gr.funkytaps.digitized.utils.DisplayUtils;
	import gr.funkytaps.digitized.views.GameView;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
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

		private var _sensitivity:Number = 25;
		public function get sensitivity():Number { return _sensitivity; }

		private var _maximumVelocity:Number = 90;
		public function get maximumVelocity():Number { return _maximumVelocity; }
		
		private var _heroIsFlying:Boolean = false;
		private var _crashed:Boolean = false;

		public function get crashed():Boolean { return _crashed; }
		public function set crashed(value:Boolean):void { _crashed = value; }
		
		private var _leftRocketFire:MovieClip;
		private var _rightRocketFire:MovieClip;
		
		private var _gameJuggler:Juggler;
		private var _gameView:GameView;
		
		private var _energyImage:Image;
		private var _pickedUpEnergy:Boolean;
		
		private var _noEnergy:Boolean;
		public function get noEnergy():Boolean { return _noEnergy; }
		
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
			_hero.pivotY = (_heroHeight >> 1) - 4;
			
			_leftRocketFire.x = -(_hero.pivotX - 17);
			_leftRocketFire.y = _hero.pivotY - 24;
			
			_rightRocketFire.x = _hero.pivotX - ((Starling.contentScaleFactor == 1) ? 19 : 17);
			_rightRocketFire.y = _hero.pivotY - 25;
			
			_heroLeftLimit = _hero.pivotX + _limitPadding;
			_heroRightLimit = Settings.WIDTH + _hero.pivotX + _limitPadding;
		
			_energyImage = new Image(Assets.manager.getTexture('energy-shield'));
			_energyImage.visible = false;
			addChildAt(_energyImage, 0);
			_energyImage.pivotX = (_energyImage.width >> 1);
			_energyImage.pivotY = (_energyImage.height >> 1);

			_energyImage.scaleX = _energyImage.scaleY = 0;
			_pickedUpEnergy = false;
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
		
		public function lostEnergy(onComplete:Function = null, onCompleteDelay:Number = 0):void
		{
			_noEnergy = true;
			_leftRocketFire.visible = false;
			_rightRocketFire.visible = false;
			
			TweenLite.to(this, 1, {y:this.y-20, ease:Linear.easeNone});
			TweenLite.to(this, 4, {y:this.y+250, rotation:deg2rad(-20), delay:0.95, ease:Linear.easeNone});
			if (onComplete!=null) TweenLite.delayedCall(onCompleteDelay, onComplete);
		}
		
		public function createEnergyPickup():void {
			if (!_pickedUpEnergy) {
				_pickedUpEnergy = true;
				_energyImage.visible = true;
				_gameJuggler.tween(_energyImage, 0.35, {
					scaleX: 1, 
					scaleY: 1,
					transition: Transitions.EASE_OUT
				});
				
				_gameJuggler.tween(_energyImage, 0.75, {
					rotation: deg2rad(360),
					repeatCount: 2,
					transition: Transitions.LINEAR,
					onComplete:function():void {
						
						_gameJuggler.tween(_energyImage, 0.55, {
							rotation: deg2rad(360),
							scaleX: 0,
							scaleY: 0,
							transition: Transitions.EASE_OUT,
							onComplete:function():void {
								_pickedUpEnergy = false;
								_energyImage.visible = false;
							}
						});
						
					}
				});
			}			
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
			else this.x -= (this.x - rollingX) //* 0.3;
			
		}
		
		override public function destroy():void {
			DisplayUtils.removeAllChildren(this, true, true, true);
			
			_gameJuggler = null;
			_hero = null;
			_leftRocketFire = null;
			_rightRocketFire = null;
			_rightRocketFire = null;
		}
		
	}
}