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
	
	public class StringUtils
	{
		private static const greekChars:Array   = 	["α", "β", "Β", "γ", "Γ", "δ", "Δ", "ε", "ζ", "Ζ", "η", "θ", "Θ", "ι", "κ", "Κ", "λ", "Λ", "μ", "Μ", "ν", "Ν", "ξ", "Ξ", "ο", "π", "Π", "ρ", "Ρ", "σ", "Σ", "ς", "τ", "Τ", "υ", "φ", "Φ", "χ", "Χ", "ψ", "Ψ", "ω", ";", ":"];
		private static const englishChars:Array = 	["a", "b", "Β", "g", "Γ", "d", "D", "e", "z", "Z", "h", "u", "U", "i", "k", "K", "l", "L", "m", "M", "n", "Ν", "j", "J", "o", "p", "P", "r", "R", "s", "S", "s", "t", "T", "y", "f", "F", "x", "X", "c", "C", "v", "q", "q"];
		
		private static const aVows:RegExp = /[άα]/g;
		private static const aCapsVows:RegExp = /[ΑΆ]/g; 
		private static const yVows:RegExp = /[υϋύΰ]/g;
		private static const yCapsVows:RegExp = /[ΥΎΫ]/g;
		private static const eVows:RegExp = /[εέ]/g;
		private static const eCapsVows:RegExp = /[ΕΈ]/g;
		private static const hVows:RegExp = /[ήη]/g;
		private static const hCapsVows:RegExp = /[ΗΉ]/g;
		private static const iVows:RegExp = /[ιίϊΐΙΊΪ]/g;
		private static const iCapsVows:RegExp = /[ΙΊΪ]/g;
		private static const oVows:RegExp = /[οό]/g;
		private static const oCapsVows:RegExp = /[ΟΌ]/g;
		private static const wVows:RegExp = /[ωώ]/g;
		private static const wCapsVows:RegExp = /[ΏΩ]/g;
		
		
		/**
		 * Truncates a string. Ex.<code> StringUtils.truncateString ("ActionScript 3.0 Cookbook", 21, "..."); Returns "ActionScript 3.0 C..." </code>
		 *  
		 * @param stringToBeTrucated
		 * @param maxChars
		 * @param dilimeter
		 * @return 
		 * 
		 */		
		public static function truncateString (stringToBeTrucated:String, maxChars:Number = 10, dilimeter:String = "…"):String {
			
			return (stringToBeTrucated.length > maxChars) ? stringToBeTrucated.substring(0, maxChars-dilimeter.length).concat(dilimeter) : stringToBeTrucated;
			
		}
		
		/**
		 * Removes any greek glyphs such as stressed vows. Useful for capitalizing a text. 
		 * @param $value - The string to be converted.
		 * @return A string that has been converted.
		 * 
		 */		
		public static function removeGreekGlyphs ($value:String):String {
			if ($value != null) {
				$value = $value.replace(/[άΆ]/g, "α");
				$value = $value.replace(/[ΊΪίΐϊ]/g, "ι");
				$value = $value.replace(/[όΌ]/g, "ο");
				$value = $value.replace(/[ώΏ]/g, "ω");
				$value = $value.replace(/[ήΉ]/g, "η");
				$value = $value.replace(/[ύΎΰϋΫ]/g, "υ");
				$value = $value.replace(/[έΈ]/g, "ε");
				$value = $value.replace(/[ς]/g, "σ");
			}
			return $value;
		}
		
		/**
		 * Converts Greek character to English. 
		 * @param $char - The string to be converted.
		 * @return The converted string.
		 * 
		 */		
		public static function convertGreekToEnglish ($char:String):String {
			
			if ( aVows.test($char) ) return "a" else if ( aCapsVows.test($char) ) return "A";
			
			if ( yVows.test($char) ) return "y" else if ( yCapsVows.test($char) ) return "Y";
			
			if ( eVows.test($char) ) return "e" else if ( eCapsVows.test($char) ) return "E";

			if ( hVows.test($char) ) return "h" else if ( hCapsVows.test($char) ) return "H";
			
			if ( iVows.test($char) ) return "i" else if ( iCapsVows.test($char) ) return "I";
			
			if ( oVows.test($char) ) return "o" else if ( oCapsVows.test($char) ) return "O";
			
			if ( wVows.test($char) ) return "v" else if ( wCapsVows.test($char) ) return "V";
			
			var charIndex:int = greekChars.indexOf( $char );
			
			if (charIndex != -1) {
				$char = englishChars[ charIndex ];
			}
			
			return $char;
			
		}
		
	}
}