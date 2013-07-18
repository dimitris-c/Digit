package gr.funkytaps.digitized.views
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.game.GameWorld;
	import gr.funkytaps.digitized.game.objects.DigitHeroIntroView;
	import gr.funkytaps.digitized.ui.buttons.StartButton;
	
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.events.Event;

	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class IntroView extends AbstractView
	{
		private var _gameWorld:GameWorld;
		
		private var _introJuggler:Juggler;
		
		private var _starsBackground:Image;
		
		private var _gradient:Image;
		
		private var _digitHero:DigitHeroIntroView;
		
		private var _planet:Image;
		
		private var _title:Image;
		
		private var _startButton:StartButton;

		private var _timeline:TimelineLite;

		private var _digitHeroFinalX:int;
		
		public function IntroView(gameWorld:GameWorld)
		{
			_gameWorld = gameWorld;
			super();
		}
		
		override protected function _init():void {
			
			_starsBackground = new Image( Assets.manager.getTexture('generic-background') );
			addChild(_starsBackground);
			
			_introJuggler = new Juggler();
			
			_gradient = new Image(Assets.manager.getTexture('gradient'));
			addChild(_gradient);
			
			_planet = new Image( Assets.manager.getTexture('intro-planet') );
			addChild(_planet);
			
			_planet.x = Settings.WIDTH - _planet.width + 1;
			_planet.y = 75;
			
			_digitHero = new DigitHeroIntroView( _introJuggler );
			addChild(_digitHero);
			
			_digitHero.x = Settings.WIDTH + _digitHero.width + 200;
			_digitHero.y = 800;
			
			_digitHeroFinalX = Settings.HALF_WIDTH - (_digitHero.width >> 1);
			
			_title = new Image( Assets.manager.getTexture('intro-screen-title') );
			addChild(_title);
			_title.alpha = 0;
			_title.x = (Settings.HALF_WIDTH - (_title.width >> 1)) | 0;
			_title.y = _digitHero.height + 5;
			
			_startButton = new StartButton();
			_startButton.alpha = 0;
			addChild(_startButton);
			
			_startButton.addEventListener(Event.TRIGGERED, _onStartButtonTriggered);
			
			_startButton.x = (Settings.HALF_WIDTH - (_startButton.width >> 1)) | 0;
			_startButton.y = _title.y + _title.height + 10;
			
			tweenIn();
			
			
		}
		
		private function _onStartButtonTriggered(event:Event):void
		{
			_gameWorld.changeState( GameWorld.PLAY_STATE );
		}
		
		override public function tweenIn():void {
			
			_timeline = new TimelineLite();
			_timeline.autoRemoveChildren = true;
			
			_timeline.append( TweenLite.to(_digitHero, 1.4, {bezierThrough:[{x:200, y:450}, {x:_digitHeroFinalX, y:30}], ease:Expo.easeOut}) );
			_timeline.append( TweenLite.to(_title, 1, {alpha:1, ease:Expo.easeOut}), - 0.7 );
			_timeline.append( TweenLite.to(_startButton, 1, {alpha:1, ease:Expo.easeOut}), - 0.7 );
			
			_timeline.play();
			
			_introJuggler.delayCall(_digitHero.animate, 1.6);
			
		}
		
		override public function tweenOut(onComplete:Function=null, onCompleteParams:Array = null):void {
			
			TweenLite.to(this, 0.35, {alpha:0, onComplete:onComplete, onCompleteParams:onCompleteParams});
			
		}
		
		override public function update(passedTime:Number=0):void {
			
			_introJuggler.advanceTime( passedTime );
			
		}
		
		override public function destroy():void {
			
			_timeline.clear();
			_timeline = null;
			
			_starsBackground = null;
			_digitHero = null;
			_title = null;
			
		}
		
	}
}