package com.mobsword.as3msn.utils
{
	
	/**
	* ...
	* @author Default
	*/
	public class Codec
	{
		public static var patterne1:RegExp = /%/g;
		public static var patterne2:RegExp = / /g;
		public static var patterne3:RegExp = /\t/g;
		public static var patterne4:RegExp = /\n/g;
		
		public static var patternd1:RegExp = /%25/g;
		public static var patternd2:RegExp = /%20/g;
		public static var patternd3:RegExp = /%0A/g;
		
		public static function encode(str:String):String
		{
			//var result:String;
			//result = str.replace(patterne1, "%25");
			//result = result.replace(patterne2, "%20");
			//result = result.replace(patterne3, "%20");
			//result = result.replace(patterne4, "%0A");
			//result = result.split(String.fromCharCode(13)).join("%0A");
			//return result;
			return str;
		}
		
		public static function decode(str:String):String
		{
			//var result:String;
			//result = str.replace(patternd1, "%");
			//result = result.replace(patternd2, " ");
			//result = result.replace(patternd3, "\n");
			//return result;
			return str;
		}
	}
	
}