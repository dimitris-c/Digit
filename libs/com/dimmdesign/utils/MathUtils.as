package com.dimmdesign.utils
{
	public class MathUtils
	{
					
		public static function getRandomNumber (min:Number, max:Number):Number {
			return min + (Math.random() * (min - max));
		}
		
		public static function getRandomInt(min:Number, max:Number):int{
			min = Math.ceil(min);
			max = Math.floor(max);
			return min + Math.floor(Math.random() * (max + 1 - min));
		}
			
		public static function getDistance (currentX:Number, currentY:Number, finalX:Number, finalY:Number):Number {
			var dx:Number = currentX-finalX;
			var dy:Number = currentY-finalY;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * Fast math round. Alternative to Math.round();  
		 * @param number The number to be rounded
		 * @return A rounded number
		 * 
		 */		
		public static function round (number:Number):Number {
			return number | 0.5;
		}
		
		/**
		 * Checks if the number is odd. 
		 * @param number The number to be checked. 
		 * @return True if the number is odd otherwise false
		 * 
		 */		
		public static function isOdd (number:Number):Boolean {
			return (number % 2) == 0;
		}
		/**
		 * Checks if the number is even. 
		 * @param number The number to be checked. 
		 * @return True if the number is even otherwise false
		 * 
		 */
		public static function isEven (number:Number):Boolean {
			return !MathUtils.isOdd(number);
		}
		
		/* More math function to be added */
		
	}
}