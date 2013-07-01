package com.dimmdesign.utils
{
	
	public class ArrayUtils
	{
		/**
		 * Shuffles the elements of the given Array. 
		 * @param $array The Array to be shuffled.
		 * @return A shuffled array.
		 * 
		 */		
		public static function shuffle($array:Array):Array{
			//copy array:
			var a:Array = [].concat($array)
			//return shuffled array:
			return a.sort(_shuffleSort);
		}
		
		private static function _shuffleSort($a:*,$b:*):Number{ 
			var random:int;
			while(random==0){
				random = MathUtils.getRandomInt(-1,1);
			}
			return random;
		}
		
		public static function fisherYatesShuffle(array:Array):Array {
			var m:int = array.length;
			var t:*;
			var i:int = 0;
			
			// While there remain elements to shuffle…
			while (m) {
				
				// Pick a remaining element…
				i = Math.floor(Math.random() * m--);
				
				// And swap it with the current element.
				t = array[m];
				array[m] = array[i];
				array[i] = t;
			}
			
			return array;
		}
		
		public static function getItemAt ($obj:*, $array:Array):int {
			var foundIndex:int = -1;
			if ($array != null || $array.length > 0) {
				for (var i:int = 0; i < $array.length; i++){
					if ($array[i] === $obj) {
						foundIndex = i;
						break;
					}
				}
			}
			return foundIndex;
		}
		
		public static function removeItem(tarArray:Array, item:*):uint {
			var i:int  = tarArray.indexOf(item);
			var f:uint = 0;
			
			while (i != -1) {
				tarArray.splice(i, 1);
				
				i = tarArray.indexOf(item, i);
				
				f++;
			}
			
			return f;
		}
		
		public static function contains ($obj:Object, $searchElement:*):Boolean {
			var exists:Boolean = false;
			
			if ($obj != {} || $obj != null) {
				for (var s:String in $obj) {
					if  ($obj[s] == $searchElement) {
						exists = true;
						break;
					}
				}
			}
			
			return exists;
		}
		
		public static function traceContents ($obj:*):void {
			
			if ($obj is Array) {
				for (var i:int = 0; i < $obj.length; i++) 
				{
					trace("content at,", i, "is", $obj[i]);	
				}
			}
			else {
				for each (var j:String in $obj) 
				{
					trace("content with name,", j, "is,", $obj[j]);
				}
				
			}
			
		}
		
		
	}
}