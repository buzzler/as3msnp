package com.mobsword.as3msn.events
{
	import com.mobsword.as3msn.data.MessageFormat;
	import com.mobsword.as3msn.objects.Attendent;
	import com.mobsword.as3msn.objects.Friend;
	import com.mobsword.as3msn.objects.Session;
	
	import flash.events.Event;

	public class MessageEvent extends Event
	{
		public	static const TYPING	:String = 'm_typing';
		public	static const MESSAGE:String = 'm_messege';
		public	static const SENT	:String = 'm_sent';
		public	static const MISS	:String = 'm_miss';
		
		public	var session	:Session;
		public	var email	:String;
		public	var friend	:Friend;
		public	var attendent:Attendent;
		public	var message	:String;
		public	var format	:MessageFormat;
		
		public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}