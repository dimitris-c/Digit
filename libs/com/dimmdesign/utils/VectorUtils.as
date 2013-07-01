package com.dimmdesign.utils
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2013 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class VectorUtils
	{
		public function VectorUtils()
		{
		}
		
		public static function toArray(vec:*):Array {
			var array:Array = new Array(vec.length);
			var i:int = 0;
			var l:int = array.length;
			for (i = 0; i < l; i++)
			{
				array[i] = vec[i];
			}
			return array;
		}
	}
}