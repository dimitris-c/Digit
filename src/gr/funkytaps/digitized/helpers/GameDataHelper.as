package gr.funkytaps.digitized.helpers
{
	import flash.net.SharedObject;

	public class GameDataHelper
	{
		public static var so:SharedObject = SharedObject.getLocal('Digit');
		
		public static function saveUser(user_uid:String, name:String, email:String, highScore:String):void{
			so.data['user_uid'] = user_uid;
			so.data['name'] = name;
			so.data['email'] = email;
			so.data['highScore'] = highScore;
			so.flush();
			trace("Saved user with uid: " + so.data['user_uid']);
		}
			
		public static function getUser():Object{
			
			var user:Object = new Object;
			user["user_uid"] = so.data['user_uid'];
			user["name"] = so.data['name'];
			user["email"] = so.data['email'];
			user["highScore"] = so.data['highScore'];
			return user;
		}
		
		public static function saveHighScore(highScore:String):void{
			so.data['highScore'] = highScore;
			so.flush();
			trace("Saved high score: " + so.data['highScore']);
		}
		
		public static function getHighScore():String{
			return so.data['highScore'];
			//if null then it's the first time
		}
		
		public static function setAudioPreferences(isOn:Boolean):void {
			so.data["audioprefs"] = isOn;
			so.flush();
			trace("Audio is", (isOn) ? "on" : "off");
		}
		
		public static function getAudioPreferences():Boolean {
			var isOn:Boolean = so.data["audioprefs"];
			return isOn;
		}
		
	}
}