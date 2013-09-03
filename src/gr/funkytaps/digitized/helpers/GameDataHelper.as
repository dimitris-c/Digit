package gr.funkytaps.digitized.helpers
{
	import flash.net.SharedObject;

	public class GameDataHelper
	{
		public static function saveUser(user_uid:String, name:String, email:String, highScore:String):void{
			var so:SharedObject = SharedObject.getLocal("Digit");
			so.data['user_uid'] = user_uid;
			so.data['name'] = name;
			so.data['email'] = email;
			so.data['highScore'] = highScore;
			so.flush();
			trace("Saved user with uid: " + so.data['user_uid']);
		}
			
		public static function getUser():Object{
			var so:SharedObject = SharedObject.getLocal("Digit");
			var user:Object = new Object;
			user["user_uid"] = so.data['user_uid'];
			user["name"] = so.data['name'];
			user["email"] = so.data['email'];
			user["highScore"] = so.data['highScore'];
			return user;
		}
		
		public static function saveHighScore(highScore:String):void{
			var so:SharedObject = SharedObject.getLocal("Digit");
			so.data['highScore'] = highScore;
			so.flush();
			trace("Saved high score: " + so.data['highScore']);
		}
		
		public static function getHighScore():String{
			var so:SharedObject = SharedObject.getLocal("Digit");
			return so.data['highScore'];
			//if null then it's the first time
		}
	}
}