package gr.funkytaps.digitized.game
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import com.dimmdesign.core.IDestroyable;
	
	import flash.desktop.NativeApplication;
	import flash.system.System;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.events.LeaderBoardEvent;
	import gr.funkytaps.digitized.interfaces.IView;
	import gr.funkytaps.digitized.managers.SoundManager;
	import gr.funkytaps.digitized.managers.SystemIdleMonitor;
	import gr.funkytaps.digitized.ui.GamePreloader;
	import gr.funkytaps.digitized.ui.buttons.MenuButton;
	import gr.funkytaps.digitized.views.GameView;
	import gr.funkytaps.digitized.views.IntroView;
	import gr.funkytaps.digitized.views.LeaderboardView;
	import gr.funkytaps.digitized.views.MenuView;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class GameWorld extends Sprite
	{
		public static const INTRO_STATE:int = 0;
		public static const PLAY_STATE:int = 2;
		public static const GAME_END_STATE:int = 3;
		public static const PAUSE_STATE:int = 4;
		
		private var _currentState:int = INTRO_STATE;

		public function get currentState():int { return _currentState; }

		private var _currentView:IView;
		
		/**
		 * A container to hold all the views. Except the menu view.
		 */		
		private var _viewsContainer:Sprite;
		
		/**
		 * The MenuView is more of an overlay view rather that a view.
		 */		
		private var _menuView:MenuView;
		private var _menuButton:MenuButton;
		
		private var _leaderBoardView:LeaderboardView;
		
		private var _assets:AssetManager;
		private var _loadProgress:GamePreloader;

		private var _loadingBackground:Image;
		private var _gamePaused:Boolean;

		public function get gamePaused():Boolean { return _gamePaused; }
		public function set gamePaused(value:Boolean):void { _gamePaused = value; }

		private var _isPlaying:Boolean;

		public function get isPlaying():Boolean { return _isPlaying; }
		
		private var _gameEnded:Boolean;
		
		public function get gameEnded():Boolean { return _gameEnded; }
		public function set gameEnded(value:Boolean):void { _gameEnded = value; }

		private var _menuIsOpen:Boolean;
		private var _appActivated:Boolean;
		
		private var _gradient:Image;
		
		public function GameWorld()
		{
			super();
			
		}

		public function start(background:Texture):void
		{
			
			_loadingBackground = new Image(background);
			addChild(_loadingBackground);
			
			// Add progress background
			_loadProgress = new GamePreloader();
			_loadProgress.ratio = 0;
			addChild(_loadProgress);
			
			_loadProgress.x = ((Settings.HALF_WIDTH) - (_loadProgress.width >> 1)) | 0;
			_loadProgress.y = (Settings.HEIGHT - _loadProgress.height - 100) | 0;
			
			// Load the queue 
			Assets.manager.loadQueue( _onProgress );
			Assets.manager.verbose = true;
			
			_currentState = INTRO_STATE;
			_appActivated = true;
		}
		
		protected function _onDeactivate(event:*):void
		{
			_appActivated = false;
			SoundManager.pauseAllSounds();
			
			if (!_menuIsOpen) {
				_menuButton.setDownState();
				_onMenuButtonTriggered();
			}
			
		}
		
		protected function _onActivate(event:*):void
		{
			_appActivated = true;
			if (_currentState == INTRO_STATE) {
				SoundManager.playSound('intro', int.MAX_VALUE, (_menuIsOpen) ? 0.01 : 0.2);
			}
			
			if (_currentState == PLAY_STATE) {
				SoundManager.playSound('intro', int.MAX_VALUE, 0.01);
			}
			
		}
		
		private function _onProgress(progress:Number):void
		{
			_loadProgress.ratio = progress;
			
			if (progress == 1.0) {
				// we pause for a moment the loader always stucks at 100% 
				// and then we init the freaking world
				Starling.juggler.delayCall(_startupWorld, 0.15);
			}
		}
		
		private function _startupWorld():void {
			
			this.addEventListener(LeaderBoardEvent.OPEN_LEADERBOARD, _onShowLeaderBoard);
			
			_loadingBackground.removeFromParent(true);
			_loadingBackground = null;
			
			_loadProgress.destroy();
			_loadProgress.removeFromParent(true);
			_loadProgress = null;
			
			// about time
			_initWorld();
			
			// listen for activate and deactivate events
			NativeApplication.nativeApplication.addEventListener("activate", _onActivate);
			NativeApplication.nativeApplication.addEventListener("deactivate", _onDeactivate);
			
			// clean-up
			System.pauseForGCIfCollectionImminent();
			System.gc();
		}
		
		private function _initWorld():void {
			
			// play the intro sound
			SoundManager.playSound('intro', int.MAX_VALUE, 0.1, true);
			
			_viewsContainer = new Sprite();
			addChild(_viewsContainer);
			
			_currentView = new IntroView(this);
			_viewsContainer.addChild(_currentView.view());
			
			// Create the menu button. Stays on top of everything!
			_menuButton = new MenuButton();
			_menuButton.addEventListener(Event.TRIGGERED, _onMenuButtonTriggered);
			addChild(_menuButton);
			
			_menuButton.x = Settings.WIDTH - _menuButton.width - 10;
			_menuButton.y = 16;
			
			// Check on every frame makes our game alive
			addEventListener(EnterFrameEvent.ENTER_FRAME, update);

		}
		
		public function showMenuOnGameEnd():void {
			
			_menuButton.setDownState();
			_onMenuButtonTriggered();
			
		}
		
		private function _onMenuButtonTriggered(event:Event = null ):void
		{
			_menuButton.isEnabled = false;
			
			if (_menuView) {
				_gamePaused = false;
				_viewsContainer.touchable = true;
				_menuView.tweenOut(_removeMenuView);
				if (_gameEnded == true) {
					_gameEnded = false;
					_createState(INTRO_STATE);
				}
				return;
			}
			
			_createMenuView();
		}
		
		private function _createMenuView():void {
			_menuButton.isEnabled = true;
			_gamePaused = true;
			
			_menuView = new MenuView(this);
			_menuView.alpha = 1;
			addChild(_menuView);
			
			setChildIndex(_menuButton, numChildren-1);
			
			_menuView.tweenIn();
			
			_menuIsOpen = true;
			
			_viewsContainer.touchable = false;
//			_viewsContainer.filter = new BlurFilter(1, 1);
			
			if (_currentState == PLAY_STATE && _isPlaying) {
				SoundManager.pauseSound('game-theme');
				if (_appActivated) SoundManager.playSound('intro', int.MAX_VALUE, 0.01, true);
			}
			
			if (_currentState == INTRO_STATE) {
				if (_appActivated) {
					SoundManager.tweenSound('intro', 1, 0.011, false)
				}
			}
			
			SystemIdleMonitor.normalMode();
			
		}
		
		private function _removeMenuView():void {
			_menuIsOpen = false;
			_menuButton.isEnabled = true;
			_menuView.destroy();
			_menuView.removeFromParent(true);
			_menuView = null;
			
			if (_currentState == INTRO_STATE) {
				SoundManager.tweenSound('intro', 1, 0.11, false);
			}
			
			if (_currentState == PLAY_STATE && _isPlaying) {
				SoundManager.stopSound('intro');
				if (!SoundManager.getSound('game-theme').isPlaying) 
					SoundManager.playSound('game-theme', int.MAX_VALUE, 0.2);
				SystemIdleMonitor.keepAwakeMode();
			}
		}
		
		//Leader Board
		private function _onShowLeaderBoard(e:LeaderBoardEvent):void{
			e.stopPropagation();
			//add a custom event so we can know whether we are coming from an ended game or from menu 
			_createLeaderBoardView(e.displayOnUserDemand, e.highScore);
		}
		
		private function _createLeaderBoardView(displayedOnUserDemand:Boolean, highScore:String):void{
			if(!_leaderBoardView){
				trace("Creating Leaderboard");
				_leaderBoardView = new LeaderboardView(displayedOnUserDemand, highScore);
				_leaderBoardView.addEventListener(Event.REMOVED, _onRemoved);
				addChild(_leaderBoardView);
			}
		}
		
		private function _onRemoved(e:Event):void{
			_destroyLeaderBoardView();
		}
		
		private function _destroyLeaderBoardView():void{
			if(_leaderBoardView){
				_leaderBoardView.removeEventListener(Event.REMOVED, _onRemoved);
				_leaderBoardView = null;
			}
		}
		
		/**
		 * This gets called form the menuView button PlayAgain 
		 */		
		public function playAgain():void
		{
			if (_gameEnded) {
				_gameEnded = false;
				_menuButton.setNormalState();
				_onMenuButtonTriggered();
				_createState(PLAY_STATE);
			}
		}
		
		
		public function resumeGame():void
		{
			_gamePaused = false;
			_menuButton.setNormalState();
			_onMenuButtonTriggered();
		}
		
		public function changeState(state:int):void {
			_createState(state);
		}
		
		[Inline]
		private final function _createState(state:int):void { 
			_currentState = state;
			
			if (_currentView is IDestroyable) _currentView.destroy();
			_currentView.removeFromParent(true);
			_currentView = null;
			
			switch(_currentState)
			{
				case INTRO_STATE:
				{
					_currentView = new IntroView(this);
					_isPlaying = false;
					SystemIdleMonitor.normalMode();
					break;
				}
					
				case PLAY_STATE:
				{
					_currentView = new GameView(this);
					_isPlaying = true;
					SystemIdleMonitor.keepAwakeMode();
					break;
				}
					
				case PAUSE_STATE:
					_isPlaying = false;
					break;
					
				case GAME_END_STATE:
				{
					_gameEnded = true;
					SystemIdleMonitor.normalMode();
					break;
				}
			}
			
			_viewsContainer.addChild(_currentView.view());
			
		}
		
		private function update(event:EnterFrameEvent):void
		{
			
			if (_currentView) {		
				if (!_gamePaused) _currentView.update( event.passedTime );
			}
		}
		
	}
}