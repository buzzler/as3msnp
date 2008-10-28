package com.mobsword.as3msn.managers {
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.AccountEvent;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.objects.Account;
	
	/**
	* ...
	* @author Default
	*/
	public class AccountManager extends Manager
	{
		
		public function AccountManager(a:Account)
		{
			super(a);
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.GTC:	//대화 허용 상대 리스트에 없는 누군가가 사용자를 대화상대 목록에 추가한 상태라면 A, 그렇지 않다면 N
				break;
			case Command.BLP:	//메신저의 대화상대들이 사용자의 온라인 상태를 알 수 있고 대화 세션을 열 수 있다면 AL, 그렇지 않고 세션도 열 수 없다면 BL
				break;
			case Command.PRP:	//사용자정보. Friendly Name을 수정할 수 있다.
				onPRP(event.data);
				break;
			case Command.BPR:	//PRP와 비슷하지만 정확한 용도는 모르겠다.
				break;
			case Command.CHG:
				onCHG(event.data);
				break;
			}
		}
		
		private function onPRP(m:Message):void
		{
			switch (m.param[0])
			{
			case Command.MFN:
				var temp:String = account.data.nick;
				account.data.nick = m.param[1] as String;
				
				//	dispatch Event for external Interface
				var ae:AccountEvent = new AccountEvent(AccountEvent.NICK_CHANGE);
				ae.account = account;
				ae.old_value = temp;
				ae.new_value = account.data.nick;
				account.dispatchEvent(ae);
				break;
			case Command.MBE:
				break;
			case Command.WWE:
				break;
			}
		}
		
		private function onCHG(m:Message):void
		{
			var state:String = m.param[0] as String;
			var temp:String = account.data.state;
			account.data.state = state;
			
			//	dispatch Event for external Interface
			var ae:AccountEvent = new AccountEvent(AccountEvent.STATE_CHANGE);
			ae.account = account;
			ae.old_value = temp;
			ae.new_value = state;
			account.dispatchEvent(ae);
		}
	}
}