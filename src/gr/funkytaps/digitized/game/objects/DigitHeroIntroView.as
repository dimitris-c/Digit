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
	
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.utils.deg2rad;
	
	public class DigitHeroIntroView extends AbstractObject
	{
		
		private var _digitHeroStatic:Image;
		
		private var _digitHeroLeftRocket:MovieClip;
		private var _digitHeroRightRocket:MovieClip;

		private var _floatingTween:Tween;
		private var _introJuggler:Juggler;
		
		/**
		 * The hero for the intro view only
		 * @param introJuggler - A juggler object for all the animation required 
		 */		
		public function DigitHeroIntroView(introJuggler:Juggler)
		{
			super();
			
			_introJuggler = introJuggler;
			
		}
		
		override protected function _init():void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_digitHeroStatic = new Image( Assets.manager.getTexture('intro-hero') );
			addChild(_digitHeroStatic);
			
			_digitHeroLeftRocket = new MovieClip(Assets.manager.getTextures('fire6-'), 10);
			addChild(_digitHeroLeftRocket);
			_digitHeroLeftRocket.rotation = deg2rad(-3);
			_digitHeroLeftRocket.x = 55;
			_digitHeroLeftRocket.y = 243;
			
			_digitHeroRightRocket = new MovieClip(Assets.manager.getTextures('fire6-'), 10);
			addChild(_digitHeroRightRocket);
			_digitHeroRightRocket.rotation = deg2rad(2);
			_digitHeroRightRocket.x = 259;
			_digitHeroRightRocket.y = 195;
			
			_introJuggler.add(_digitHeroLeftRocket);
			_introJuggler.add(_digitHeroRightRocket);
		
		}
		
		public function animate():void {
			
			_floatingTween = new Tween(this, 0.75);
			_floatingTween.repeatCount = 0;
			_floatingTween.reverse = true;
			
			_floatingTween.animate('y', 45);
			_floatingTween.animate('y', 30);
			_floatingTween.animate('y', 45);
			
			_introJuggler.add(_floatingTween);
			
		}
		
		override public function dispose():void {
			
			_introJuggler.remove(_floatingTween);
			_introJuggler.remove(_digitHeroLeftRocket);
			_introJuggler.remove(_digitHeroRightRocket);
			
			super.dispose();
			
			_floatingTween = null;
			_digitHeroStatic = null;
			_digitHeroRightRocket = null;
			_digitHeroLeftRocket = null;
		}
		
	}
}