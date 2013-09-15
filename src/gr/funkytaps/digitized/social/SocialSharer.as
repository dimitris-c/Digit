package gr.funkytaps.digitized.social
{
	import com.freshplanet.ane.AirFacebook.Facebook;
	
	import flash.events.StatusEvent;
	
	import gr.funkytaps.digitized.views.ShareView;
	
	import starling.events.Event;
	
	public class SocialSharer
	{
		private static const APP_ID:String = "161144934081575";
		private static const PERMISSIONS:Array = ["email", "user_about_me", "user_birthday", "user_hometown", "user_website", "offline_access", "read_stream", "publish_stream", "read_friendlists"];
		
		private var _facebook:Facebook;
		
		private var _event:Event;
		private var _view:ShareView;
		
		public function SocialSharer(view:ShareView)
		{
			_view = view;
			_init();
		}
		
		private function _init():void{
			trace('facebook.isSupported:', Facebook.isSupported);
			if(Facebook.isSupported)
			{
				_facebook = Facebook.getInstance();
				_facebook.addEventListener(StatusEvent.STATUS, handler_status);
				_facebook.init(APP_ID);
				trace("isSeesionOpen:", _facebook.isSessionOpen);
				if(_facebook.isSessionOpen)
				{
					//loginSuccess();
				}
				else{
					//_facebook.openSessionWithPermissions(PERMISSIONS, handler_openSessionWithPermissions);
				
				}
			}
		}
		
		
		
		protected function handler_status($evt:StatusEvent):void
		{
			trace("statusEvent,type:", $evt.type,",code:", $evt.code,",level:", $evt.level);
			if(_facebook.isSessionOpen)
			{
				//loginSuccess();
			}
			else{
				//_facebook.openSessionWithPermissions(PERMISSIONS, handler_openSessionWithPermissions);
			}
		}
		
		private function handler_openSessionWithPermissions($success:Boolean, $userCancelled:Boolean, $error:String = null):void
		{
			if($success)
			{
				//loginSuccess();
				shareFB(_event);
			}
			else{
				_view.completeWithFail();
			}
			trace("success:", $success, ",userCancelled:", $userCancelled, ",error:", $error);
		}
		
		public function shareFB(e:Event):void{
			
			if(_facebook.isSessionOpen){
				var params:Object = {   
					message: "Test Message",
					link: 'http://www.google.gr',
					caption: 'Test Caption',
					name: 'Text Name',
					description: 'Test escription'
				};
				_facebook.requestWithGraphPath("/me/feed", params, "POST", handler_requesetWithGraphPath);
				//_facebook.requestWithGraphPath("/me", null, "GET", handler_requesetWithGraphPath);			
			}
			
		}
		
		public function openSession(e:Event):void{
			_event = e;
			if(_facebook.isSessionOpen){
				shareFB(e);
			}
			else{
				_facebook.openSessionWithPermissions(PERMISSIONS, handler_openSessionWithPermissions);			
			}
		}
		
		private function handler_requesetWithGraphPath($data:Object):void
		{
			trace("handler_requesetWithGraphPath:", JSON.stringify($data));
			_view.completeWithSuccess();
		}
	}
}