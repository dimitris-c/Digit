package gr.funkytaps.digitized.views
{
	import gr.funkytaps.digitized.game.DigitHero;
	import gr.funkytaps.digitized.game.background.Background;
	
	public class GameView extends AbstractView
	{
		
		private var background:Background;
		
		public function GameView()
		{
			super();
		}
		
		override protected function _init():void
		{
			background = new Background();
			addChild(background);
			
			var hero:DigitHero = new DigitHero();
			addChild(hero);
			
			hero.x = ((stage.stageWidth >> 1) - (hero.width >> 1)) | 0;
			hero.y = 300;
			
		}
		
		override public function update():void{
			background.update();
		}
	}
}