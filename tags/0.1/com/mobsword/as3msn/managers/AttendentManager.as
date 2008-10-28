package com.mobsword.as3msn.managers
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.events.SessionEvent;
	import com.mobsword.as3msn.objects.Attendent;
	import com.mobsword.as3msn.objects.Friend;
	import com.mobsword.as3msn.objects.Session;
	
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

		public	function getAttendentByEmail(email:String):Attendent
		{
			return all[email] as Attendent;
		}

		private function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.IRO:
				onIRO(event.data);
				break;
			case Command.CAL:
				onCAL(event.data);
				break;
			case Command.JOI:
				onJOI(event.data);
				break;
			case Command.BYE:
				onBYE(event.data);
				break;
			}
		}
		
		private function onIRO(m:Message):void
		{
			var a:Attendent = new Attendent();
			a.email = m.param[2] as String;
			a.nick = unescape(m.param[3] as String);
			a.friend = session.data.account.fm.getFriendByEmail(a.email);
			
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
		
		private function onCAL(m:Message):void
		{
			var temp:Message = session.AOD(m.rid.toString()).data;
			var id:String = m.param[1] as String;
			var email:String = temp.param[0] as String;
			var friend:Friend = session.data.account.fm.getFriendByEmail(email);
			var se:SessionEvent = new SessionEvent(SessionEvent.INVITE_SESSION);
			se.email = email;
			se.friend = friend;
			session.dispatchEvent(se);
		}
		
		private function onJOI(m:Message):void
		{
			var email:String = m.param[0] as String;
			var nick:String = unescape(m.param[1] as String);
			var a:Attendent = new Attendent();
			a.email = email;
			a.nick = nick;
			a.friend = session.data.account.fm.getFriendByEmail(email);
			
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
		
		private function onBYE(m:Message):void
		{
			var se:SessionEvent;
			var email:String = m.param[0] as String;
			var a:Attendent = all[email] as Attendent;
			var idle:Boolean = (m.param.length > 1) ? true : false;
			
			if (a)
			{
				attendies.splice(attendies.indexOf(a),1);
				all[email] = null;
				numAttendies--;
			}
			
			/*
			*	dispatch Event for external Interface
			*/			
			if (idle)
			{
				se = new SessionEvent(SessionEvent.IDLE_SESSION);
				se.session = session;
				se.attendent = a;
				se.email = email;
				se.friend = (a) ? a.friend : null;
				session.dispatchEvent(se);
			}
			else
			{
				se = new SessionEvent(SessionEvent.QUIT_SESSION);
				se.session = session;
				se.attendent = a;
				se.email = email;
				se.friend = (a) ? a.friend : null;
				session.dispatchEvent(se);
			}
		}
	}
}

