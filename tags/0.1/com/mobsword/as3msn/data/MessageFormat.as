package com.mobsword.as3msn.data
{
	public class MessageFormat
	{
		/**
		 * Font name
		 */
		public	var	font_name	:String		= 'Arial';
		
		/**
		 * Effects
		 * ex> BI or IB
		 */
		public	var bold		:Boolean	= false;
		public	var italic		:Boolean	= false;
		
		/**
		 * 24bit Color
		 * ex> 0000FF or FF0000
		 */
		public	var color		:uint		= 0x000000;

		/**
			0 - ANSI_CHARSET
				ANSI characters
			1 - DEFAULT_CHARSET
				Font is chosen based solely on name and size. If the described font is not available on the system, Windows will substitute another font.
			2 - SYMBOL_CHARSET
				Standard symbol set
			4d - MAC_CHARSETLT
				Macintosh characters
			80 - SHIFTJIS_CHARSET
				Japanese shift-JIS characters
			81 - HANGEUL_CHARSET
				Korean characters (Wansung)
			82 - JOHAB_CHARSET
				Korean characters (Johab)
			86 - GB2312_CHARSET
				Simplified Chinese characters (Mainland China)
			88 - CHINESEBIG5_CHARSET
				Traditional Chinese characters (Taiwanese)
			a1 - GREEK_CHARSET
				Greek characters
			a2 - TURKISH_CHARSET
				Turkish characters
			a3 - VIETNAMESE_CHARSET
				Vietnamese characters
			b1 - HEBREW_CHARSET
				Hebrew characters
			b2 - ARABIC_CHARSET
				Arabic characters
			ba - BALTIC_CHARSET
				Baltic characters
			cc - RUSSIAN_CHARSET_DEFAULT
				Cyrillic characters
			de - THAI_CHARSET
				Thai characters
			ee - EASTEUROPE_CHARSET
				Sometimes called the "Central European" character set, this includes diacritical marks for Eastern European countries
			ff - OEM_DEFAULT
				Depends on the codepage of the operating system
		 */
		public	var charset		:String		= '81';
		
		/**
		 * The PF family defines the category that the font specified in the FN parameter falls into
		 * 
			0_ - FF_DONTCARE
				Specifies a generic family name. This name is used when information about a font does not exist or does not matter. The default font is used.
			1_ - FF_ROMAN
				Specifies a proportional (variable-width) font with serifs. An example is Times New Roman.
			2_ - FF_SWISS
				Specifies a proportional (variable-width) font without serifs. An example is Arial.
			3_ - FF_MODERN
				Specifies a monospace font with or without serifs. Monospace fonts are usually modern; examples include Pica, Elite, and Courier New.
			4_ - FF_SCRIPT
				Specifies a font that is designed to look like handwriting; examples include Script and Cursive.
			5_ - FF_DECORATIVE
				Specifies a novelty font. An example is Old English.
		
			The second digit represents the pitch of the font - in other words, whether it is monospace or variable-width.
			_0 - DEFAULT_PITCH
				Specifies a generic font pitch. This name is used when information about a font does not exist or does not matter. The default font pitch is used.
			_1 - FIXED_PITCH
				Specifies a fixed-width (monospace) font. Examples are Courier New and Bitstream Vera Sans Mono.
			_2 - VARIABLE_PITCH
				Specifies a variable-width (proportional) font. Examples are Times New Roman and Arial.

			Below are some PF values and example fonts that fit the category.
			12
				Times New Roman, MS Serif, Bitstream Vera Serif
			22
				Arial, Verdana, MS Sans Serif, Bitstream Vera Sans
			31
				Courier New, Courier
			42
				Comic Sans MS
		 */
		public	var pitch_family:String		= '0';
		
		/**
		 * Right alignment
		 */
		public	var right_align	:Boolean	= false;
		
		public	static function parseMessageFormat(ary:Array):MessageFormat
		{
			var temp:Array;
			var conf:Object = new Object();
			for each (var s:String in ary)
			{
				temp = s.split('=');
				conf[(temp[0]) as String] = temp[1] as String;
			}
			
			var result:MessageFormat = new MessageFormat();
			result.font_name = conf['FN'] as String;
			result.charset = conf['CS'] as String;
			result.pitch_family = conf['PF'] as String;
			result.color = parseInt(conf['CO'] as String, 16);
			if (conf['EF'])
			{
				result.bold = ((conf['EF'] as String).toUpperCase().indexOf('B') >= 0);
				result.italic = ((conf['EF'] as String).toUpperCase().indexOf('I') >= 0);
			}
			if (conf['RL'])
			{
				result.right_align = ((conf['RL'] as String) == '1') ? true : false;
			}
			
			return result;
		}
		
		public	function toString():String
		{
			var result:Array = new Array();
			var effect:String = '';
			
			if (bold)
				effect += 'B';
			if (italic)
				effect += 'I';
			if (effect.length > 1)
				effect = 'EF=' + effect;
			
			if (this.font_name)
				result.push('FN=' + escape(font_name));
			if (effect.length > 1)
				result.push(effect);
			if (color)
				result.push('CO=' + color.toString(16));
			if (charset)
				result.push( 'CS=' + charset);
			if (pitch_family)
				result.push('PF=' + pitch_family);
			if (right_align)
				result.push('RL=1');
			
			return result.join('; ');
		}
	}
}