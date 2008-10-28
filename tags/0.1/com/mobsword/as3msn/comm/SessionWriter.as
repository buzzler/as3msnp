package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Session;
	
	import flash.net.Socket;
	
	public class SessionWriter
	{
		private var socket:Socket;
		private var session:Session;
		private	var rid:int;
		
		public function SessionWriter(s:Socket, ss:Session)
		{
			socket = s;
			session = ss;
			rid = 0;
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