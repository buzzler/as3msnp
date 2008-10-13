package com.mobsword.as3msn.objects
{
	import com.mobsword.as3msn.comm.SessionConnector;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.data.SessionData;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.managers.AttendentManager;
	import com.mobsword.as3msn.managers.ConversationManager;
	
	import flash.events.EventDispatcher;
	
	/**
	 * 세션을 나타내는 클래스.
	 * 대화창의 모든 정보를 세션클래스에서 담고있다.
	 */
	[Event(name = "INCOMING_DATA", 	type = "com.mobsword.as3msn.events.RadioEvent")]
	[Event(name = "OUTGOING_DATA", 	type = "com.mobsword.as3msn.events.RadioEvent")]
	[Event(name = "OPEN_SESSION", 	type = "com.mobsword.as3msn.events.SessionEvent")]
	[Event(name = "CLOSE_SESSION",	type = "com.mobsword.as3msn.events.SessionEvent")]
	[Event(name = "JOIN_SESSION", 	type = "com.mobsword.as3msn.events.SessionEvent")]
	[Event(name = "QUIT_SESSION", 	type = "com.mobsword.as3msn.events.SessionEvent")]
	[Event(name = "USER_SESSION", 	type = "com.mobsword.as3msn.events.SessionEvent")]
	[Event(name = "TYPING", 		type = "com.mobsword.as3msn.events.MessageEvent")]
	[Event(name = "MESSAGE",		type = "com.mobsword.as3msn.events.MessageEvent")]
	[Event(name = "SENT",			type = "com.mobsword.as3msn.events.MessageEvent")]
	public class Session extends EventDispatcher
	{
		public	var account	:Account;
		public	var data	:SessionData;
		public	var conn	:SessionConnector;
		public	var am		:AttendentManager;
		public	var cm		:ConversationManager;
		private var history	:Object;

		/**
		 * 생성자 함수.
		 * 생성이 되었다고 세션에 모두 접속하진 않는다. 기본적으로 offline상태.
		 * 세션에 접속하기 위해선 online 함수를 호출한다.
		 * 
		 * @param	a	사용자 계정 객체
		 * @param	sd	세션 정보 객체
		 */
		public	function Session(sd:SessionData)
		{
			data	= sd;
			conn	= new SessionConnector(this);
			am		= new AttendentManager(this);
			cm		= new ConversationManager(this);
			history = new Object();
		}

		/**
		 * 세션에 접속한다.
		 */
		public	function online():void
		{
			//conn.open(data.host, data.port);
		}
		
		/**
		 * 세션의 연결을 끊는다.
		 */
		public	function offline():void
		{
			//conn.close();
		}

		/**
		 * 세션의 모든 참석자에게 메시지를 보낸다.
		 * @param	msg		보낼 내용
		 * @param	font	폰트
		 * @param	color	색상
		 * @param	type	기울임,굵게
		 */
		public	function send(msg:String, font:String = '굴림', color:String = '0', type:String = ''):void
		{
			//var embed:Message = data.account.mm.genMSG(msg, font, color, type);
			//var mesg:Message = data.account.mm.genMESG(embed);
			//broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, mesg), true);
		}
		
		public	function broadcast(event:RadioEvent, record:Boolean = false):void
		{
			//dispatchEvent(event);
			//if (record)
				//history[event.data.rid.toString()] = event;
		}
		
		public	function AOD(id:String, flush:Boolean = true):RadioEvent
		{
			var e:RadioEvent = history[id] as RadioEvent;
			if (flush)
				history[id] = null;
			return e;
		}
	}
}

