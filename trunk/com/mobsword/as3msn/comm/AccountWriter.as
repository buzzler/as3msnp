package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.Radio;
	import com.mobsword.as3msn.events.RadioEvent;
	import flash.net.Socket;
	/**
	* ...
	* @author Default
	*/
	public class AccountWriter
	{
		private	var socket	:Socket;
		private var radio	:Radio;
		private	var rid		:int;
		
		public	function AccountWriter(s:Socket, r:Radio):void
		{
			socket	= s;
			radio	= r;
			rid		= 0;
		}
		
		public	function onData(event:RadioEvent):void
		{
			var m:Message = event.data as Message;
			sendData(m);
		}
		
		public	function sendData(m:Message):void
		{
			m.rid = rid++;
			socket.writeMultiByte(m.toString(), 'UTF-8');
			socket.flush();
			trace(m.toConsole());
		}
	}
	
}