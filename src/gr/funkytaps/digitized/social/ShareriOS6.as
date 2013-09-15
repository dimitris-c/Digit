package gr.funkytaps.digitized.social
{
	import com.adobe.ane.social.SocialServiceType;
	import com.adobe.ane.social.SocialUI;
	import com.sticksports.nativeExtensions.social.Social;
	import com.sticksports.nativeExtensions.social.SocialEvent;
	import com.sticksports.nativeExtensions.social.SocialService;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.StatusEvent;
	
	import gr.funkytaps.digitized.views.ShareView;
	
	import pl.mateuszmackowiak.nativeANE.notifications.Toast;

	public class ShareriOS6
	{
		//protected var apiSupportedLabel:TextField = new TextField();
		//protected var msgLabel:TextField = new TextField();
		//protected var urlLabel:TextField = new TextField();
		
		//protected var apiSupportedField:TextField = new TextField();
		//protected var msgField:TextField = new TextField();
		//protected var urlField:TextField = new TextField();
		
		//protected var fbButton:Sprite =  new Sprite();
		//protected var tweetButton:Sprite = new Sprite();
		//protected var swButton:Sprite =  new Sprite();
		private var _view:ShareView;
		//protected var sUI:SocialUI;
		protected var _social:Social;
		
		//protected var msgFlag:Boolean;
		//protected var urlFlag:Boolean;
		
		private var _message:String;
		private var _url:String;
		
		public function ShareriOS6(view:ShareView, message:String, url:String)
		{
			_view = view;
			_message = message;
			_url = url;
		}
		
		public function launchFBUI():void
		{
			if(Social.isAvailableForService(SocialService.facebook)){				
				_social = new Social(SocialService.facebook);
				_social.addEventListener(SocialEvent.COMPLETE, _onComplete);
				_social.addEventListener(SocialEvent.CANCELLED, _onCancel);
				_social.setMessage(_message);
				_social.addUrl(_url);
				_social.launch();
			}
			else{
				Toast.show("Facebook share is not supported!", Toast.LENGTH_SHORT);
			}
		}
		
		public function launchTweetUI():void
		{
			if(Social.isAvailableForService(SocialService.twitter)){				
				_social = new Social(SocialService.twitter);
				_social.addEventListener(SocialEvent.COMPLETE, _onComplete);
				_social.addEventListener(SocialEvent.CANCELLED, _onCancel);
				_social.setMessage(_message);
				_social.addUrl(_url);
				_social.launch();
			}
			else{
				Toast.show("Twitter share is not supported!", Toast.LENGTH_SHORT);
			}
		}

		private function _onComplete(e:Event):void{
			trace(e);
			_view.completeWithSuccess();
		}
		
		private function _onCancel(e:Event):void{
			trace(e);
			//user cancelled do nothing
		}
		
	}
}