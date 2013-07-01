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
	
	public class BenchmarkUtil
	{
		public function BenchmarkUtil()
		{
		}
		
		public static function fibonacciTest():void {
			var startTime:Date = new Date();
						
			for (var i:int = 0; i < 35; i++){
				trace ( fibo(i) );
			}
			
			var endTime:Date = new Date();
			
			var benchmark:Number = endTime.time - startTime.time;
			var result:String = benchmark + " ms";
			
			trace ("Result: ", result);
			
			function fibo(n:int):int 
			{
				if (n < 2) return 1;
				return fibo(n-2) + fibo(n-1);
			}	
		}
			
		
	}
}