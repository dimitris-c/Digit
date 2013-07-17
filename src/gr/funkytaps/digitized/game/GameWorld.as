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
	import gr.funkytaps.digitized.interfaces.IView;
	import gr.funkytaps.digitized.managers.SystemIdleMonitor;
	import gr.funkytaps.digitized.ui.GamePreloader;
	import gr.funkytaps.digitized.ui.buttons.MenuButton;
	import gr.funkytaps.digitized.views.GameView;
	import gr.funkytaps.digitized.views.IntroView;
	import gr.funkytaps.digitized.views.MenuView;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
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
		 * A container to hold all the views.
		 */		
		private var _viewsContainer:Sprite;
		
		/**
		 * The MenuView is more of an overlay view rather that a view.
		 */		
		private var _menuView:MenuView;
		private var _menuButton:MenuButton;
		
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
			
			Assets.manager.verbose = true;
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
			
			var fadeOut:Tween = new Tween(_loadingBackground, 0.35, Transitions.EASE_OUT);
			fadeOut.fadeTo(0);
			fadeOut.onComplete = function():void {
				_loadingBackground.removeFromParent(true);
				_loadingBackground = null;
			};
			Starling.juggler.add(fadeOut);
			
			_loadProgress.destroy();
			_loadProgress.removeFromParent(true);
			_loadProgress = null;

			// finally
			_initWorld();
			
			// clean-up
			System.pauseForGCIfCollectionImminent();
			System.gc();
		}
		
		private function _initWorld():void {
			
			_viewsContainer = new Sprite();
			addChild(_viewsContainer);
			
			_currentView = new IntroView(this);
			_viewsContainer.addChild(_currentView.view());
			
			_menuButton = new MenuButton();
			_menuButton.addEventListener(Event.TRIGGERED, _onMenuButtonTriggered);
			addChild(_menuButton);
			
			_menuButton.x = Settings.WIDTH - _menuButton.width - 10;
			_menuButton.y = 10;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, update);

		}
		
		private function _onMenuButtonTriggered(event:Event):void
		{
			_menuButton.isEnabled = false;
			
			if (_menuView) {
				if (_currentState == GameWorld.PLAY_STATE) {
					_gamePaused = false;
				}
				_menuView.tweenOut(_removeMenuView);
				return;
			}
			
			_createMenuView();
		}
		
		private function _createMenuView():void {
			_menuButton.isEnabled = true;
			
			_menuView = new MenuView(this);
			addChild(_menuView);
			
			setChildIndex(_menuButton, numChildren-1);
			
			_menuView.tweenIn();
			
			SystemIdleMonitor.normalMode();
			
			if (_currentState == GameWorld.PLAY_STATE) {
				_gamePaused = true;
			}
			
		}
		
		private function _removeMenuView():void {
			_menuButton.isEnabled = true;
			_menuView.removeFromParent(true);
			_menuView = null;
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