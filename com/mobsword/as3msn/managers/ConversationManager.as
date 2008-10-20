package com.mobsword.as3msn.managers
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.constants.MessageType;
	import com.mobsword.as3msn.data.Message;
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
			session.addEventListener(RadioEvent.OUTGOING_DATA, onOutgoing);
		}
		
		private function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.MSG:
				onMSG(event.data);
				break;
			}
		}

		private function onMSG(m:Message):void
		{
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
			 
			 switch (header['Content-Type'][0])
			 {
			 case MessageType.PLAIN:	//Plaintext messages, also known as instant messages, are the regular messages sent between principals on MSN
			 	break;
			 case MessageType.TYPING:	//A typing notification is sent to inform the other participants in a switchboard session that you are currently typing a message
			 	break;
			 case MessageType.INVITE:	//Application invitations are used to invite principals to join applications such as file transfer, voice conversation, video conferencing, NetMeeting, remote assistance, whiteboard, games, and more
			 	break;
			 }
			//var me:MessageEvent;
			///**
			 //* The Message I sent
			 //*/
			//if ((event.data.rid != 0)&&(event.data.command == Command.MESG))
			//{
				//var m:Message = session.AOD(event.data.rid.toString()).data;
				//var ary:Array = (m.param[0] as String).split('%09');
				//me = new MessageEvent(MessageEvent.SENT);
				//me.session = session;
				//me.message = Codec.decode(ary[3] as String);
				//session.dispatchEvent(me);
				//return;
			//}
//
			///**
			 //* The Message I received
			 //*/
			//if (event.data.param != null)
			//{
				//var from:String	= event.data.param[0] as String;
				//var cmd:String	= event.data.param[1] as String;
				//var data:String	= event.data.param[2] as String;
			//}
			//switch (cmd)
			//{
			//case Command.TYPING:
				//me = new MessageEvent(MessageEvent.TYPING);
				//me.session	= session;
				//me.friend	= session.account.fm.getFriendByEmail(from);
				//me.typing	= data;
				//break;
			//case Command.EMOTICON:
				//return;
			//case Command.MSG:
				//var param:Array = data.split('%09');
				//me = new MessageEvent(MessageEvent.MESSAGE);
				//me.session	= session;
				//me.friend	= session.account.fm.getFriendByEmail(from);
				//me.font		= Codec.decode(param[0] as String);
				//me.color	= param[1] as String;
				//me.fonttype	= param[2] as String;
				//me.message	= Codec.decode(param[3] as String);
				//break;
			//}
			//if (me != null)
				//session.dispatchEvent(me);
		}
		
		private function onOutgoing(event:RadioEvent):void
		{
			;
		}
	}
}