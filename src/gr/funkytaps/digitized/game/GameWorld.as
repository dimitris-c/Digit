package gr.funkytaps.digitized.game
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import flash.system.System;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.events.LeaderBoardEvent;
	import gr.funkytaps.digitized.interfaces.IView;
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
		
		private var _currentState:int = INTRO_STATE;
		
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
			
			_currentState = INTRO_STATE;
			
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
			
			// clean-up
			System.pauseForGCIfCollectionImminent();
			System.gc();
		}
		
		private function _initWorld():void {
			
			// play the intro sound
//			SoundManager.playSound('intro', int.MAX_VALUE, 0.3);
			
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
		
		private function _onMenuButtonTriggered(event:Event ):void
		{
			_menuButton.isEnabled = false;
			
			if (_menuView) {
				_gamePaused = false;
				_viewsContainer.touchable = true;
//				_viewsContainer.filter = null;
				_menuView.tweenOut(_removeMenuView);
				return;
			}
			
			_createMenuView();
		}
		
		private function _createMenuView():void {
			_menuButton.isEnabled = true;
			_gamePaused = true;
			
			_menuView = new MenuView(this);
			_menuView
			_menuView.alpha = 1;
			addChild(_menuView);
			
			setChildIndex(_menuButton, numChildren-1);
			
			_menuView.tweenIn();
			
			_viewsContainer.touchable = false;
//			_viewsContainer.filter = new BlurFilter(1, 1);
			
			SystemIdleMonitor.normalMode();
			
		}
		
		private function _removeMenuView():void {
			_menuButton.isEnabled = true;
			_menuView.removeFromParent(true);
			_menuView = null;
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
		
		public function changeState(state:int):void {
//			if (_currentView) {
//				_currentView.tweenOut(_createState, [state]);
//				return;
//			}
			
			_createState(state);
		}
		
		private function _createState(state:int):void { 
			_currentState = state;
			
			_currentView.removeFromParent(true);
			_currentView = null;
			
			switch(_currentState)
			{
				case INTRO_STATE:
				{
					SystemIdleMonitor.normalMode();
					break;
				}
					
				case PLAY_STATE:
				{
					_currentView = new GameView(this);
					SystemIdleMonitor.keepAwakeMode();
					break;
				}
					
				case GAME_END_STATE:
				{
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