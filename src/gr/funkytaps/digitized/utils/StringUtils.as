package gr.funkytaps.digitized.utils
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	public class StringUtils
	{
		
		public static function formatNumber(value:Number, thousandsSeparator:String = ".", __decimalSeparator:String = ".", __decimalPlaces:Number = NaN):String {
			
			var nInt:Number = Math.floor(value);
			var nDec:Number = value - nInt;
			
			var sInt:String = nInt.toString(10);
			var sDec:String;
			
			if (!isNaN(__decimalPlaces)) {
				sDec = (Math.round(nDec * Math.pow(10, __decimalPlaces)) / Math.pow(10, __decimalPlaces)).toString(10).substr(2);
			} else {
				sDec = nDec == 0 ? "" : nDec.toString(10).substr(2);
			}
			
			var fInt:String = "";
			var i:Number;
			for (i = 0; i < sInt.length; i++) {
				fInt += sInt.substr(i, 1);
				if ((sInt.length - i - 1) % 3 == 0 && i != sInt.length - 1) fInt += thousandsSeparator;
			}
			
			return fInt + (sDec.length > 0 ? __decimalSeparator + sDec : "");
			
		}
	}
}