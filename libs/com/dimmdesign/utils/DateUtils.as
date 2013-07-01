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
	
	public class DateUtils
	{
		
		private static const englishMonths:Array = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
		private static const greekMonths:Array = ['Ιανουάριος', 'Φεβρουάριος', 'Μάρτιος', 'Απρίλιος', 'Μάιος', 'Ιούνιος', 'Ιούλιος', 'Αύγουστος', 'Σεπτέμβριος', 'Οκτώβριος', 'Νοέμβριος', 'Δεκέμβριος'];

		private static const englishDays:Array = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
		private static const greekDays:Array = ['Κυριακή', 'Δευτέρα', 'Τρίτη', 'Τετάρτη', 'Πέμπτη', 'Παρασκευή', 'Σάββατο'];
			
		/**
		 * Converts the passed number as a string, optionally selecting the languages. 
		 * @param month A number representing the month to be converted.
		 * @param lang Accepted values are — <b>en</b>,<b>english</b>,  <b>gr</b>, <b>greek</b>.
		 * @return 
		 * 
		 */			
		public static function getMonthAsString (month:uint, lang:String = 'en'):String {
			var outputMonth:String = '';
			if (lang == 'en' || lang == 'english') {
				outputMonth = englishMonths[month];
			} else if (lang == 'gr' || lang == 'greek') {
				outputMonth = greekMonths[month];
			}
			return outputMonth
		}
			
		public static function getMonthAbbreviation (month:uint, lang:String = 'en'):String {
			return DateUtils.getMonthAsString(month, lang).substr(0, 3);
		}
		
		/**
		 * Converts the passed number as a string for the day, optionally selecting the languages. 
		 * @param month A number representing the month to be converted.
		 * @param lang Accepted values are — <b>en</b>,<b>english</b>,  <b>gr</b>, <b>greek</b>.
		 * @return 
		 * 
		 */	
		public static function getDayAsString (day:uint, lang:String = 'en'):String {
			var outputDay:String = '';
			if (lang == 'en' || lang == 'english') {
				outputDay = englishDays[day];
			} else if (lang == 'gr' || lang == 'greek') {
				outputDay = greekDays[day];
			}
			return outputDay;
		}
		
		public static function getDayAbbreviation (day:uint, lang:String = 'en'):String {
			return DateUtils.getDayAsString(day, lang).substr(0, 3);			
		}
		
		
	}
}