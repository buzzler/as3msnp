package com.mobsword.as3msn.data
{
	import com.mobsword.as3msn.objects.Account;
	import com.mobsword.as3msn.objects.Group;
	
	public class FriendData
	{
		public	var account	:Account;
		public	var cid		:String;
		public	var email	:String;
		public	var nick	:String;
		public	var state	:String;
		public	var	cuid	:String;
		public	var block	:Boolean;
		public	var forward	:Boolean;
		public	var allow	:Boolean;
		public	var reverse	:Boolean;
		public	var pending	:Boolean;
		public	var group	:Group;
	}
}