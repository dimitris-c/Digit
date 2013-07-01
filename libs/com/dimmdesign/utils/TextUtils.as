package com.dimmdesign.utils 
{
	import com.dimmdesign.fonts.FontsAssets;
	
	import flash.display.Shape;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * 
	 * @author — Dimitris Chatzieleftheriou
	 * @company — OgilvyOne Worldwide, Athens
	 *
	 * @copyright — 2012 OgilvyOne Worldwide, Athens
	 *
	 **/
	
	public class TextUtils
	{
		public function TextUtils()
		{ 
		}
		
		
		/**
		 * Creates and returns a new textfield that parses the passed CSS style.
		 * 
		 * 	var t:TextField = TextUtils.createTextField('p {font-size:15; font-family:Helvetica;}', true);
		 * 	addChild(t);
		 * 
		 * @param style A string containing a CSS object that will be parsed. Eg. "p { font-size: 14; font-family: Verdana, Arial, sans-serif; color: #FFFFFF; }"
		 * @param embedFonts Set to true if you want a specific embeded font to be used.
		 * @param autoSize A string specifing the autoSizing of the textfield. See TextFieldAutoSize for possible values.
		 * @param antiAlias A string specifing the antiAlias mode of the textfield. See AntiAliasType for possible values.
		 * @param wordwrap If set to true word wrapping will occur to the textfield. 
		 * @param multiline if set to true the textfild will be multiline otherwise it will be a single line. 
		 * @return Textfield.
		 * 
		 */		
		public static function createTextField (style:String = null, embedFonts:Boolean = true, autoSize:String = "left", antiAlias:String = "advanced", wordwrap:Boolean = false, multiline:Boolean = false):TextField {
			
			var textField:TextField = new TextField();
			var css:StyleSheet = new StyleSheet;
			
			css.parseCSS( style );
			
			textField.styleSheet = css;
			textField.embedFonts = embedFonts;
			textField.condenseWhite = true;
			textField.mouseEnabled = false;
			textField.multiline = multiline;
			textField.wordWrap = wordwrap;
			textField.selectable = false;
			textField.autoSize = autoSize;
			textField.antiAliasType = antiAlias;
			if (autoSize == "none") textField.width = 200;
			
			return textField;
			
		}
		
		public static function createTextfieldWithTextFormat (textFormat:TextFormat, embedFonts:Boolean = true, autoSize:String = "left", antiAlias:String = "advanced", wordwrap:Boolean = false, multiline:Boolean = false):TextField {
			
			var textField:TextField = new TextField();
			
			textField.defaultTextFormat = textFormat;

			textField.embedFonts = embedFonts;
			textField.multiline = multiline;
			textField.wordWrap = wordwrap;
			textField.selectable = false;
			textField.autoSize = autoSize;
			textField.antiAliasType = antiAlias;
			if (autoSize == "none") textField.width = 200;
			
			
			return textField;
		}
		
		public static function createInputTextfieldWithTextFormat(textFormat:TextFormat, width:Number, height:Number, embedFonts:Boolean = true, antiAlias:String = "advanced", wordwrap:Boolean = false, multiline:Boolean = false):TextField {
			
			var textField:TextField = new TextField();
			
			textField.defaultTextFormat = textFormat;
		
			textField.type = 'input';
			textField.embedFonts = embedFonts;
			textField.multiline = multiline;
			textField.wordWrap = wordwrap;
			textField.selectable = true;
			textField.antiAliasType = antiAlias;
			textField.width = width;
			textField.height = height;
			
			return textField;
			
		}
		
		public static function createInputTextfield(style:String, inputStyle:String, multiline:Boolean = false):TextField {
			
			var textField:TextField = new TextField();
			var css:StyleSheet = new StyleSheet;
			
			css.parseCSS( style );
			
			textField.antiAliasType = "advanced";
			textField.type = TextFieldType.INPUT;
			textField.multiline = multiline;
			textField.wordWrap = multiline;
			textField.border = false;
			textField.embedFonts = true;
			
			if(style != null) textField.defaultTextFormat = css.transform(css.getStyle(inputStyle));
			
			return textField;
			
		}
		
		
		public static function autoResizeTextfield(textfield:TextField, maxWidth:Number, maxHeight:Number):void {
			
			var newFormat:TextFormat = textfield.getTextFormat();
			
			while (textfield.textWidth > maxWidth || textfield.textHeight > maxHeight) {
				
				newFormat.size = int (newFormat.size) - 1;
				
				textfield.setTextFormat (newFormat);
				
			}
			
		}
		
		public static function verticalAlignTextField(tf: TextField): void {
			tf.y = Math.round((tf.height - tf.textHeight) >> 1) - 5;
		}
		
		public static function createInputBackground (x:Number, y:Number, width:Number, height:Number, colour:Number):Shape {
		
			var bg:Shape = new Shape();
			bg.graphics.beginFill(colour, 1);
			bg.graphics.drawRect(0, 0, width, height);
			bg.graphics.endFill();
			bg.x = x;
			bg.y = y;
			
			return bg;		
		}
		
	}
}


