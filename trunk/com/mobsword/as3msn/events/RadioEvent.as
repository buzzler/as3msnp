package com.mobsword.as3msn.events {
	import com.mobsword.as3msn.data.Message;
	
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class RadioEvent extends Event
	{
		public	static const OUTGOING_DATA	:String = 'outgoingData';
		public	static const INCOMING_DATA	:String = 'incomingData';
		public	static const RESERVE_DATA	:String = 'reserveData';

		public	var data:Message;
		public	var command:String;

		/**
		 * 생성자
		 * @param	type	이벤트 타잎
		 * @param	d		이벤트 데이타
		 */
		public	function RadioEvent(type:String, d:Message)
		{
			super(type);
			data = d;
		}
	}
}

