package com.mobsword.ac3msn.events
{
	import com.mobsword.ac3msn.objects.Account;
	
	import flash.events.Event;

	public class AccountEvent extends Event
	{
		public	static const STATE_CHANGE	:String = 'a_stateChange';
		public	static const NICK_CHANGE	:String = 'a_nickChange';

		public	var account		:Account;
		public	var old_value	:String;
		public	var new_value	:String;

		public function AccountEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}