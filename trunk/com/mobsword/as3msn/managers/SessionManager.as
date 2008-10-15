package com.mobsword.as3msn.managers
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.constants.ServerType;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.data.SessionData;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.events.SessionEvent;
	import com.mobsword.as3msn.objects.Account;
	import com.mobsword.as3msn.objects.Session;
	
	/**
	* ...
	* @author Default
	*/
	public class SessionManager extends Manager
	{
		private var all:Object;
		
		public	function SessionManager(a:Account)
		{
			super(a);
			all = new Object();
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.XFR:
				onXFR(event.data);
				break;
			case Command.RNG:
				onRNG(event.data);
				break;
			}
		}
		
		private function onXFR(m:Message):void
		{
			var target:String		= m.param[0] as String;
			var ary:Array			= (m.param[1] as String).split(':');
			var host:String			= ary[0] as String;
			var port:int			= parseInt(ary[1] as String);
			var auth_type:String	= m.param[2] as String;
			var auth_key:String		= m.param[3] as String;
			
			if (target == ServerType.SWITCHBOARD)
			{
				var sd:SessionData	= new SessionData();
				sd.account			= account;
				sd.host				= host;
				sd.port				= port;
				sd.auth				= auth_key;
				var s:Session		= new Session(sd);
				s.broadcast(new RadioEvent(RadioEvent.RESERVE_DATA, account.mm.genSBUSR(s)));
				all[sd.id]			= s;
				
				/*
				*	dispatch Event for external Interface
				*/
				var se:SessionEvent = new SessionEvent(SessionEvent.NEW_SESSION);
				se.session = s;
				account.dispatchEvent(se);
			}
		}
		
		private function onRNG(m:Message):void
		{
			var id:String = m.param[0] as String;
			var ary:Array = (m.param[1] as String).split(':');
			var host:String = ary[0] as String;
			var port:int = parseInt(ary[1] as String);
			var auth_type:String = m.param[2] as String;
			var auth_key:String = m.param[3] as String;
			var email:String = m.param[4] as String;
			var nick:String = m.param[5] as String;
		}
	}
	
}