package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Session;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
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
			timer	= new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}

		public	function onData(event:Event):void
		{
			buffer += socket.readMultiByte(socket.bytesAvailable, 'UTF-8');
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
				case Command.ACK:
				case Command.NAK:
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
		
		private function getMessage():Message
		{
			var i:int = 0;
			var ary:Array = buffer.substr(0, buffer.indexOf('\r\n')).split(' ');
			var m:Message = new Message();
			
			m.command	= ary[i++] as String;
			switch (m.command)
			{
			case Command.USR:
			case Command.ANS:
			case Command.CAL:
			case Command.IRO:
			case Command.ACK:
			case Command.NAK:
				m.rid = parseInt(ary[i++] as String);
				break;
			case Command.JOI:
			case Command.BYE:
			case Command.MSG:
				m.rid = 0;
				break;
			}
			m.param = ary.slice(i++);
			return m;
		}
		
		private function flushMessage(length:int = 0):void
		{
			var i:int = buffer.indexOf('\r\n') + 2;
			buffer = buffer.substr(i);
			buffer = buffer.substr(length);
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

			var ba:ByteArray = new ByteArray();
			var temp:String = buffer.substr(start);
			ba.writeMultiByte(temp, 'utf-8');
			ba.position = 0;

			m.data			= ba.readMultiByte(length, 'utf-8');
			m.isBinary		= true;
			session.broadcast(new RadioEvent(RadioEvent.INCOMING_DATA, m));
			flushMessage(m.data.length);
			trace(m.toConsole());
		}
	}
}