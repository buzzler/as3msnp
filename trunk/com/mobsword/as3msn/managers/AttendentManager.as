package com.mobsword.as3msn.managers
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.events.SessionEvent;
	import com.mobsword.as3msn.objects.Attendent;
	import com.mobsword.as3msn.objects.Session;
	import com.mobsword.as3msn.utils.Codec;
	
	public class AttendentManager
	{
		public	var session:Session;
		public	var numAttendies:int;
		public	var all:Object;
		public	var attendies:Array;
		
		public function AttendentManager(s:Session)
		{
			session		= s;
			numAttendies= 0;
			all			= new Object();
			attendies	= new Array();
			
			session.addEventListener(RadioEvent.INCOMING_DATA, onIncoming);
		}

		private function onIncoming(event:RadioEvent):void
		{
			//switch (event.data.command)
			//{
			//case Command.ENTR:
				//onENTR(event.data);
				//break;
			//case Command.USER:
				//onUSER(event.data);
				//break;
			//case Command.QUIT:
				//onQUIT(event.data);
				//break;
			//case Command.JOIN:
				//onJOIN(event.data);
				//break;
			//case Command.WHSP:
				//onWHSP(event.data);
				//break;
			//}
		}
		
		private function onENTR(m:Message):void
		{
			/*
			*	dispatch Event for external Interface
			*/
			var se:SessionEvent = new SessionEvent(SessionEvent.OPEN_SESSION);
			se.session = session;
			session.dispatchEvent(se);
		}
		
		private function onUSER(m:Message):void
		{
			var a:Attendent = new Attendent();
			a.email	= m.param[2] as String;
			a.nick	= Codec.decode(m.param[3] as String);
			a.name	= Codec.decode(m.param[4] as String);
			a.friend= session.data.account.fm.getFriendByEmail(a.email);
			
			attendies.push(a);
			all[a.email] = a;
			numAttendies++;
			
			/*
			*	dispatch Event for external Interface
			*/
			var se:SessionEvent = new SessionEvent(SessionEvent.USER_SESSION);
			se.attendent	= a;
			se.friend		= a.friend;
			se.session		= session;
			session.dispatchEvent(se);
		}
		
		private function onQUIT(m:Message):void
		{
			var se:SessionEvent;
			if (m.rid == 0)		//quit attendent
			{
				var email:String = m.param[0] as String;
				var a:Attendent = all[email] as Attendent;
				if (a == null)
					return
				attendies.splice(attendies.indexOf(a),1);
				all[email] = null;
				numAttendies--;
				
				/*
				*	dispatch Event for external Interface
				*/
				se = new SessionEvent(SessionEvent.QUIT_SESSION);
				se.attendent	= a;
				se.friend		= a.friend;
				se.session		= session;
				session.dispatchEvent(se);
			}
			else				//quit self
			{
				attendies.length = 0;
				all = new Object();
				numAttendies = 0;
				
				/*
				*	dispatch Event for external Interface
				*/
				se = new SessionEvent(SessionEvent.CLOSE_SESSION);
				se.session = session;
				session.dispatchEvent(se);
			}
		}
		
		private function onJOIN(m:Message):void
		{
			var a:Attendent = new Attendent();
			a.email	= m.param[0] as String;
			a.nick	= Codec.decode(m.param[1] as String);
			a.name	= Codec.decode(m.param[2] as String);
			a.friend= session.data.account.fm.getFriendByEmail(a.email);
			
			attendies.push(a);
			all[a.email] = a;
			numAttendies++;
			
			/*
			*	dispatch Event for external Interface
			*/
			var se:SessionEvent = new SessionEvent(SessionEvent.JOIN_SESSION);
			se.attendent	= a;
			se.friend		= a.friend;
			se.session		= session;
			session.dispatchEvent(se);
		}
		
		private function onWHSP(m:Message):void
		{
			//var email:String= m.param[0] as String;
			//var cmd:String	= m.param[1] as String;
			//var data:String	= m.param[2] as String;
			//var a:Attendent = all[email] as Attendent;
			//if (a != null)
			//{
				//switch (cmd)
				//{
				//case Command.AVCHAT2:
					//a.avchat = data;
					//break;
				//case Command.FONT:
					//a.font = data;
					//break;
				//case Command.DPIMG:
					//a.dpimg = data;
					//break;
				//}
			//}
		}
	}
}

