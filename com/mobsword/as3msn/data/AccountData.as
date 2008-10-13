/**
* ...
* @author Default
* @version 0.1
*/

package com.mobsword.as3msn.data
{
	public class AccountData
	{
		public	var email	:String;	//사용자 계정
		public	var password:String;	//계정 비밀번호
		public	var state	:String;	//계정의 상태
		public	var t_state	:String;	//접속시 초기 상태
		public	var nick	:String;	//별명
		public	var name	:String;	//이름
		public	var ticket	:String;	//문자메시지등 다른 서비스를 이용하기위한 티켓
		public	var groups	:Array;		//대화상대 그룹들
		public	var friends	:Array;		//대화상대들
		
		public	function AccountData():void
		{
			groups	= new Array();
			friends	= new Array();
		}
	}
	
}
