package com.mobsword.as3msn.managers
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.MessageEvent;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Session;
	import com.mobsword.as3msn.utils.Codec;
	
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