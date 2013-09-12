package com.dimmdesign.fonts
{
	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class FontsAssets
	{
		
		[Embed(source = 'typefaces/Helvetica.ttf', 
				fontName = 'Helvetica',
				fontWeight = 'normal',
				unicodeRange = 'U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020-002F,U+003A-0040,U+005B-0060,U+007B-007E,U+0374-03F2,U+1F00-1FFE,U+2000-206F,U+20A0-20CF,U+2100-2183',
				mimeType = 'application/x-font',
				embedAsCFF="false")]
		public static const Helvetica:Class;
		
		[Embed(source = 'typefaces/HelveticaBold.ttf', 
				fontName = 'HelveticaBold',
				fontWeight = 'normal',
				unicodeRange = 'U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E,U+0020-002F,U+003A-0040,U+005B-0060,U+007B-007E,U+0374-03F2,U+1F00-1FFE,U+2000-206F,U+20A0-20CF,U+2100-2183',
				mimeType = 'application/x-font',
				embedAsCFF="false")]
		public static const HelveticaBold:Class;
		
		public function FontsAssets()
		{
		}
		
		public static function initFonts():void {
			// nothing here.
		}
	}
}