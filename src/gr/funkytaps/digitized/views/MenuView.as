package gr.funkytaps.digitized.views
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import com.dimmdesign.utils.GlobalSound;
	import com.dimmdesign.utils.Web;
	import com.greensock.TweenLite;
	
	import flash.system.System;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.events.MenuEvent;
	import gr.funkytaps.digitized.game.GameWorld;
	import gr.funkytaps.digitized.helpers.GameDataHelper;
	import gr.funkytaps.digitized.social.ShareriOS6;
	import gr.funkytaps.digitized.social.SocialSharer;
	import gr.funkytaps.digitized.ui.buttons.CreditsButton;
	import gr.funkytaps.digitized.ui.buttons.GetDigitizedButton;
	import gr.funkytaps.digitized.ui.buttons.LeaderboardButton;
	import gr.funkytaps.digitized.ui.buttons.PlayAgainButton;
	import gr.funkytaps.digitized.ui.buttons.ResumeButton;
	import gr.funkytaps.digitized.ui.buttons.ShareScoreButton;
	import gr.funkytaps.digitized.ui.buttons.SoundButton;
	import gr.funkytaps.digitized.utils.DisplayUtils;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MenuView extends AbstractView
	{
		private var _gameWorld:GameWorld;
		
		private var _gradient:Quad;
		
		private var _background:Quad;
		
		private var _buttonsContainer:Sprite;
		
		private var _soundButton:SoundButton;
		private var _playAgainButton:PlayAgainButton;
		private var _shareScoreButton:ShareScoreButton;
		private var _leaderboardButton:LeaderboardButton;
		private var _creditsButton:CreditsButton;
		private var _getDigitizedButton:GetDigitizedButton;
		private var _buttonsHeight:Number;
		
		private var _headerContainer:Sprite;
		 
		private var _starIcon:Image;
		private var _starTextfield:TextField;
		
		private var _scoreTitle:Image;
		private var _scoreTextfield:TextField;
		
		private var _totalScoreTitle:Image;
		private var _totalScoreTextfield:TextField;
		
		private var _score:Number = 0;
		private var _totalScore:Number = 0;
		private var _stars:Number = 0;
		private var _resumeButton:ResumeButton;
		
		public function MenuView(gameWorld:GameWorld)
		{
			super();
			
			_gameWorld = gameWorld;
			
		}
		
		public function get stars():Number { return _stars; }
		public function set stars(value:Number):void { _stars = value; }

		public function get totalScore():Number { return _totalScore; }
		public function set totalScore(value:Number):void { _totalScore = value; }

		public function get score():Number { return _score; }
		public function set score(value:Number):void{ _score = value; }

		override protected function _init():void {
			
			 _background = new Quad(Settings.WIDTH, Settings.HEIGHT, 0x000000);
			 _background.alpha = 0.8;
			 addChild(_background);

			_gradient = new Quad(Settings.WIDTH, 260);
			_gradient.setVertexColor(0, 0x000000);
			_gradient.setVertexAlpha(1, 0.6);
			_gradient.setVertexColor(1, 0x000000);
			_gradient.setVertexAlpha(1, 0.4);
			_gradient.setVertexColor(2, 0x000000);
			_gradient.setVertexAlpha(2, 0);
			_gradient.setVertexColor(3, 0x000000);
			_gradient.setVertexAlpha(3, 0);
			addChild(_gradient);
			
			//_score = GameDataHelper.getHighScore();
			
			_createHeader();
			
			_createButtons();
			
		}
		
		private function _createHeader():void {
			
			_headerContainer = new Sprite();
			addChild(_headerContainer);
			_headerContainer.touchable = false;
			
			_starIcon = new Image( Assets.manager.getTexture('star-static-icon')  );
			_headerContainer.addChild(_starIcon);
			
			_starIcon.x = 7;
			_starIcon.y = 7;
			
			_starTextfield = new TextField(100, 36, _stars.toString(), Settings.AGORA_FONT_38, -1, 0xFFFFFF);
			_starTextfield.batchable = true;
			_starTextfield.vAlign = VAlign.TOP;
			_starTextfield.hAlign = HAlign.LEFT;
			_headerContainer.addChild(_starTextfield);
			
			_starTextfield.x = 5;
			_starTextfield.y = _starIcon.y + _starIcon.height;
			
			_scoreTitle = new Image( Assets.manager.getTexture('score-title') );
			_headerContainer.addChild(_scoreTitle);
			
			_scoreTitle.x = (Settings.HALF_WIDTH - (_scoreTitle.width >> 1) + 2) | 0;
			_scoreTitle.y = 20;
			
			_scoreTextfield = new TextField(170, 48, _score.toString(), Settings.AGORA_FONT_60, -1, 0xFFFFFF);
			_scoreTextfield.batchable = true;
			_scoreTextfield.autoScale = true;
			_scoreTextfield.vAlign = VAlign.TOP;
			_scoreTextfield.hAlign = HAlign.CENTER;
			_headerContainer.addChild(_scoreTextfield);
			
			_scoreTextfield.x = 70; 
			_scoreTextfield.y = _scoreTitle.y + _scoreTitle.height - 4;
			
			_totalScoreTitle = new Image( Assets.manager.getTexture('total-score-title') );
			_headerContainer.addChild(_totalScoreTitle);
			
			_totalScoreTitle.x = (Settings.HALF_WIDTH - (_totalScoreTitle.width >> 1)) | 0;
			_totalScoreTitle.y = _scoreTextfield.y + _scoreTextfield.height - 5;
			
			_totalScoreTextfield = new TextField(300, 56, _totalScore.toString(), Settings.AGORA_FONT_88, -1, 0xFFFFFF);
			_totalScoreTextfield.batchable = true;
			_totalScoreTextfield.autoScale = true;
			_totalScoreTextfield.vAlign = VAlign.TOP;
			_totalScoreTextfield.hAlign = HAlign.CENTER;
			_headerContainer.addChild(_totalScoreTextfield);
			
			_totalScoreTextfield.x = (Settings.HALF_WIDTH - (_totalScoreTextfield.width >> 1) - 8) | 0;
			_totalScoreTextfield.y = _totalScoreTitle.y + _totalScoreTitle.height - 5;
			
			_headerContainer.flatten();
			
		}
		
		private function _createButtons():void {
			
			_buttonsContainer = new Sprite();
			addChild(_buttonsContainer);
			
//			_buttonsContainer.filter = BlurFilter.createDropShadow();
			
			_shareScoreButton = new ShareScoreButton();
			_shareScoreButton.addEventListener(Event.TRIGGERED, _onShareTriggered);
			_buttonsContainer.addChild(_shareScoreButton);
			
			// all the buttons have the same height so we just store it, 
			// instead of making repeated calls to 'thebutton'.height
			_buttonsHeight = _shareScoreButton.height;
			var prevY:Number = _shareScoreButton.y;
			
			_leaderboardButton = new LeaderboardButton();
			_leaderboardButton.addEventListener(Event.TRIGGERED, _onLeaderboardButtonTriggered);
			_buttonsContainer.addChild(_leaderboardButton);
			_leaderboardButton.y = prevY + _buttonsHeight - 5;
			prevY = _leaderboardButton.y;
			
			if (_gameWorld.isPlaying && !_gameWorld.gameEnded) {
				_resumeButton = new ResumeButton();
				_resumeButton.addEventListener(Event.TRIGGERED, _onResumeTriggered);
				_buttonsContainer.addChild(_resumeButton);
				_resumeButton.y = prevY + _buttonsHeight - 5;
				prevY = _resumeButton.y;
			}
			else if (_gameWorld.gameEnded) {
				_playAgainButton = new PlayAgainButton();
				_playAgainButton.addEventListener(Event.TRIGGERED, _onPlayAgainTriggered);
				_buttonsContainer.addChild(_playAgainButton);
				_playAgainButton.y = prevY + _buttonsHeight - 5;
				prevY = _playAgainButton.y;
			}
			
			_creditsButton = new CreditsButton();
			_creditsButton.addEventListener(Event.TRIGGERED, _onCreditsButtonTriggered);
			_buttonsContainer.addChild(_creditsButton);
			_creditsButton.y = prevY + _buttonsHeight - 5;
			prevY = _creditsButton.y;

			_soundButton = new SoundButton();
			_soundButton.addEventListener(Event.TRIGGERED, _onSoundButtonTriggered);
			_buttonsContainer.addChild(_soundButton);
			_soundButton.y = _creditsButton.y + _buttonsHeight - 5;
			prevY = _soundButton.y;
			
			_getDigitizedButton = new GetDigitizedButton();
			_getDigitizedButton.addEventListener(Event.TRIGGERED, _onGetDigitizedButtonTriggered);
			_buttonsContainer.addChild(_getDigitizedButton);
			_getDigitizedButton.y = prevY + _buttonsHeight - 5;
			prevY = _getDigitizedButton.y;
			
			_buttonsContainer.x = (Settings.HALF_WIDTH - (_buttonsContainer.width >> 1)) | 0;
			_buttonsContainer.y = 160;
			
		}
		
		private function _onShareTriggered():void{
			
			
			trace("onMenu Button Clicked:::::::: SHARE");
			var ev:MenuEvent = new MenuEvent(MenuEvent.MENU_CLICKED, true);
			ev.viewToOpen = MenuEvent.VIEW_SHARE;
			this.dispatchEvent(ev);
		}
		
		private function _onResumeTriggered():void
		{
			// TODO Auto Generated method stub
			_gameWorld.resumeGame();
		}
		
		private function _onGetDigitizedButtonTriggered(event:Event):void
		{
			Web.getURL('http://www.digitized.gr/', '_blank');			
		}
		
		private function _onCreditsButtonTriggered(event:Event):void
		{
			trace("onMenu Button Clicked:::::::: CREDITS");
			var ev:MenuEvent = new MenuEvent(MenuEvent.MENU_CLICKED, true);
			ev.viewToOpen = MenuEvent.VIEW_CREDITS;
			this.dispatchEvent(ev);
			
		}
		
		private function _onLeaderboardButtonTriggered(event:Event):void
		{
			trace("onMenu Button Clicked:::::::: LEADERBOARD");
			var ev:MenuEvent = new MenuEvent(MenuEvent.MENU_CLICKED, true);
			ev.viewToOpen = MenuEvent.VIEW_LEADERBOARD;
			ev.displayOnUserDemand = true;
			this.dispatchEvent(ev);
		}
		
		private function _onSoundButtonTriggered(event:Event):void
		{
			GlobalSound.volume = (GlobalSound.volume == 0) ? 1 : 0;
		}
		
		private function _onPlayAgainTriggered(event:Event):void
		{
			_gameWorld.playAgain();
		}
		
		override public function tweenIn():void {
			
			_soundButton.isToggled = !(GlobalSound.volume == 0);
//			y = Settings.HEIGHT;
//			TweenLite.to(this, 0.75, {y:0});
			alpha = 0;
			TweenLite.to(this, 0.75, {alpha:1, scaleX: 1, scaleY: 1});
		}
		
		override public function tweenOut(onComplete:Function=null, onCompleteParams:Array=null):void {
//			TweenLite.to(this, 0.55, {y:Settings.HEIGHT, onComplete:onComplete, onCompleteParams:onCompleteParams});
			TweenLite.to(this, 0.35, { 
				alpha:0, 
				onComplete:onComplete,
				onCompleteParams:onCompleteParams
			});
		}	
		
		override public function destroy():void {
			DisplayUtils.removeAllChildren(this, true, true, true);
			
			_gameWorld = null;
			_gradient = null;
			_background = null;
			_buttonsContainer = null;
			_soundButton = null;
			_playAgainButton = null;
			_shareScoreButton = null;
			_leaderboardButton = null;
			_creditsButton = null;
			_getDigitizedButton = null;
			_headerContainer = null;
			_starIcon = null;
			_starTextfield = null;
			_scoreTitle = null;
			_scoreTextfield = null;
			_totalScoreTitle = null;
			_totalScoreTextfield = null;
			
		}
		
	}
}