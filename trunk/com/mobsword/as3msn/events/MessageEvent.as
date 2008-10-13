package com.mobsword.as3msn.events
{
	import com.mobsword.as3msn.objects.Friend;
	import com.mobsword.as3msn.objects.Session;
	
	import flash.events.Event;

	public class MessageEvent extends Event
	{
		public	static const TYPING	:String = 'm_typing';
		public	static const MESSAGE:String = 'm_messege';
		public	static const SENT	:String = 'm_sent';
		
		public	var session	:Session;
		public	var friend	:Friend;
		public	var typing	:String;
		public	var message	:String;
		public	var font	:String;
		public	var color	:String;
		public	var fonttype:String;
		
		public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}