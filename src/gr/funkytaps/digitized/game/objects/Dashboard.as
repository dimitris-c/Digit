package gr.funkytaps.digitized.game.objects
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import com.dimmdesign.core.IDestroyable;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.utils.DisplayUtils;
	import gr.funkytaps.digitized.utils.StringUtils;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.Gauge;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Dashboard extends Sprite implements IDestroyable
	{
		private var _starIcon:Image;
		private var _starTextfield:TextField;
		
		private var _scoreTitle:Image;
		private var _scoreTextfield:TextField;
		
		private var _energyTitle:Image;
		private var _energyBarContainer:Sprite;
		private var _energyBarBackground:Image;
		private var _energyBar:Gauge;
		
		private var _currentStarCount:Number = 0;
		private var _currentScore:Number = 0;
		private var _currentEnergyRatio:Number = 1;
		
		public static var START_COUNT:Number = 0;
		public static var SCORE:Number = 0;
		
		public function Dashboard()
		{
			super();
			
			touchable = false; // for performance
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		/**
		 * The current ratio of the energy bar.<br />
		 * Value should be in the range of 0 to 1.
		 */		
		public function get currentEnergyRatio():Number { return _currentEnergyRatio; }
		public function set currentEnergyRatio(value:Number):void { _currentEnergyRatio = (value > 1.0) ? 1.0 : (value < 0.0) ? 0.0 : value; }

		public function get currentScore():int { return _currentScore; }

		public function get currentStarCount():int { return _currentStarCount; }

		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			// Create the star icon and count
//			_starIcon = new Image(Assets.manager.getTexture('star-static-icon'));
//			addChild(_starIcon);
//			
//			_starIcon.x = 0;
//			_starIcon.y = 0;
//			
//			_starTextfield = new TextField(90, 36, '0', Settings.AGORA_FONT_38, -1, 0xffffff);
////			_starTextfield.autoScale = true;
//			_starTextfield.batchable = true;
//			_starTextfield.vAlign = VAlign.TOP;
//			_starTextfield.hAlign = HAlign.LEFT;
//			addChild(_starTextfield);
//			
//			_starTextfield.x = -2;
//			_starTextfield.y = _starIcon.y + _starIcon.height;
			
			// Create the score title and count
			_scoreTitle = new Image(Assets.manager.getTexture('score-title'));
			addChild(_scoreTitle);
			
			_scoreTitle.x = 0;
			_scoreTitle.y = 0;
			
			_scoreTextfield = new TextField(110, 36, '0', Settings.AGORA_FONT_38, -1, 0xffffff);
			_scoreTextfield.autoScale = true;
			_scoreTextfield.batchable = true;
			_scoreTextfield.vAlign = VAlign.TOP;
			_scoreTextfield.hAlign = HAlign.LEFT;
			addChild(_scoreTextfield);
			
			_scoreTextfield.x = -2;
			_scoreTextfield.y = _scoreTitle.y + _scoreTitle.height;
			
			// Create the energy title and count
			_energyTitle = new Image( Assets.manager.getTexture('energy-title') );
			addChild(_energyTitle);
			
			_energyTitle.x = Settings.HALF_WIDTH - (_energyTitle.width >> 1) - 4;
			_energyTitle.y = 0;
			
			_createEnergyBar();
		}
		
		private function _createEnergyBar():void {
			
			_energyBarContainer = new Sprite();
			addChild(_energyBarContainer);

			_energyBarBackground = new Image( Assets.manager.getTexture('energy-background') );
			_energyBarContainer.addChild(_energyBarBackground);
			
			_energyBar = new Gauge( Assets.manager.getTexture('energy-progress') );
			_energyBarContainer.addChild(_energyBar);
			_energyBar.x = 3;
			_energyBar.y = 3;
			if (Starling.contentScaleFactor == 1) _energyBar.height = _energyBar.height-1; // only for sd displays
			_energyBar.ratio = 1;
			
			_energyBarContainer.x = _energyTitle.x - 3;
			_energyBarContainer.y = _energyTitle.y + _energyTitle.height + 5;
		}
		
		/**
		 * Updates the energy bar ratio/progress. <br />
		 * 
		 * @param ratio A value between 0 and 1, the latter means the progress is full.
		 * 
		 */	
		[Inline]
		public final function updateEnergyBar(ratio:Number):void {
			if (_energyBar) _energyBar.ratio = ratio;
		}
		
//		/**
//		 * Updates the current stars textfield value
//		 */	
//		[Inline]
//		public final function updateStars(count:Number):void {
////			_currentStarCount += count;
////			START_COUNT = _currentStarCount;
////			if (_starTextfield) _starTextfield.text = _currentStarCount.toString();
//		}
		
		/**
		 * Updates the current score's textfield value 
		 */		
		[Inline]
		public final function updateScore(score:Number):void {
			_currentScore += score;
			SCORE = _currentScore;
			if (_scoreTextfield) _scoreTextfield.text = StringUtils.formatNumber(_currentScore, '.');
		}
		
		public function getCurrentScore():Number{
			return _currentScore;
		}
		
		public function destroy():void {
			DisplayUtils.removeAllChildren(this, true, true);
			
			SCORE = 0;
			START_COUNT = 0;
			
			_starIcon = null;
			_starTextfield = null;
			_scoreTitle = null;
			_scoreTextfield = null;
			_energyTitle = null;
			_energyBarContainer = null;
			_energyBarBackground = null;
			_energyBar = null;
			
		}
	}
}