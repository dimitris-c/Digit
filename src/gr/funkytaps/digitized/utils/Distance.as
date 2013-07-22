package gr.funkytaps.digitized.utils
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class Distance
	{
	
		/**
		 * Inline function for fast calculation of distance. The number to be checked against should be multiplied by itself
		 * Returns the distance from the passed points. 
		 */		
		[Inline]
		public static function calculate(x1:Number, x2:Number, y1:Number, y2:Number):Number {
			return ((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2));
		}
	}
}