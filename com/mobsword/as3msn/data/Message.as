/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.as3msn.data
{
	public class Message
	{
		public	var rid		:int;
		public	var command	:String;
		public	var param	:Array;
		public	var	data	:String;
		private	var embed	:Boolean;
		private	var binary	:Boolean;
		private	var text	:Boolean;

		public	function Message():void
		{
			;
		}

		public	function get isBinary():Boolean
		{
			return binary;
		}
		
		public	function set isBinary(b:Boolean):void
		{
			binary	= b;
			if (b)
			{
				text	= false;
				embed	= false;
			}
		}
		
		public	function get isText():Boolean
		{
			return text;
		}
		
		public	function set isText(b:Boolean):void
		{
			text	= b;
			if (b)
			{
				binary	= false;
				embed	= false;
			}
		}
		
		public	function get isEmbed():Boolean
		{
			return embed;
		}
		
		public	function set isEmbed(b:Boolean):void
		{
			embed	= b;
			if (b)
			{
				binary	= false;
				text	= false;
			}
		}
		
		public	function toString():String
		{
			var result:Array = new Array();
			result.push(command);

			if (isEmbed)
			{
				if (param != null)
					result = result.concat(param);
				return result.join(' ');
			}
			else if (isText)
			{
				result.push(rid.toString());
				if (param != null)
					result = result.concat(param);
				return result.join(' ') + '\r\n';
			}
			else if (isBinary)
			{
				result.push(rid.toString());
				if (param != null)
					result = result.concat(param);
				if (data == null)
					data = '';
				result.push(data.length.toString() + '\r\n' + data);
				return result.join(' ');
			}
			return '';
		}
		
		public	function toConsole():String
		{
			var result:Array = new Array();
			result.push(command);

			if (isEmbed)
			{
				if (param != null)
					result = result.concat(param);
				return result.join(' ');
			}
			else if (isText)
			{
				result.push(rid.toString());
				if (param != null)
					result = result.concat(param);
				return result.join(' ');
			}
			else if (isBinary)
			{
				result.push(rid.toString());
				if (param != null)
					result = result.concat(param);
				if (data == null)
					data = '';
				result.push(data.length.toString() + '\n' + data);
				return result.join(' ');
			}
			return '';
		}
	}
}
