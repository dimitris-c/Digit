package com.dimmdesign.managers.facebook.vo
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class FacebookPostObject extends Object
	{
		private var _name:String;
		private var _message:String;
		
		private var _link:String;
		private var _picture:String;
		
		private var _caption:String;
		private var _description:String;
		
		private var _image:String;
		
		public var access_token:String;
		
		//message		Post message			string	 yes
		//link			Post URL				string	 yes
		//picture		Post thumbnail image	string	 no
		//name			Post name				string	 no
		//caption		Post caption			string	 no
		//description	Post description		string	 no
		
		public function FacebookPostObject()
		{
			super();
		}

		/**
		 * Post name
		 */		
		public function set name(value:String):void { _name = value; }
		public function get name():String { return _name; }
		
		/**
		 * Post message
		 */	
		public function set message(value:String):void { _message = value; }
		public function get message():String { return _message; }
		
		/**
		 * Post URL
		 */
		public function set link(value:String):void { _link = value; }
		public function get link():String { return _link; }

		/**
		 * Post thumbnail image
		 */
		public function set picture(value:String):void { _picture = value; }
		public function get picture():String { return _picture; }

		/**
		 * Post caption
		 */		
		public function set caption(value:String):void { _caption = value; }
		public function get caption():String { return _caption; }
		
		/**
		 * Post description
		 */	
		public function set description(value:String):void { _description = value; }
		public function get description():String { return _description; }

		/**
		 * Deprecated?
		 */		
		public function set image(value:String):void { _image = value; }
		public function get image():String { return _image; }

	}
}