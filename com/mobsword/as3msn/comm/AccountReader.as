package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.Radio;
	import com.mobsword.as3msn.events.RadioEvent;
	
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	/**
	* ...
	* @author Default
	*/
	public class AccountReader
	{
		private	var socket	:Socket;
		private var radio	:Radio;
		private var buffer	:String;
		private var timer	:Timer;

		public	function AccountReader(s:Socket, r:Radio):void
		{
			socket	= s;
			radio	= r;
			buffer	= '';
			
			timer	= new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}

		public	function onData(event:ProgressEvent):void
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
				case Command.UBX:
				case Command.NOT:
					onPayload();
					break;
				default:
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
			if (ary.length > 0)
				m.command	= ary[i++] as String;
			if (ary.length > 1)
			{
				var rid:int = parseInt(ary[1] as String);
				if ((ary[1] as String) == "0")
				{
					m.rid	= 0;
					i++;
				}
				else if (rid > 0)
				{
					m.rid	= rid;
					i++;
				}
				else
					m.rid	= 0;
			}
			if (ary.length > 2)
				m.param		= ary.slice(i++);
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
			radio.broadcast(new RadioEvent(RadioEvent.INCOMING_DATA, m));
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
			radio.broadcast(new RadioEvent(RadioEvent.INCOMING_DATA, m));
			flushMessage(m.data.length);
			trace(m.toConsole());
		}
	}
}

