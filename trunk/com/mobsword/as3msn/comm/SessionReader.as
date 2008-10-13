package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Session;
	
	import flash.events.Event;
	import flash.net.Socket;
	
	public class SessionReader
	{
		private var socket:Socket;
		private var session:Session;
		private var buffer:String;
		
		public function SessionReader(s:Socket, ss:Session)
		{
			socket	= s;
			session	= ss;
			buffer	= '';
		}

		public	function onData(event:Event):void
		{
			//buffer += socket.readMultiByte(socket.bytesAvailable, 'UTF-8');
			//trace(buffer);
			//if (buffer.length < 1)
				//return;
			//if (buffer.indexOf('\r\n') < 0)
				//return;
			//var cmd:String;
			//while (buffer.length > 0)
			//{
				//cmd = buffer.substr(0, 4);
				//switch(cmd)
				//{
				//case Command.WHSP:
				//case Command.MESG:
					//onEmbed();
					//break;
				//case Command.ENTR:
				//case Command.JOIN:
				//case Command.USER:
				//case Command.QUIT:
					//onMessage();
					//break;
				//default:
					//onMessage();
					//break;
				//}
			//}
		}
		
		private function getMessage():Message
		{
			var ary:Array = buffer.substr(0, buffer.indexOf('\r\n')).split(' ');
			var m:Message = new Message();
			if (ary.length > 0)
				m.command	= ary[0] as String;
			if (ary.length > 1)
				m.rid		= parseInt(ary[1] as String);
			if (ary.length > 2)
				m.param		= ary.slice(2);
			return m;
		}
		
		private function flushMessage(length:int = 0):void
		{
			var i:int = buffer.indexOf('\r\n') + 2;
			buffer = buffer.substr(i);
			buffer = buffer.substr(length);
		}
		
		private function onEmbed():void
		{
			var m:Message	= getMessage();
			m.isEmbed		= true;
			session.broadcast(new RadioEvent(RadioEvent.INCOMING_DATA, m));
			flushMessage();
		}
		
		private function onMessage():void
		{
			var m:Message	= getMessage();
			m.isText		= true;
			session.broadcast(new RadioEvent(RadioEvent.INCOMING_DATA, m));
			flushMessage();
		}
	}
}