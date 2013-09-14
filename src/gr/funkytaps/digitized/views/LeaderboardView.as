package gr.funkytaps.digitized.views
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import com.greensock.TweenLite;
	
	import flash.net.URLVariables;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.helpers.GameDataHelper;
	import gr.funkytaps.digitized.helpers.POSTRequestHelper;
	import gr.funkytaps.digitized.ui.buttons.CloseLeaderBoardViewButton;
	import gr.funkytaps.digitized.ui.buttons.LeaderboardButton;
	import gr.funkytaps.digitized.ui.buttons.MenuButton;
	import gr.funkytaps.digitized.ui.buttons.RegisterButton;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class LeaderboardView extends AbstractView
	{
	
		private var _closeButton:CloseLeaderBoardViewButton;
		
		private var _background:Image;
		private var _gradient:Quad;
		private var _title:Image;
		
		private var postHelper:POSTRequestHelper;
		
		private var _displayedOnUserDemand:Boolean;
		private var _highScore:String;
		
		private var _registerButton:RegisterButton;
		private var _registerPanel:RegisterPanel;
		
		public function LeaderboardView(displayedOnUserDemand:Boolean, highScore:String)
		{
			_displayedOnUserDemand = displayedOnUserDemand;
			_highScore = highScore;
			super();
		}
		/*
		WHEN THE GAME ENDS 
		The leaderboard opens and the high score list is populated (see below). 
			if it’s the first time
		A button is visible and asks the user to register and send the socre
		the user sees an “enter name and email” panel
		The user fills the details and presses next
		The score is sent to the server along with the details and saved locally too
		if it’s NOT the first time
		The score is sent to the server ONLY if it’s greater than the user’s personal high score
		
		WHEN THE LEADERBOARD LOADS 
		App requests list of high scores and the user’s personal high score if it exists (not the first time) 
		If it’s after the game ended
		(see above)    
		If it’s NOT after the game ended (on user’s demand)
		the list of high scores and the user’s personal high score is visible

		*/
		
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
			addChild(_gradient);
			
			_closeButton = new CloseLeaderBoardViewButton();
			_closeButton.x = 10;
			_closeButton.y = 10;
			_closeButton.addEventListener(Event.TRIGGERED, _onCloseButtonTriggered);
			addChild(_closeButton);
			
			_title = new Image(Assets.manager.getTexture('leadboard-title'));
			_title.x = (Settings.HALF_WIDTH - (_title.width >> 1)) | 0;
			_title.y = 30;
			addChild(_title);
			
			_createRegisterButton();
			
			_initPOST();
		}
		
		private function _onCloseButtonTriggered(event:Event ):void{
			this.removeFromParent(true);
		}
		
		private function _initPOST():void{
			postHelper = new POSTRequestHelper();
			postHelper.addEventListener(POSTRequestHelper.POST_INITIALIZED, _onInit);
			
			postHelper.init(POSTRequestHelper.ACTION_REQUEST_TOP_TEN);
			
		}
		
		private function _onInit(e:Event):void {
			postHelper.removeEventListener(POSTRequestHelper.POST_INITIALIZED, _onInit);
			_getTop10();
		}
		
		private function _getTop10():void{
			//
			var user:Object = GameDataHelper.getUser();
			trace("-----------------------");
			trace("user is type: ", user);
			trace("user_uid:", user["user_uid"]);
			trace("name:", user["name"]);
			trace("email:", user["email"]);
			trace("high score:", user["highScore"]);
			trace("-----------------------");
			
			if(user && user["user_uid"]){
				var uid:String;
				uid = user["user_uid"];
				//uid = "101";
				var params:URLVariables = new URLVariables();
				params.user_uid = uid;
				postHelper.requestTopTen(_requestTop10ResponseHandler, params);
			}
			else{
				postHelper.requestTopTen(_requestTop10ResponseHandler, null);
			}
		}
		
		private function _requestTop10ResponseHandler(data:Object):void{
			var topTen:Array = data["top_ten"] as Array;
			trace("top 10 length is:", topTen.length);
			var user:Object = data["user"];
			if(user){			
				trace("user found: " + user["user_uid"] + " high score is: " + user["high_score"]);
				if(data["userIndex"] && data["userIndex"] > 4){				
					user["userIndex"] = data["userIndex"];
				}
				else{
					user["userIndex"] = -1;
				}
			}
			else{
				trace("No user found, it's first time");
			}

			if(_displayedOnUserDemand){
				//clicked on menu, display list
				_displayList(topTen, user);
			}
			else{
				//after game ended
				if(user != null){
					//not first time, display list
					_displayList(topTen, user);
				}
				else{
					//is first time, display list and register
					_displayList(topTen, null);
				}
			}
		}
		
		private function _displayList(topTen:Array, user:Object):void{
			//TODO remove
			//_createRegisterButton();
			
			if(user){
				//we check to see if it exists inside the top 10
				var userInTop10:Boolean = false;
				for(var i:int = 0; i<topTen.length; i++){
					if(topTen[i]["user_uid"] == user["user_uid"]){
						topTen[i]["userIndex"] = user["userIndex"];
						userInTop10 = true;
						break;
					}
				}
				if(userInTop10){
					//if YES
					//display the top 10 normallly - the user's score will be in top 10
					_createTop10(topTen);
				}
				else{
					//if NO
					//display top 10 and at the bottom display the user's high score - Meybe animate it???
					//replace the 5th entry with the user's entry
					topTen[4] = user;
					_createTop10(topTen);					
				}
			}
			else{
				//display the top 10 normallly
				_createTop10(topTen);
				
				//display register button
				if(!_displayedOnUserDemand){	
					//show register button
					addChild(_registerButton);
					//_createRegisterButton();
				}
					//onClick REGISTER button: show panel with email, name fields and a submit button
					//onClick SUBMIT button: send to server name, email and score
					//get user_uid from response and save it locally
			}
			
		}
		
		//Scores  list
		private function _createTop10(entries:Array):void{
			var entry:Sprite;
			var data:Object;
			var yPos:int = _title.y + _title.height;
			var padding:int = 0;
			for(var i:int = 0; i<entries.length; i++){
				
				data = entries[i];
				
				if(i == 4){
					if(data["userIndex"] && data["userIndex"] != -1){
						entry = _createEntry(data, data["userIndex"]+1);
					}
					else{
						entry = _createEntry(data, i+1);
					}
				}
				else{				
					entry = _createEntry(data, i+1);
				}
				
				
				if(_registerButton){
					entry.x = _registerButton.x;
				}
				
				entry.y = yPos;
				yPos += entry.height + padding;
				
				addChild(entry);
			}
		}
		
		private function _createEntry(data:Object, orderNumber:int):Sprite{
			trace("Creating entry:", data["name"], ":", data["high_score"]);
			//var entry:TextField = new TextField(110, 36, data["name"], Settings.AGORA_FONT_88, -1, 0xffffff);
			var entry:Sprite = new Sprite();
			var width:int = Settings.WIDTH - (2*_registerButton.x) - 20;
			
			var indexField:TextField = new TextField(width, 30, orderNumber.toString(), Settings.AGORA_FONT_38, -1, 0xffffff);
			indexField.autoScale = true;
			indexField.batchable = true;
			indexField.vAlign = VAlign.TOP;
			indexField.hAlign = HAlign.LEFT;
			
			var name:TextField = new TextField(width, 30, data["name"], Settings.AGORA_FONT_NAME80, -1, 0xffffff);
			name.autoScale = true;
			name.batchable = true;
			name.vAlign = VAlign.TOP;
			name.hAlign = HAlign.LEFT;
			
			var score:TextField = new TextField(width, 35, data["high_score"] + " Points", Settings.AGORA_FONT_POINTS50, -1, 0xffffff);
			score.autoScale = true;
			score.batchable = true;
			score.vAlign = VAlign.TOP;
			score.hAlign = HAlign.LEFT;

			var line:Quad = new Quad(width+20, 1, 0x5c5f9a);
			
			//indexField.border = true;
			//name.border = true;
			//score.border = true;
			
			score.y = name.height - 10;
			
			name.x = score.x = 20;
			indexField.y = (score.y + score.height)*0.5 - indexField.height*0.5;

			line.x = 0;
			line.y = score.y + score.height;
			
			entry.addChild(name);
			entry.addChild(score);
			entry.addChild(indexField);
			entry.addChild(line);
			
			
			return entry;
		}
		
		//Register button
		private function _createRegisterButton():void{
			_registerButton = new RegisterButton();
			_registerButton.addEventListener(Event.TRIGGERED, _onRegisterButtonTriggered);
			addChild(_registerButton);
			_registerButton.x = (Settings.HALF_WIDTH - (_registerButton.width >> 1)) | 0;
			_registerButton.y = Settings.HEIGHT - _registerButton.height - _registerButton.x;
			removeChild(_registerButton);
		}
		
		private function _onRegisterButtonTriggered(event:Event):void{
			_createRegisterPanel();
		}
		
		private function _createRegisterPanel():void{
			if(!_registerPanel){
				_registerPanel = new RegisterPanel(_highScore);
				_registerPanel.addEventListener(Event.REMOVED, _onRemoved);
				addChild(_registerPanel);
			}
		}
		
		private function _onRemoved(e:Event):void{
			_destroyRegisterPanel();
		}
		
		private function _destroyRegisterPanel():void{
			if(_registerPanel){
				_registerPanel.removeEventListener(Event.REMOVED, _onRemoved);
				_registerPanel = null;
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