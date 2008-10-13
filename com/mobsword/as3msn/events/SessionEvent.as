package com.mobsword.as3msn.events
{
	import com.mobsword.as3msn.objects.Attendent;
	import com.mobsword.as3msn.objects.Friend;
	import com.mobsword.as3msn.objects.Session;
	
	import flash.events.Event;

	public class SessionEvent extends Event
	{
		public	static const NEW_SESSION	:String = 's_newSession';
		public	static const INVITE_SESSION	:String = 's_inviteSession';
		public	static const OPEN_SESSION	:String = 's_openSession';
		public	static const CLOSE_SESSION	:String = 's_closeSession';
		public	static const JOIN_SESSION	:String = 's_joinSession';
		public	static const QUIT_SESSION	:String = 's_quitSession';
		public	static const USER_SESSION	:String = 's_userSession';
		
		public	var session		:Session;
		public	var friend		:Friend;
		public	var attendent	:Attendent;
		
		public function SessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}

