package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.constants.ServerType;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.events.SessionEvent;
	import com.mobsword.as3msn.objects.Session;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	
	/**
	* ...
	* @author Default
	*/
	public class SessionConnector extends Connector
	{
		private var session:Session;
		private var reader:SessionReader;
		private var writer:SessionWriter;
		
		public function SessionConnector(ss:Session)
		{
			constructor(ss);
			listener();
		}
		
		
		private function constructor(ss:Session):void
		{
			session= ss;
			reader = new SessionReader(socket, ss);
			writer = new SessionWriter(socket, ss);
			server = ServerType.SWITCHBOARD;
		}
		
		private function listener():void
		{
			socket.addEventListener(Event.CONNECT,	onOpen);
			socket.addEventListener(Event.CLOSE,	onClose);
		}
		
		override public function open(host:String, port:int):void
		{
			//reserve(session.account.mm.genENTR(session.data.id));
			super.open(host, port);
		}
		
		private function onOpen(event:Event):void
		{
			socket.addEventListener(ProgressEvent.SOCKET_DATA, reader.onData);
			session.addEventListener(RadioEvent.OUTGOING_DATA, writer.onData);
			
			//Send reserved data
			for each (var c:Message in queue)
			{
				writer.sendData(c);
			}
			queue.length = 0;

			/*
			*	dispatch Event for external Interface
			*/
/* 			var se:SessionEvent = new SessionEvent(SessionEvent.OPEN_SESSION);
			se.session = session;
			session.dispatchEvent(se); */
		}
		
		private function onClose(event:Event):void
		{
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, reader.onData);
			session.removeEventListener(RadioEvent.OUTGOING_DATA, writer.onData);
			
			/*
			*	dispatch Event for external Interface
			*/
/* 			var se:SessionEvent = new SessionEvent(SessionEvent.CLOSE_SESSION);
			se.session = session;
			session.dispatchEvent(se); */
		}
	}
	
}