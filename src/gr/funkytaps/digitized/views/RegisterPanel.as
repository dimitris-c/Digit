package gr.funkytaps.digitized.views
{
	import com.dimmdesign.utils.ValidationUtil;
	import com.greensock.TweenLite;
	
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.events.ViewEvent;
	import gr.funkytaps.digitized.helpers.GameDataHelper;
	import gr.funkytaps.digitized.helpers.POSTRequestHelper;
	import gr.funkytaps.digitized.ui.buttons.BackButton;
	import gr.funkytaps.digitized.ui.buttons.SubmitNowButton;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;

	public class RegisterPanel extends AbstractView
	{
		private var _background:Quad;
		private var _gradient:Image;
		
		private var postHelper:POSTRequestHelper;
		
		private var _txtName:TextField;
		private var _txtEmail:TextField;
		private var _score:String;
		
		private var _formBackground:Image;
		
		//TODO repalce this with a close button
		private var _closeButton:BackButton;
		
		//TODO add a SubmitButton here
		private var _submitButton:SubmitNowButton;

		private var _submitHighscoreTitle:Image;

		private var _inputName:TextInput;

		private var _inputEmail:TextInput;
		
		public function RegisterPanel(score:String)
		{
			_score = score;
			super();
		}
		
		override protected function _init():void {
			_background = new Quad(stage.stageWidth, stage.stageHeight, stage.color);
			addChild(_background);
			
			_gradient = new Image(Assets.manager.getTexture('gradient'));
			addChild(_gradient);
			
			_submitHighscoreTitle = new Image(Assets.manager.getTexture('submit-high-score-title'));
			addChild(_submitHighscoreTitle);
			_submitHighscoreTitle.x = Settings.HALF_WIDTH - (_submitHighscoreTitle.width >> 1);
			_submitHighscoreTitle.y = 55
				
			_formBackground= new Image(Assets.manager.getTexture('form-background'));
			_formBackground.x = (Settings.HALF_WIDTH - (_formBackground.width >> 1)) | 0;
			_formBackground.y = _submitHighscoreTitle.y + _submitHighscoreTitle.height + 10;
			addChild(_formBackground);
			
			_closeButton = new BackButton();
			_closeButton.x = 10;
			_closeButton.y = 10;
			_closeButton.addEventListener(Event.TRIGGERED, _onCloseButtonTriggered);
			addChild(_closeButton);
			
			_inputName = new TextInput();
			_inputName.addEventListener( FeathersEventType.ENTER, _onInputEnterHandler );
			_inputName.width = 240;
			_inputName.height = 40;
			_inputName.textEditorFactory = textEditorFactory;
			addChild(_inputName);
			
			_inputName.x = 40;
			_inputName.y = 175;
			
			_inputEmail = new TextInput();
			_inputEmail.addEventListener( FeathersEventType.ENTER, _onInputEnterHandler );
			_inputEmail.width = 240;
			_inputEmail.height = 40;
			_inputEmail.textEditorFactory = textEditorFactory;
			addChild(_inputEmail);

			_inputEmail.x = 40;
			_inputEmail.y = 275;

			_submitButton = new SubmitNowButton();
			_submitButton.addEventListener(Event.TRIGGERED, _onSubmitButtonTriggered);
			addChild(_submitButton);
			_submitButton.x = (Settings.HALF_WIDTH - (_submitButton.width >> 1)) | 0;
			_submitButton.y = _formBackground.y + _formBackground.height + 10;
		}
		
		private function _onInputEnterHandler(evt:Event):void
		{
			_onSubmitButtonTriggered(null);
		}
		
		[Inline]
		private final function textEditorFactory():ITextEditor
		{
			var editor:StageTextTextEditor = new StageTextTextEditor();
			editor.fontFamily = "Helvetica";
			editor.fontSize = 24;
			editor.color = 0x000000;
			return editor;
		}
		
		private function _onCloseButtonTriggered(event:Event ):void{
//			Starling.current.nativeOverlay.removeChild(_txtName);
//			Starling.current.nativeOverlay.removeChild(_txtEmail);
			dispatchEvent(new ViewEvent(ViewEvent.DESTROY_VIEW));
			//this.removeFromParent(true);
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
			if(_inputName.text == "" || _inputEmail.text == ""){
				trace("Fill all details");
				return;
			}
			
			var params:URLVariables = new URLVariables();
			params.name = _inputName.text;
			params.email = _inputEmail.text;
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
					dispatchEvent(new ViewEvent(ViewEvent.DESTROY_VIEW));
					//this.removeFromParent(true);
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