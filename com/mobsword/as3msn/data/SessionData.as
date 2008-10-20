package com.mobsword.as3msn.data
{
	import com.mobsword.as3msn.objects.Account;
	
	
	/**
	* ...
	* @author Default
	*/
	public class SessionData
	{
		public	var account:Account;
		public	var id:String;
		public	var	auth:String;
		public	var host:String;
		public	var port:int;
		public	var fromEmail:String;
		public	var fromNick:String;
		public	var friends:Array;
		
		public	function SessionData():void
		{
			friends = new Array();
		}
	}
	
}