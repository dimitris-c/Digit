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
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.Gauge;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Dashboard extends Sprite
	{
		private var _starIcon:Image;
		private var _starTextfield:TextField;
		
		private var _scoreTitle:Image;
		private var _scoreTextfield:TextField;
		
		private var _energyTitle:Image;
		private var _energyBarContainer:Sprite;
		private var _energyBarBackground:Image;
		private var _energyBar:Gauge;
		
		private var _currentStarCount:int;
		
		public function Dashboard()
		{
			super();
			
			touchable = false; // for performance
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			// Create the star icon and count
			_starIcon = new Image(Assets.manager.getTexture('star-static-icon'));
			addChild(_starIcon);
			
			_starIcon.x = 0;
			_starIcon.y = 0;
			
			_starTextfield = new TextField(90, 36, '0', Settings.AGORA_FONT_38, -1, 0xffffff);
//			_starTextfield.autoScale = true;
			_starTextfield.batchable = true;
			_starTextfield.vAlign = VAlign.TOP;
			_starTextfield.hAlign = HAlign.LEFT;
			addChild(_starTextfield);
			
			_starTextfield.x = -2;
			_starTextfield.y = _starIcon.y + _starIcon.height;
			
			// Create the score title and count
			_scoreTitle = new Image(Assets.manager.getTexture('score-title'));
			addChild(_scoreTitle);
			
			_scoreTitle.x = _starTextfield.x + _starTextfield.width;
			_scoreTitle.y = 0;
			
			_scoreTextfield = new TextField(110, 36, '0', Settings.AGORA_FONT_38, -1, 0xffffff);
			_scoreTextfield.autoScale = true;
			_scoreTextfield.batchable = true;
			_scoreTextfield.vAlign = VAlign.TOP;
			_scoreTextfield.hAlign = HAlign.LEFT;
			addChild(_scoreTextfield);
			
			_scoreTextfield.x = _starTextfield.x + _starTextfield.width - 8;
			_scoreTextfield.y = _starTextfield.y;
			
			// Create the energy title and count
			_energyTitle = new Image( Assets.manager.getTexture('energy-title') );
			addChild(_energyTitle);
			
			_energyTitle.x = _scoreTitle.x + _scoreTitle.width + 25;
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
			
			_energyBar.ratio = 1;
			
			_energyBarContainer.x = _energyTitle.x;
			_energyBarContainer.y = _energyTitle.y + _energyTitle.height + 9;
		}
		
		/**
		 * Updates the energy bar ratio/progress. <br />
		 * 
		 * @param ratio A value between 0 and 1, the latter means the progress is full.
		 * 
		 */	
		public function updateEnergyBar(ratio:Number):void {
			if (_energyBar) _energyBar.ratio = ratio;	
		}
		
		/**
		 * Updates the current stars textfield value 
		 */	
		public function updateStars(count:Number):void {
			_currentStarCount += count;
			if (_starTextfield) _starTextfield.text = _currentStarCount.toString();
		}
		
		/**
		 * Updates the current score's textfield value 
		 */		
		public function updateScore(score:Number):void {
			if (_scoreTextfield) _scoreTextfield.text = score.toString();
		}
	}
}