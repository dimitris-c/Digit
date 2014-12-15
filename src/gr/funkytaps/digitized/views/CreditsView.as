package gr.funkytaps.digitized.views
{
	import com.dimmdesign.utils.Web;
	import com.greensock.TweenLite;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.events.ViewEvent;
	import gr.funkytaps.digitized.ui.buttons.BackButton;
	import gr.funkytaps.digitized.ui.buttons.BaseButton;
	import gr.funkytaps.digitized.utils.DisplayUtils;
	
	import starling.display.Image;
	import starling.events.Event;

	public class CreditsView extends AbstractView
	{
		private var _closeButton:BackButton;
		
		private var _background:Image;
		private var _gradient:Image;
		
		private var _createForTitle:BaseButton;
		private var _funkytaps:BaseButton;
		private var _people:Image;
		private var _alien:Image;
		private var _logo:BaseButton;
		
		public function CreditsView()
		{
			super();
		}
		
		override protected function _init():void {
			_background = new Image( Assets.manager.getTexture('generic-background') );
			addChild(_background);
			
			_gradient = new Image( Assets.manager.getTexture('gradient'));
			addChild(_gradient);
			
			_closeButton = new BackButton();
			_closeButton.x = 10;
			_closeButton.y = 10;
			_closeButton.addEventListener(Event.TRIGGERED, _onCloseButtonTriggered);
			addChild(_closeButton);
			
			_logo = new BaseButton(Assets.manager.getTexture('digitized-logo'));
			_logo.addEventListener(Event.TRIGGERED, _handleLogoTapped)
			addChild(_logo);
			
			_createForTitle =  new BaseButton(Assets.manager.getTexture('created-title'));
			_createForTitle.addEventListener(Event.TRIGGERED, _handleLogoTapped)
				
			_funkytaps = new BaseButton(Assets.manager.getTexture('credits-title'));
			_funkytaps.addEventListener(Event.TRIGGERED, _handleFunkytapsTapped);
				
			_people = new Image( Assets.manager.getTexture('credits-people') );
			_alien = new Image( Assets.manager.getTexture('credits-alien') );

			addChild(_alien);
			
			addChild(_createForTitle);
			addChild(_funkytaps);
			addChild(_people);
			

			_logo.x = (Settings.HALF_WIDTH - (_logo.width >> 1)) | 0;
			_logo.y = 10;

			_createForTitle.x = (Settings.HALF_WIDTH - (_createForTitle.width >> 1)) | 0;
			_createForTitle.y = _logo.y + _logo.height + 0;

			_funkytaps.x = (Settings.HALF_WIDTH - (_funkytaps.width >> 1)) | 0;
			_funkytaps.y = _createForTitle.y + _createForTitle.height - 0;
			
			_people.x = (Settings.HALF_WIDTH - (_people.width >> 1)) | 0;
			_people.y = _funkytaps.y + _funkytaps.height - 0;

			_alien.y = (_people.y + _people.height - 10) | 0;
			
			//_funky.addEventListener(Event.TRIGGERED, _openFunky);
		}
		
		private function _handleFunkytapsTapped(event:Event):void
		{
			// TODO Auto Generated method stub
			Web.getURL('http://www.funkytaps.gr/', '_blank');
		}
		
		
		private function _handleLogoTapped(event:Event):void
		{
			// TODO Auto Generated method stub
			Web.getURL('http://www.digitized.gr/', '_blank');
		}
		
		private function _onCloseButtonTriggered(event:Event ):void{
			//this.removeFromParent(true);
			dispatchEvent(new ViewEvent(ViewEvent.DESTROY_VIEW));
		}
		
		private function _openFunky(e:Event):void{
			Web.getURL('http://www.funkytaps.gr/', '_blank');
		}
		
		override public function destroy():void {
			DisplayUtils.removeAllChildren(this, true, true);
			_logo = null;
			_createForTitle = null;
			_funkytaps = null;
			_people = null;
			_alien = null;
			_closeButton = null;
		}
		
		override public function tweenIn():void {
			alpha = 0;
			TweenLite.to(this, 0.75, {alpha:1, scaleX: 1, scaleY: 1});
		}
		
		override public function tweenOut(onComplete:Function=null, onCompleteParams:Array=null):void {
			TweenLite.to(this, 0.35, { 
				alpha:0, 
				onComplete:onComplete,
				onCompleteParams:onCompleteParams
			});
		}

	}
}