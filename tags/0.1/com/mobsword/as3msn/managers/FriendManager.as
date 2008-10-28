package com.mobsword.as3msn.managers
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.constants.FriendState;
	import com.mobsword.as3msn.constants.ListType;
	import com.mobsword.as3msn.data.FriendData;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.FriendEvent;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Account;
	import com.mobsword.as3msn.objects.Friend;
	import com.mobsword.as3msn.objects.Group;
	import com.mobsword.as3msn.utils.Codec;
	
	/**
	* ...
	* @author Default
	*/
	public class FriendManager extends Manager
	{
		public	var totalFriends:int;
		public	var numFriends:int;
		public	var all		:Object;
		public	var forward	:Array;
		public	var allow	:Array;
		public	var block	:Array;
		public	var reverse	:Array;
		public	var pending	:Array;
		public	var nogroup	:Array;
		
		public	function FriendManager(a:Account)
		{
			super(a);
			totalFriends 	= 0;
			numFriends		= 0;
			all		= new Object();
			forward	= new Array();
			allow	= new Array();
			block	= new Array();
			reverse	= new Array();
			pending	= new Array();
			nogroup	= new Array();
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.SYN:
				onSYN(event.data);
				break;
			case Command.LST:
				onLST(event.data);
				break;
			case Command.ILN:
				onILN(event.data);
				break;
			case Command.ADD:
				onADD(event.data);
				break;
			case Command.REM:
				onREM(event.data);
				break;
			case Command.REA:
				onREA(event.data);
				break;
			}
		}
		
		public	function getFriendByEmail(email:String):Friend
		{
			return all[email] as Friend;
		}
		
		public	function getFriendById(id:String):Friend
		{
			return all[id] as Friend;
		}
		
		private function onSYN(m:Message):void
		{
			this.totalFriends = parseInt(m.param[m.param.length - 2]);
		}
		
		private function onLST(m:Message):void
		{

			var fd:FriendData = new FriendData();
			fd.account	= account;
			fd.email	= unescape(m.param[0]) as String;
			fd.nick		= unescape(m.param[1]) as String;
			var list:int= parseInt(m.param[2] as String);
			fd.pending	= ((list &16) ==16) ? true : false;
			fd.reverse	= ((list & 8) == 8)	? true : false;
			fd.block	= ((list & 4) == 4) ? true : false;
			fd.allow	= ((list & 2) == 2) ? true : false;
			fd.forward	= ((list & 1) == 1) ? true : false;
			if (m.param.length > 3)
			fd.group	= account.gm.getGroupById(m.param[3] as String);
			fd.state	= FriendState.OFFLINE;

			var f:Friend = new Friend(fd);
			all[fd.email] = f;
			if (fd.group)
				fd.group.data.friends.push(f);
			if (fd.pending)
				pending.push(f);
			if (fd.reverse)
				reverse.push(f);
			if (fd.block)
				block.push(f);
			if (fd.allow)
				allow.push(f);
			if (fd.forward)
				forward.push(f);
			if (!fd.group)
				nogroup.push(f);

			numFriends++;
			if (numFriends == totalFriends)
				account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, account.mm.genNSCHG(account.data.t_state)));
		}
		
		private function onILN(m:Message):void
		{
			var state:String	= m.param[0] as String;
			var email:String	= unescape(m.param[1]) as String;
			var nick:String		= unescape(m.param[2]) as String;
			var cid:String		= m.param[3] as String;
			var f:Friend		= this.getFriendByEmail(email);
			if (f)
			{
				f.data.state= state;
				f.data.nick	= nick;
				f.data.cid	= cid;
			}
		}
		
		private function onNLN(m:Message):void
		{
			var state:String	= m.param[0] as String;
			var email:String	= unescape(m.param[1]) as String;
			var nick:String		= unescape(m.param[2]) as String;
			var cid:String		= m.param[3] as String;
			var f:Friend		= this.getFriendByEmail(email);
			if (f)
			{
				var temp:String = f.data.state;
				f.data.state= state;
				f.data.nick	= nick;
				f.data.cid	= cid;

				/*
				*	dispatch Event for external Interface
				*/
				var fe:FriendEvent = new FriendEvent(FriendEvent.STATE_CHANGE);
				fe.friend = f;
				fe.new_value = state;
				fe.old_value = temp;
				account.dispatchEvent(fe);
				f.dispatchEvent(fe);
			}

		}
		
		private function onADD(m:Message):void
		{
			var list_type:String = m.param[0] as String;
			var version:String = m.param[1] as String;
			var email:String = m.param[2] as String;
			var nick:String = m.param[3] as String;
			var f:Friend = getFriendByEmail(email);
			var fe:FriendEvent;
			
			if (f)
			{
				f.data.nick = nick;
				switch (list_type)
				{
				case ListType.ALLOWED:
					f.data.allow = true;
					this.allow.push(f);
					break;
				case ListType.BLOCKED:
					f.data.block = true;
					this.block.push(f);
					break;
				case ListType.FOWARD:
					f.data.forward = true;
					this.forward.push(f);
					break;
				case ListType.PENDING:
					f.data.pending = true;
					this.pending.push(f);
					break;
				case ListType.REVERSE:
					f.data.reverse = true;
					this.reverse.push(f);
					break;
				}
				/*
				*	dispatch Event for external Interface
				*/
				fe = new FriendEvent(FriendEvent.LIST_CHANGE);
				fe.friend = f;
				account.dispatchEvent(fe);
				f.dispatchEvent(fe);
			}
			else if (list_type == ListType.FOWARD)
			{
				var g:Group = account.gm.getGroupById(m.param[4] as String);
				var fd:FriendData = new FriendData();
				fd.account = account;
				fd.email = email;
				fd.nick = nick;
				
				fd.group = g;
				fd.allow = true;
				fd.block = false;
				fd.forward = true;
				fd.pending = false;
				fd.reverse = false;
				fd.state = FriendState.OFFLINE;
				
				f = new Friend(fd);
				all[fd.email] = f;
				g.data.friends.push(f);
				forward.push(f);
				totalFriends++;
				numFriends++;
				
				/*
				*	dispatch Event for external Interface
				*/
				fe = new FriendEvent(FriendEvent.NEW_FRIEND);
				fe.friend = f;
				account.dispatchEvent(fe);
			}
		}
		
		private function onREM(m:Message):void
		{
			var list_type:String = m.param[0] as String;
			var version:String = m.param[1] as String;
			var email:String = m.param[2] as String;
			var gid:String = (m.param.length > 3) ? m.param[3] : null;
			var friend:Friend = getFriendByEmail(email);
			var group:Group = (gid != null) ? account.gm.getGroupById(gid) : null;

			if (friend)
			{
				switch (list_type)
				{
				case ListType.FOWARD:
					friend.data.forward = false;
					forward.splice(forward.indexOf(friend),1);
					break;
				case ListType.ALLOWED:
					friend.data.allow = false;
					allow.splice(allow.indexOf(friend),1);
					break;
				case ListType.BLOCKED:
					friend.data.block = false;
					block.splice(block.indexOf(friend), 1); 
					break;
				case ListType.PENDING:
					friend.data.pending = false;
					pending.splice(pending.indexOf(friend), 1);
					break;
				case ListType.REVERSE:
					friend.data.reverse = false;
					reverse.splice(reverse.indexOf(friend), 1);
					break;
				}
				if (group)
				{
					group.data.friends.splice(group.data.friends.indexOf(friend),1);
				}
				
				/*
				*	dispatch Event for external Interface
				*/
				var fe:FriendEvent = new FriendEvent(FriendEvent.LIST_CHANGE);
				fe.friend = friend;
				account.dispatchEvent(fe);
				friend.dispatchEvent(fe);
			}
		}
		
		private function onREA(m:Message):void
		{
			var version:String = m.param[0] as String;
			var email:String = m.param[1] as String;
			var nick:String = m.param[2] as String;
			var friend:Friend = getFriendByEmail(email);
			
			if (friend)
			{
				var temp:String = friend.data.nick;
				friend.data.nick = nick;

				/*
				*	dispatch Event for external Interface
				*/
				var fe:FriendEvent = new FriendEvent(FriendEvent.NICK_CHANGE);
				fe.friend = friend;
				fe.old_value = temp;
				fe.new_value = nick;
				account.dispatchEvent(fe);
				friend.dispatchEvent(fe);
			}
		}
	}
}




