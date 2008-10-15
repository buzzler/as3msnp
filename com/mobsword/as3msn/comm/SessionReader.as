package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Session;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	
	public class SessionReader
	{
		private var socket:Socket;
		private var session:Session;
		private var buffer:String;
		private var timer:Timer;
		
		public function SessionReader(s:Socket, ss:Session)
		{
			socket	= s;
			session	= ss;
			buffer	= '';
			timer	= new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}

		public	function onData(event:Event):void
		{
			buffer += socket.readMultiByte(socket.bytesAvailable, 'UTF-8');
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
		
		private function onTimer(event:TimerEvent):void
		{
			if (buffer.length < 1)
				return;
			if (buffer.indexOf('\r\n') < 0)
				return;
			var cmd:String;
			while (buffer.length > 0)
			{
				cmd = buffer.substr(0, 3);
				switch(cmd)
				{
				case Command.MSG:
					onPayload();
					break;
				case Command.ANS:
				case Command.IRO:
				case Command.USR:
				case Command.CAL:
				case Command.JOI:
				case Command.BYE:
					if (buffer.lastIndexOf('\r\n') < (buffer.length - 2))
						return;
					onMessage();
					break;
				}
			}
		}
		
		/**
		 * RNG 커맨드를 rid 때문에 잘못가져오고있다 수정필요!!
		 */
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
			trace(m.toConsole());
		}
		
		private function onPayload():void
		{
			var m:Message	= getMessage();
			var start:int	= buffer.indexOf('\r\n') + 2;
			var length:int	= parseInt(m.param[m.param.length - 1] as String);
			if (buffer.length < (start + length))
				return;
			m.data			= buffer.substr(start, length);
			m.isBinary		= true;
			session.broadcast(new RadioEvent(RadioEvent.INCOMING_DATA, m));
			flushMessage(length);
			trace(m.toConsole());
		}
	}
}