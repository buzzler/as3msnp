package com.mobsword.as3msn.comm
{
	import flash.errors.IOError;
	import flash.net.Socket;
	
	/**
	* ...
	* @author Default
	*/
	public class Connector
	{
		protected	var server	:String;
		protected	var queue	:Array;
		protected	var socket	:Socket;

		public	function Connector()
		{
			queue	= new Array();
			socket	= new Socket();
		}

		public	function open(host:String, port:int):void
		{
			try
			{
				if (!socket.connected)
					socket.connect(host, port);
			}
			catch (e:IOError)
			{
				throw e;
			}
			catch (e:SecurityError)
			{
				throw e;
			}
		}
		
		public	function close():void
		{
			try
			{
				if (socket.connected)
					socket.close();
			}
			catch (e:IOError)
			{
				throw e;
			}
		}
		
		public	function reserve(r:Object):void
		{
			queue.push(r);
		}
	}
}

