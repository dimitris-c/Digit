package com.dimmdesign.utils
{
	import flash.net.LocalConnection;
	import flash.system.Capabilities;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class Enviroment
	{
		public function Enviroment()
		{
		}
		
		/**
		 * The preview domain to be check. 
		 */		
		public static var previewDomain:String = "";
		
		public static function get IS_IN_BROWSER ():Boolean {
			return (Capabilities.playerType == "Plugin" || Capabilities.playerType == "ActiveX");
		}
		
		private static function get DOMAIN():String { 
			return new LocalConnection().domain;
		}
		
		public static function IS_DOMAIN(domain:String):Boolean {
			return (DOMAIN == domain)
		}
		
		public static function IS_PREVIEW(domain:String):Boolean {
			if (domain) previewDomain = domain;
			return (DOMAIN == previewDomain);
		}
		
		public static function get IS_LOCAL():Boolean {
			return (DOMAIN == "localhost" || DOMAIN == "ogilvyone");
		}
		
	}
}