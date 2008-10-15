package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.constants.ServerType;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Account;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	* ...
	* @author Default
	*/
	public class AccountConnector extends Connector
	{
		public	var account	:Account;
		private	var reader	:AccountReader;
		private var writer	:AccountWriter;
		private var machine	:AccountAnsweringMachine;

		public	function AccountConnector(a:Account)
		{
			super();
			constructor(a);
			listener();
		}
		
		private function constructor(a:Account):void
		{
			account = a;
			reader	= new AccountReader(socket, a.radio);
			writer	= new AccountWriter(socket, a.radio);
			machine = new AccountAnsweringMachine(a);
			server	= ServerType.DISPATCH_SERVER;
		}
		
		private function listener():void
		{
			account.radio.addEventListener(RadioEvent.INCOMING_DATA, onIncoming);
			socket.addEventListener(Event.CONNECT,	onOpen);
			socket.addEventListener(Event.CLOSE,	onClose);
		}
		
		override public function open(host:String, port:int):void
		{
			switch (server)
			{
			case ServerType.DISPATCH_SERVER:
				reserve(account.mm.genDSVER());
				machine.reserve(Command.VER, account.mm.genDSCVR());
				machine.reserve(Command.CVR, account.mm.genDSUSR());
				break;
			case ServerType.NOTIFICATION_SERVER:
				reserve(account.mm.genDSVER());
				machine.reserve(Command.VER, account.mm.genDSCVR());
				machine.reserve(Command.CVR, account.mm.genDSUSR());
				break;
			}
			super.open(host, port);
		}
		
		private function onOpen(event:Event):void
		{
			socket.addEventListener(ProgressEvent.SOCKET_DATA,			reader.onData);
			account.radio.addEventListener(RadioEvent.OUTGOING_DATA,	writer.onData);
			
			//Send reserved data
			for each (var c:Message in queue)
			{
				writer.sendData(c);
			}
			queue.length = 0;
		}
		
		private function onClose(event:Event):void
		{
			socket.removeEventListener(ProgressEvent.SOCKET_DATA,		reader.onData);
			account.radio.removeEventListener(RadioEvent.OUTGOING_DATA,	writer.onData);
		}
		
		private function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.XFR:
				onXFR(event.data);
				break;
			}
		}
		
		private function onXFR(m:Message):void
		{
			var buffer:String;
			var host:String;
			var port:int;
			var target:String = m.param[0] as String;

			switch(target)
			{
			case ServerType.DISPATCH_SERVER:
				server = target;
				break;
			case ServerType.NOTIFICATION_SERVER:
				server = target;
				close();
				buffer = m.param[1] as String;
				host = buffer.substring(0, buffer.indexOf(':'));
				port = parseInt(buffer.substr(buffer.indexOf(':')+1));
				open(host, port);
				break;
			case ServerType.SWITCHBOARD:
				break;
			}
		}
		
		private	function onREQS(m:Message):void
		{
			//close();
			//reserve(account.mm.genLSIN());
			//var h:String= m.param[1] as String;
			//var p:int	= parseInt(m.param[2] as String);
			//open(h, p);
		}
		
		private function onPING(m:Message):void
		{
			//var m:Message = account.mm.genPING();
			//account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m));
		}
	}
}

