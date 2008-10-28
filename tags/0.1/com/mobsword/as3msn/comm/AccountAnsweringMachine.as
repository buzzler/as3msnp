package com.mobsword.as3msn.comm
{
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Account;
	
	public class AccountAnsweringMachine
	{
		private var account	:Account;
		private	var hash	:Object;

		public	function AccountAnsweringMachine(a:Account)
		{
			account = a;
			hash	= new Object();
			account.radio.addEventListener(RadioEvent.RESERVE_DATA, onReserve);
			account.radio.addEventListener(RadioEvent.INCOMING_DATA, onEvent);
		}

		public	function reserve(cmd:String, msg:Message):void
		{
			hash[cmd] = msg;
		}
		
		private function onReserve(event:RadioEvent):void
		{
			reserve(event.command, event.data);
		}

		private	function onEvent(event:RadioEvent):void
		{
			var m:Message = hash[event.data.command] as Message;
			if (m != null)
			{
				account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m));
				hash[event.data.command] = null;
			}
		}
	}
}