package com.dimmdesign.utils
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	
	public class ValidationUtil
	{
		
		/**
		 * Checks if the passed value is an email or not. 
		 * @param email - The text to be checked.
		 * @return - True if the the email is correct.
		 * 
		 */		
		public static function isEmail (email:String):Boolean {
			const pattern:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
			return email.match(pattern) != null;			
		}
		
		/**
		 * Checks if the passed value is a greek mobile number.
		 * @param number The text to be checked
		 * @return - True if the number is correct.
		 * 
		 */		
		public static function isGreekMobileNumber (number:String):Boolean  {
			const pattern:RegExp = /^69\d{8}$/;
			return number.match(pattern) != null;
		}
		
		
	}
}