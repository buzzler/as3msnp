package com.mobsword.as3msn.data
{
	import com.mobsword.as3msn.objects.Account;
	
	
	/**
	* ...
	* @author Default
	*/
	public class GroupData
	{
		public	var account	:Account;	//사용자 계정
		public	var id		:String;	//그룹 고유값
		public	var name	:String;	//그룹 이름
		public	var friends	:Array;		//그룹에 속한 친구들
		
		public function GroupData()
		{
			friends = new Array();
		}
		
	}
	
}