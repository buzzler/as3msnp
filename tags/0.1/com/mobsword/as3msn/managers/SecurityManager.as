package com.mobsword.as3msn.managers 
{
	import com.adobe.crypto.MD5;
	import com.adobe.net.URI;
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.constants.Info;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.events.RadioEvent;
	import com.mobsword.as3msn.events.SecurityEvent;
	import com.mobsword.as3msn.objects.Account;
	
	import org.httpclient.HttpClient;
	import org.httpclient.events.HttpStatusEvent;
	import org.httpclient.http.Get;

	public class SecurityManager extends Manager
	{
		private var params:String;

		public function SecurityManager(a:Account):void
		{
			super(a);
		}
		
		override protected function onIncoming(event:RadioEvent):void
		{
			switch (event.data.command)
			{
			case Command.USR:
				onUSR(event.data);
				break;
			case Command.CHL:
				onCHL(event.data);
				break;
			case Command.QRY:
				onQRY(event.data);
				break;
			}
		}
		
		private function onCHL(m:Message):void
		{
			var digest:String = m.param[0] as String;
			digest += Info.PRD_KEY;
			var hash:String = MD5.hash(digest);
			account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, account.mm.genNSQRY(hash)));
		}
		
		private function onUSR(m:Message):void
		{
			switch (m.param[0])
			{
			case 'TWN':
				params = m.param[2] as String;
				auth(Info.URI);
				break;
			case 'OK':
				//	dispatch Event for external Interface
				var se:SecurityEvent = new SecurityEvent(SecurityEvent.AUTH_SUCCESS);
				account.dispatchEvent(se);
				account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, account.mm.genNSSYN()));
				break;
			}
		}
		
		private function onQRY(m:Message):void
		{
			//	dispatch Event for external Interface
			var se:SecurityEvent = new SecurityEvent(SecurityEvent.CHALLENGE_SUCCESS);
			account.dispatchEvent(se);
		}

		private function auth(uri:String):void
		{
			var _uri:URI = new URI(uri);
			var request:Get = new Get();
			request.addHeader('Authorization','Passport1.4 OrgVerb=GET,OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom,sign-in='+account.data.email+',pwd='+account.data.password+','+params);
			var client:HttpClient = new HttpClient();
			client.addEventListener(HttpStatusEvent.STATUS, onAuth);
			client.request(_uri, request);
		}
		
		private function onAuth(event:HttpStatusEvent):void
		{
			event.target.removeEventListener(HttpStatusEvent.STATUS, onAuth);
			switch (event.code)
			{
			case '200':
				var ticket:String = event.header.content.substring(event.header.content.lastIndexOf("from-PP='")+9, event.header.content.lastIndexOf("'"));
				account.radio.broadcast(new RadioEvent(RadioEvent.OUTGOING_DATA, account.mm.genNSUSR(ticket)));
				break;
			case '302':
				var uri:String = event.header.getValue('Location');
				auth(uri);
				break;
			default:
				//ERROR!!!! Unauthorized
				break;
			}
		}

	}
}