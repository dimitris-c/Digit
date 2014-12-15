package gr.funkytaps.digitized.views
{
	import com.dimmdesign.utils.Web;
	import com.greensock.TweenLite;
	import com.milkmangames.nativeextensions.GVHttpMethod;
	import com.milkmangames.nativeextensions.GoViral;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.events.ShareEvent;
	import gr.funkytaps.digitized.events.ViewEvent;
	import gr.funkytaps.digitized.helpers.GameDataHelper;
	import gr.funkytaps.digitized.ui.buttons.BackButton;
	import gr.funkytaps.digitized.ui.buttons.BaseButton;
	import gr.funkytaps.digitized.utils.StringUtils;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class ShareView extends AbstractView
	{
		private var _closeButton:BackButton;
		
		private var _background:Quad;
		
		private var _message:String;
		private var _url:String = "http://www.digitized.gr";
		
		private var _shareTitle:Image;
		private var _totalScoreTextfield:TextField;
		private var _totalScore:Number;
		
		//TODO add tw, fb buttons
		private var _facebookButton:BaseButton;
		private var _twitterButton:BaseButton;
		
		public function ShareView()
		{
			super();
		}
		
		override protected function _init():void {
			_background = new Quad(Settings.WIDTH, Settings.HEIGHT, stage.color);
			_background.alpha = 0.97;
			addChild(_background);
			
			_closeButton = new BackButton();
			_closeButton.x = 10;
			_closeButton.y = 10;
			_closeButton.addEventListener(Event.TRIGGERED, _onCloseButtonTriggered);
			addChild(_closeButton);
			
			_shareTitle = new Image( Assets.manager.getTexture('share-title'));
			_shareTitle.x = Settings.HALF_WIDTH - (_shareTitle.width >> 1);
			_shareTitle.y = 37;
			addChild(_shareTitle);
			
			_totalScore = Number(GameDataHelper.getHighScore());
			
			_totalScoreTextfield = new TextField(300, 56, StringUtils.formatNumber(_totalScore), Settings.AGORA_FONT_88, -1, 0xFFFFFF);
			_totalScoreTextfield.batchable = true;
			_totalScoreTextfield.autoScale = true;
			_totalScoreTextfield.vAlign = VAlign.TOP;
			_totalScoreTextfield.hAlign = HAlign.CENTER;
			addChild(_totalScoreTextfield);
			
			_totalScoreTextfield.x = (Settings.HALF_WIDTH - (_totalScoreTextfield.width >> 1) - 8) | 0;
			_totalScoreTextfield.y = _shareTitle.y + _shareTitle.height - 10;
			
			_facebookButton = new BaseButton(Assets.manager.getTexture('fb-share-button-normal'), Assets.manager.getTexture('fb-share-button-hover'));
			_facebookButton.addEventListener(Event.TRIGGERED, _handleFacebookButtonClick)
			addChild(_facebookButton);

			_twitterButton = new BaseButton(Assets.manager.getTexture('twitter-share-button-normal'), Assets.manager.getTexture('twitter-share-button-hover'));
			_twitterButton.addEventListener(Event.TRIGGERED, _handleTwitterButtonClick)
			addChild(_twitterButton);
			
			_facebookButton.x = Settings.HALF_WIDTH - (_facebookButton.width >> 1);
			_facebookButton.y = 170;
			
			_twitterButton.x = Settings.HALF_WIDTH - (_twitterButton.width >> 1);
			_twitterButton.y = _facebookButton.y + _facebookButton.height + 20;
		}
		
		private function _handleTwitterButtonClick():void
		{
			var score:Number = Number(GameDataHelper.getHighScore())
			var formatedScore:String = StringUtils.formatNumber( score );
			var twitterMessage:String = "I downloaded Digitized and reached a new high score of " + formatedScore + "pts! Help Digit get home! www.digitized.gr #digitized13";
			
			if (GoViral.goViral.isTweetSheetAvailable()) {
				GoViral.goViral.showTweetSheet(twitterMessage);
			} 
			else {
				Web.getURL('https://twitter.com/intent/tweet?text=' + twitterMessage, '_blank');
			}
		}
		
		private function _handleFacebookButtonClick(event:Event):void
		{
			// Facebook has not been authenticated
			if (!GoViral.goViral.isFacebookAuthenticated()) {
				trace('facebook has not been authenticated, logging in now');
				GoViral.goViral.authenticateWithFacebook("basic_info");
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN, _onGVFacebookLoggedIn);
				GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED, _onGVFacebookLoginCancelled)
			}
			else {
				// continue with the post
				_shareScoreOnFacebook();
			}
			
		}
		
		protected function _onGVFacebookLoginCancelled(event:GVFacebookEvent):void
		{
			trace('login cancelled');
		}
		
		protected function _onGVFacebookLoggedIn(event:GVFacebookEvent):void
		{
			// TODO Auto-generated method stub
			trace('user logged in');
			// continue with the post
			_shareScoreOnFacebook();
		}
		
		private function _shareScoreOnFacebook():void {
			
			var score:Number = Number(GameDataHelper.getHighScore());
			var formatedScore:String = StringUtils.formatNumber( score );
			var caption:String = "Digitized Game";//"I just got a new high score (" + formatedScore + "pts) on Digitized!";
			var description:String = "I just hit a new high score on Digitized (" + formatedScore +"pts). Help me help Digit get home! Visit www.digitized.gr and download the mobile app!"
			
			GoViral.goViral.showFacebookFeedDialog("Help Digit get home!", caption, "", description, "http://www.digitized.gr", "http://www.digitized.gr/game/facebook/200x200.png");
						
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FINISHED, _onShareScoreCompleted);
			
		}
		
		protected function _onShareScoreCompleted(event:GVFacebookEvent):void
		{
			// TODO Auto-generated method stub
			this.dispatchEvent(new ShareEvent(ShareEvent.SHARE_COMPLETED, true));
		}
		
		private function _onCloseButtonTriggered(event:Event = null):void{
			this.dispatchEvent(new ViewEvent(ViewEvent.DESTROY_VIEW));
			//this.removeFromParent(true);
		}
		
		public function completeWithSuccess():void{
			
			//_onCloseButtonTriggered();
		}

		public function completeWithFail():void{
			this.dispatchEvent(new ShareEvent(ShareEvent.SHARE_FAILED, true));
			//_onCloseButtonTriggered();
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