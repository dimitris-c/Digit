package gr.funkytaps.digitized.views
{
	import com.sticksports.nativeExtensions.social.Social;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.events.ShareEvent;
	import gr.funkytaps.digitized.events.ViewEvent;
	import gr.funkytaps.digitized.helpers.GameDataHelper;
	import gr.funkytaps.digitized.social.ShareriOS6;
	import gr.funkytaps.digitized.social.SocialSharer;
	import gr.funkytaps.digitized.ui.buttons.CloseLeaderBoardViewButton;
	
	import pl.mateuszmackowiak.nativeANE.notifications.Toast;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;

	public class ShareView extends AbstractView
	{
		private var _closeButton:CloseLeaderBoardViewButton;
		
		private var _background:Image;
		
		private var _iOS6Sharer:ShareriOS6;
		private var _socialSharer:SocialSharer;
		
		private var _message:String;
		private var _url:String = "http://www.digitized.gr";
		
		//TODO add tw, fb buttons
		private var _btnFB:Button;
		private var _btnTW:Button;
		
		public function ShareView()
		{
			//TODO add share message here from concatenating with the stored score - 
			//DIMM CHECK IT
			_message = "My score on digit: " + GameDataHelper.getHighScore();
			super();
		}
		
		override protected function _init():void {
			_background = new Image( Assets.manager.getTexture('generic-background') );
			addChild(_background);
			
			_closeButton = new CloseLeaderBoardViewButton();
			_closeButton.x = 10;
			_closeButton.y = 10;
			_closeButton.addEventListener(Event.TRIGGERED, _onCloseButtonTriggered);
			addChild(_closeButton);
			
			_btnFB = new Button(Assets.manager.getTexture('green-button-normal'), "FB");
			addChild(_btnFB);

			_btnTW = new Button(Assets.manager.getTexture('green-button-normal'), "TW");
			addChild(_btnTW);
			
			_btnFB.y = 50;
			
			_btnTW.y = _btnFB.y + _btnFB.height + 10;
			
			//TODO remove
			//Settings.isiOS = false;
			/*var isIOS6:Boolean = true;
			
			if(Settings.isiOS){
				if(isIOS6){
					_iOSSharer = new ShareriOS6(this, _message, _url);
					_btnFB.addEventListener(Event.TRIGGERED, _iOSSharer.launchFBUI);
					_btnTW.addEventListener(Event.TRIGGERED, _iOSSharer.launchTweetUI);			
				}
				else{
					removeChild(_btnTW);
					_btnTW = null;
					_socialSharer = new SocialSharer(this);
					_btnFB.addEventListener(Event.TRIGGERED, _socialSharer.openSession);
				}
			}
			else{
				removeChild(_btnTW);
				_btnTW = null;
				_socialSharer = new SocialSharer(this);
				_btnFB.addEventListener(Event.TRIGGERED, _socialSharer.openSession);
			}*/
			if(Social.isSupported){
				_iOS6Sharer = new ShareriOS6(this, _message, _url);
				_btnFB.addEventListener(Event.TRIGGERED, _iOS6Sharer.launchFBUI);
				_btnTW.addEventListener(Event.TRIGGERED, _iOS6Sharer.launchTweetUI);			
			}
			else{
				removeChild(_btnTW);
				_btnTW = null;
				_socialSharer = new SocialSharer(this);
				_btnFB.addEventListener(Event.TRIGGERED, _socialSharer.openSession);
			}
		}
		
		private function _onCloseButtonTriggered(event:Event = null):void{
			dispatchEvent(new ViewEvent(ViewEvent.DESTROY_VIEW));
			//this.removeFromParent(true);
		}
		
		public function completeWithSuccess():void{
			Toast.show("You have shared your score!",Toast.LENGTH_SHORT);
			this.dispatchEvent(new ShareEvent(ShareEvent.SHARE_COMPLETED, true));
			//_onCloseButtonTriggered();
		}

		public function completeWithFail():void{
			Toast.show("Oops, something went wrong. Please try again!",Toast.LENGTH_SHORT);
			this.dispatchEvent(new ShareEvent(ShareEvent.SHARE_FAILED, true));
			//_onCloseButtonTriggered();
		}
	}
}