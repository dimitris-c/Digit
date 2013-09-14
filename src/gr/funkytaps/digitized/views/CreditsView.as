package gr.funkytaps.digitized.views
{
	import com.dimmdesign.utils.Web;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.ui.buttons.CloseLeaderBoardViewButton;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;

	public class CreditsView extends AbstractView
	{
		private var _closeButton:CloseLeaderBoardViewButton;
		
		private var _background:Image;
		private var _gradient:Quad;
		
		private var _logo:Image;
		private var _title:Image;
		private var _funky:Image;
		private var _people:Image;
		private var _alien:Image;
		
		public function CreditsView()
		{
			super();
		}
		
		override protected function _init():void {
			_background = new Image( Assets.manager.getTexture('generic-background') );
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
			//addChild(_gradient);
			
			_closeButton = new CloseLeaderBoardViewButton();
			_closeButton.x = 10;
			_closeButton.y = 10;
			_closeButton.addEventListener(Event.TRIGGERED, _onCloseButtonTriggered);
			addChild(_closeButton);
			
			_logo = new Image( Assets.manager.getTexture('digitized-logo') );
			_title = new Image( Assets.manager.getTexture('created-title') );
			_funky = new Image( Assets.manager.getTexture('credits-title') );
			_people = new Image( Assets.manager.getTexture('credits-people') );
			_alien = new Image( Assets.manager.getTexture('credits-alien') );

			addChild(_alien);
			
			addChild(_title);
			addChild(_funky);
			addChild(_people);
			
			addChild(_logo);

			_logo.x = Settings.WIDTH*0.5 - _logo.width*0.5;
			_logo.y = 10;

			_title.x = Settings.WIDTH*0.5 - _title.width*0.5;
			_title.y = _logo.y + _logo.height + 0;

			_funky.x = Settings.WIDTH*0.5 - _funky.width*0.5;
			_funky.y = _title.y + _title.height - 0;
			
			_people.x = Settings.WIDTH*0.5 - _people.width*0.5;
			_people.y = _funky.y + _funky.height - 0;

			_alien.y = _people.y + _people.height - 10;
			
			//_funky.addEventListener(Event.TRIGGERED, _openFunky);
			
		}
		
		private function _onCloseButtonTriggered(event:Event ):void{
			this.removeFromParent(true);
		}
		
		private function _openFunky(e:Event):void{
			Web.getURL('http://www.funkytaps.gr/', '_blank');
		}
		
	}
}