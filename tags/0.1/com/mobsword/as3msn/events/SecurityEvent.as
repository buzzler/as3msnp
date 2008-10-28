package com.mobsword.as3msn.events 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author buzzler@pentabreed.com
	*/
	public class SecurityEvent extends Event
	{
		public	static const AUTH_SUCCESS		:String = 's_authSuccess';
		public	static const AUTH_FAIL			:String = 's_authFail';
		public	static const CHALLENGE_SUCCESS	:String = 's_challengeSuccess';
		public	static const CHALLENGE_FAIL		:String = 's_challengeFail';
		
		public	var code:String;
		
		public	function SecurityEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}
	
}