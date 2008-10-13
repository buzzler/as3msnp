package com.mobsword.as3msn.data
{
	import com.mobsword.as3msn.objects.Account;
	
	
	/**
	* ...
	* @author Default
	*/
	public class SessionData
	{
		public	var account:Account;	//����� ��d
		public	var id:String;			//���� ��/��
		public	var host:String;		//���� ������
		public	var port:int;			//���� ��Ʈ��ȣ
		public	var friends:Array;		//���ڵ�
		
		public	function SessionData():void
		{
			friends = new Array();
		}
	}
	
}