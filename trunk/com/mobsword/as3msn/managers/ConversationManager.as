package com.mobsword.as3msn.managers
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.constants.MessageType;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.data.MessageFormat;
	import com.mobsword.as3msn.events.MessageEvent;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Session;
	
	public class ConversationManager
	{
		public	var session:Session;
		
		public function ConversationManager(s:Session)
		{
			session = s;
			
			session.addEventListener(RadioEvent.INCOMING_DATA, onIncoming);
		}
		
		private function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.MSG:
				onMSG(event.data);
				break;
			case Command.ACK:
				onACK(event.data);
				break;
			case Command.NAK:
				onNAK(event.data);
				break;
			}
		}
		
		private function onACK(m:Message):void
		{
			var old:Message = session.AOD(m.rid.toString()).data;
			if (old)
			{
				var me:MessageEvent = new MessageEvent(MessageEvent.SENT);
				var header:Object = new Object();
				me.session = session;
				var temp:Array;
				var headers:Array = old.data.substring(0, old.data.indexOf('\r\n\r\n')).split('\r\n');
				for each (var str:String in headers)
				{
					temp = str.split(': ');
					header[(temp[0]) as String] = temp[1] as String;
				}
				me.message = old.data.substr(old.data.indexOf('\r\n\r\n')+4);
				me.format = MessageFormat.parseMessageFormat((header['X-MMS-IM-Format'] as String).split('; '));
				session.dispatchEvent(me);
			}
		}
		
		private function onNAK(m:Message):void
		{
			var old:Message = session.AOD(m.rid.toString()).data;
			if (old)
			{
				var me:MessageEvent = new MessageEvent(MessageEvent.SENT);
				var header:Object = new Object();
				me.session = session;
				var temp:Array;
				var headers:Array = old.data.substring(0, old.data.indexOf('\r\n\r\n')).split('\r\n');
				for each (var str:String in headers)
				{
					temp = str.split(': ');
					header[(temp[0]) as String] = temp[1] as String;
				}
				me.message = old.data.substr(old.data.indexOf('\r\n\r\n')+4);
				me.format = MessageFormat.parseMessageFormat((header['X-MMS-IM-Format'] as String).split('; '));
				session.dispatchEvent(me);
			}
		}

		private function onMSG(m:Message):void
		{
			var email:String = m.param[0] as String;
			var center:int		= m.data.indexOf('\r\n\r\n');
			var header:Object	= new Object();
			var headers:Array	= m.data.substring(0, center).split('\r\n');
			var body:String	= m.data.substring(center+4);
			
			var temp:Array;
			for each (var str:String in headers)
			{
				temp = str.split(': ');
				header[(temp[0] as String)] = (temp[1] as String).split('; ');
			}
			headers	= null;
			temp	= null;
			str		= null;
			
			var me:MessageEvent;
			switch (header['Content-Type'][0])
			{
			case MessageType.EMOTICON:
				break;
			case MessageType.PLAIN:		//Plaintext messages, also known as instant messages, are the regular messages sent between principals on MSN
				me			= new MessageEvent(MessageEvent.MESSAGE);
				me.session	= session;
				me.email	= email;
				me.attendent= session.am.getAttendentByEmail(email);
				me.friend	= (me.attendent) ? me.attendent.friend : null;
				me.message	= body;
				me.format	= MessageFormat.parseMessageFormat(header['X-MMS-IM-Format'] as Array);
				
				session.send('Hey', MessageType.ALWAY_ACK);
				
				break;
			case MessageType.TYPING:	//A typing notification is sent to inform the other participants in a switchboard session that you are currently typing a message
				me			= new MessageEvent(MessageEvent.TYPING);
				me.email	= header['TypingUser'] as String;
				me.session	= session;
				me.attendent= session.am.getAttendentByEmail(me.email);
				me.friend	= (me.attendent) ? me.attendent.friend : null;
				break;
			case MessageType.INVITE:	//Application invitations are used to invite principals to join applications such as file transfer, voice conversation, video conferencing, NetMeeting, remote assistance, whiteboard, games, and more
				break;
			}
			session.dispatchEvent(me);
		}
	}
}