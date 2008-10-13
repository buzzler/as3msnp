package com.mobsword.as3msn.events
{
	import com.mobsword.as3msn.objects.Friend;
	import com.mobsword.as3msn.objects.Group;
	
	import flash.events.Event;

	public class FriendEvent extends Event
	{
		public	static const NEW_FRIEND		:String = 'f_newFriend';
		public	static const NICK_CHANGE	:String = 'f_nickChange';
		public	static const STATE_CHANGE	:String = 'f_stateChange';
		public	static const LIST_CHANGE	:String = 'f_listChange';
		public	static const GROUP_CHANGE	:String = 'f_groupChange';

		public	var friend:Friend;
		public	var old_value:String;
		public	var new_value:String;
		public	var old_group:Group;
		public	var new_group:Group;

		public function FriendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}