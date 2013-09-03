package gr.funkytaps.digitized.views
{
	import com.adobe.utils.StringUtil;
	import com.dimmdesign.utils.StringUtils;
	import com.greensock.TweenLite;
	
	import flash.globalization.StringTools;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.utils.StringUtil;
	
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.helpers.GameDataHelper;
	import gr.funkytaps.digitized.helpers.POSTRequestHelper;
	import gr.funkytaps.digitized.ui.buttons.MenuButton;
	import gr.funkytaps.digitized.ui.buttons.PlayAgainButton;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;

	public class RegisterPanel extends AbstractView
	{
		private var _background:Quad;
		private var _gradient:Quad;
		
		private var postHelper:POSTRequestHelper;
		
		private var _txtName:TextField;
		private var _txtEmail:TextField;
		private var _score:String;
		
		//TODO repalce this with a close button
		private var _closeButton:MenuButton;
		
		//TODO add a SubmitButton here
		private var _submitButton:PlayAgainButton;
		
		public function RegisterPanel(score:String)
		{
			_score = score;
			super();
		}
		
		override protected function _init():void {
			_background = new Quad(300, 400, 0xff0000);
			_background.alpha = 1.0;
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
			addChild(_gradient);
			
			_closeButton = new MenuButton();
			_closeButton.addEventListener(Event.TRIGGERED, _onCloseButtonTriggered);
			addChild(_closeButton);
			

			var textFormat:TextFormat = new TextFormat("Arial", 24, 0x000000);
			textFormat.align = TextFormatAlign.LEFT;
			
			_txtName = new TextField();
			_txtName.width = 200;
			_txtName.height = 40;
			_txtName.defaultTextFormat = textFormat;
			_txtName.type = TextFieldType.INPUT;
			//_txtName.autoSize = TextFieldAutoSize.LEFT;
			_txtName.background = true;
			_txtName.backgroundColor = 0xffffff;
			_txtName.x = 0;
			_txtName.y = _closeButton.y + _closeButton.height + 5;
			Starling.current.nativeOverlay.addChild(_txtName);
			
			_txtEmail = new TextField();
			_txtEmail.width = 200;
			_txtEmail.height = 40;
			_txtEmail.defaultTextFormat = textFormat;
			_txtEmail.type = TextFieldType.INPUT;
			//_txtEmail.autoSize = TextFieldAutoSize.LEFT;
			_txtEmail.background = true;
			_txtEmail.backgroundColor = 0xffffff;
			_txtEmail.x = 0;
			_txtEmail.y = _txtName.y + _txtName.height + 5;
			Starling.current.nativeOverlay.addChild(_txtEmail);

			_submitButton = new PlayAgainButton();
			_submitButton.addEventListener(Event.TRIGGERED, _onSubmitButtonTriggered);
			addChild(_submitButton);
			_submitButton.y = _txtEmail.y + _txtEmail.height + 5;;
		}
		
		private function _onCloseButtonTriggered(event:Event ):void{
			this.removeFromParent(true);
		}
		
		private function _onSubmitButtonTriggered(event:Event):void{
			_initPOST();
		}
		
		private function _initPOST():void{
			postHelper = new POSTRequestHelper();
			postHelper.addEventListener(POSTRequestHelper.POST_INITIALIZED, _onInit);
			
			postHelper.init(POSTRequestHelper.ACTION_SAVE_HIGH_SCORE);
		}
		
		private function _onInit(e:Event):void {
			postHelper.removeEventListener(POSTRequestHelper.POST_INITIALIZED, _onInit);
			_registerAndSaveHighScore();
		}
		
		private function _registerAndSaveHighScore():void{
			//TODO check if empty
			if(_txtName.text == "" && _txtEmail.text == ""){
				trace("Fill all details");
				return;
			}
			
			var params:URLVariables = new URLVariables();
			params.name = _txtName.text;
			params.email = _txtEmail.text;
			params.high_score = _score;			
			postHelper.saveHighScore(_registerAndSaveHighScoreResponseHandler, params);
		}
		
		private function _registerAndSaveHighScoreResponseHandler(data:Object):void{
			if(data && data["success"]){
				if(data["success"] == "1"){
					//store locally the user_uid, name, email, high score returned from server
					var user:Object = data["user"];
					trace(user);
					GameDataHelper.saveUser(user["user_uid"], user["name"], user["email"], user["high_score"]); 
					_destroy();
					this.removeFromParent(true);
				}
				else{
					//error
				}
			}
			else{
				//error
			}
		}
		
		private function _destroy():void{
			if(postHelper){
				postHelper.removeEventListener(POSTRequestHelper.POST_INITIALIZED, _onInit);
				postHelper = null;
			}
			
		}
		
		//Tween view methods
		override public function tweenIn():void {
			
			//_soundButton.isToggled = !(GlobalSound.volume == 0);
			//			y = Settings.HEIGHT;
			//			TweenLite.to(this, 0.75, {y:0});
			alpha = 0;
			TweenLite.to(this, 0.75, {alpha:1, scaleX: 1, scaleY: 1});
		}
		
		override public function tweenOut(onComplete:Function=null, onCompleteParams:Array=null):void {
			//			TweenLite.to(this, 0.55, {y:Settings.HEIGHT, onComplete:onComplete, onCompleteParams:onCompleteParams});
			TweenLite.to(this, 0.35, { 
				alpha:0, 
				onComplete:onComplete,
				onCompleteParams:onCompleteParams
			});
		}
		
	}
}