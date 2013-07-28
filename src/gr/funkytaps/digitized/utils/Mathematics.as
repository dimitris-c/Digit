package gr.funkytaps.digitized.utils
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class Mathematics
	{
		[Inline]
		public static function getRandomInt(min:int, max:int):int {
			return ((Math.random() * (1 + max - min) + min) >> 0);
		}
		
		
	}
}