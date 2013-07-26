package gr.funkytaps.digitized.utils
{
	public class NumberUtil
	{
		public function NumberUtil()
		{
		}
		
		public static function randomNumber(low:Number=NaN, high:Number=NaN):Number
		{
			//var low:Number = low;
			//var high:Number = high;
			
			if(isNaN(low))
			{
				throw new Error("low must be defined");
			}
			if(isNaN(high))
			{
				throw new Error("high must be defined");
			}
			
			return Math.round(Math.random() * (high - low)) + low;
		}
		
		
	}
}