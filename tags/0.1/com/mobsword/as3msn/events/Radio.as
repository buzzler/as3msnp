package com.mobsword.as3msn.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	* 서버로부터 데이타를 받은경우 이벤트가 발생한다.
	*/
	[Event(name = "INCOMING_DATA", type = "com.mobsword.as3msn.events.RadioEvent")]
	/**
	* 서버로 보낼 데이타가 있는 경우 이벤트가 발생한다.
	*/
	[Event(name = "OUTGOING_DATA", type = "com.mobsword.as3msn.events.RadioEvent")]
	/**
	* 자동응답기에 예약 메시지를 남길때 이벤트가 발생한다.
	*/
	[Event(name = "RESERVE_DATA", type = "com.mobsword.as3msn.events.RadioEvent")]
	public class Radio extends EventDispatcher
	{
		private var history:Object;

		public	function Radio(target:IEventDispatcher = null)
		{
			super(target);
			history = new Object();
		}
		
		public	function broadcast(event:RadioEvent, record:Boolean = false):void
		{
			dispatchEvent(event);
			if (record)
				history[event.data.rid.toString()] = event;
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

