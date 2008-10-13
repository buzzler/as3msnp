/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.as3msn.objects
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.constants.ListType;
	import com.mobsword.as3msn.data.FriendData;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	
	import flash.events.EventDispatcher;
	
	/**
	 * 친구를 나타내는 클래스이다.
	 * FL, AL, BL, RL 에 담긴 모든 대화상대는 이 객체로 표현된다.
	 */
	[Event(name = "NICK_CHANGE", 	type = "com.mobsword.as3msn.events.FriendEvent")]
	[Event(name = "STATE_CHANGE", 	type = "com.mobsword.as3msn.events.FriendEvent")]
	[Event(name = "LIST_CHANGE", 	type = "com.mobsword.as3msn.events.FriendEvent")]
	[Event(name = "GROUP_CHANGE", 	type = "com.mobsword.as3msn.events.FriendEvent")]
	public class Friend extends EventDispatcher
	{
		public	var data:FriendData;
		
		public	function Friend(fd:FriendData)
		{
			data = fd;
		}

		/**
		 * 친구를 특정 세션으로 초대한다. 
		 * @param	s	세션객체
		 */
		public	function invite(s:Session):void
		{
			s.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, data.account.mm.genSBCAL(this)));
		}

		/**
		 * 친구를 차단한다. 상대방은 사용자의 상태를 알 수 없게 된다.
		 */
		public	function block():void
		{
			if ((!data.block)&&data.allow)
			{
				var m1:Message = data.account.mm.genNSREM(ListType.ALLOWED, this);
				var m2:Message = data.account.mm.genNSADD(ListType.BLOCKED, data.email, data.nick);
				
				var re:RadioEvent = new RadioEvent(RadioEvent.RESERVE_DATA, m2);
				re.command = Command.REM;
				data.account.radio.broadcast(re);
				data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m1));
			}
		}

		/**
		 * 친구를 차단 해제한다.
		 */
		public	function unblock():void
		{
			if (data.block&&(!data.allow))
			{
				var m1:Message = data.account.mm.genNSREM(ListType.BLOCKED, this);
				var m2:Message = data.account.mm.genNSADD(ListType.ALLOWED, data.email, data.nick);
				
				var re:RadioEvent = new RadioEvent(RadioEvent.RESERVE_DATA, m2);
				re.command = Command.REM;
				data.account.radio.broadcast(re);
				data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m1));
			}
		}

		/**
		 * 친구를 대화상대 리스트로부터 삭제한다.
		 */
		public	function remove():void
		{
			if (data.forward)
			{
				var m:Message = data.account.mm.genNSREM(ListType.FOWARD, this);
				data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m));
			}
		}

		/**
		 * 친구의 그룹을 변경한다.
		 * @param	g	이동시킬 새로운 그룹 객체.
		 */
		public	function move(g:Group):void
		{
			var m1:Message = data.account.mm.genNSREM(ListType.FOWARD, this);
			var m2:Message = data.account.mm.genNSADD(ListType.FOWARD, data.email, data.nick, g);
			
			var re:RadioEvent = new RadioEvent(RadioEvent.RESERVE_DATA, m2);
			re.command = Command.REM;
			data.account.radio.broadcast(re);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m1));
		}
		
		/**
		 * 친구의 이름을 변경한다.
		 * @param	name	친구의 새로운 닉네임
		 */
		public	function rename(name:String):void
		{
			var m:Message = data.account.mm.genNSREA(name);
			data.account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, m));
		}
	}
}


