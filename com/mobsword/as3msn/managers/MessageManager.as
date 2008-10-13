package com.mobsword.as3msn.managers
{
	import com.mobsword.as3msn.constants.Command;
	import com.mobsword.as3msn.constants.Info;
	import com.mobsword.as3msn.constants.ListType;
	import com.mobsword.as3msn.constants.LocaleType;
	import com.mobsword.as3msn.data.Message;
	import com.mobsword.as3msn.objects.Account;
	import com.mobsword.as3msn.objects.Friend;
	import com.mobsword.as3msn.objects.Group;
	import com.mobsword.as3msn.objects.Session;
	/**
	* ...
	* @author Default
	*/
	public class MessageManager extends Manager
	{
		public	function MessageManager(a:Account)
		{
			super(a);
		}

		/**
		 * Protocol version
		 * @return
		 */
		public	function genDSVER():Message
		{
			var m:Message = new Message();
			m.command = Command.VER;
			m.isText = true;
			m.param = ['MSNP9', 'MSNP8', 'CVR0'];
			//m.param = ['MSNP11', 'MSNP10', 'CVR0'];
			return m;
		}
		
		/**
		 * Sends version information
		 * @return
		 */
		public	function genDSCVR():Message
		{
			var m:Message = new Message();
			m.command = Command.CVR;
			m.isText = true;
			m.param = ['0x040c', 'winnt 5.1', 'i386', 'MSNMSGR', '7.0.0777', 'msmsgs', account.data.email];
			return m;
		}
		
		/**
		 * Authentication command
		 * @return
		 */
		public	function genDSUSR():Message
		{
			var m:Message = new Message();
			m.command = Command.USR;
			m.isText = true;
			m.param = ['TWN', 'I', account.data.email];
			return m;
		}
		
		/**
		 * Redirection to Notification server
		 * @return
		 */
		public	function genDSXFR():Message
		{
			return null;
		}

		/**
		 * Authentication command
		 * @return
		 */
		public	function genNSUSR(ticket:String):Message
		{
			var m:Message = new Message();
			m.command = Command.USR;
			m.isText = true;
			m.param = ['TWN', 'S', ticket];
			return m;
		}
		
		/**
		 * Initial settings download (deprecated as of MSNP13 , Passport 3.0)
		 * @return
		 */
		public	function genNSBLP():Message
		{
			return null;
		}
		
		/**
		 * Initial settings download (deprecated as of MSNP13 , Passport 3.0)
		 * @return
		 */
		public	function genNSBPR():Message
		{
			return null;
		}
		
		/**
		 * Initial contact list/settings download (deprecated as of MSNP13 , Passport 3.0)
		 * @return
		 */
		public	function genNSGTC():Message
		{
			return null;
		}
		
		/**
		 * Initial contact presence notification
		 * @return
		 */
		public	function genNSILN():Message
		{
			return null;
		}
		
		/**
		 * Initial contact list download - Groups (deprecated as of MSNP13 , Passport 3.0)
		 * @return
		 */
		public	function genNSLSG():Message
		{
			return null;
		}
		
		/**
		 * Initial contact list download - Contacts (deprecated as of MSNP13 , Passport 3.0)
		 * @return
		 */
		public	function genNSLST():Message
		{
			return null;
		}
		
		/**
		 * Initial profile download
		 * @return
		 */
		public	function genNSMSG():Message
		{
			return null;
		}
		
		/**
		 * Changing the friendly name
		 * @return
		 */
		public	function genNSMFN(new_name:String):Message
		{
			var m:Message = new Message();
			m.command = Command.PRP;
			m.isText = true;
			m.param = [Command.MFN, escape(new_name)];
			return m;
		}
		
		/**
		 * Add users to your contact lists
		 * @return
		 */
		public	function genNSADL():Message
		{
			var m:Message = new Message();
			m.command = Command.ADL;
			m.isBinary = true;
			return m;
		}
		
		/**
		 * Add users to your contact lists (deprecated as of MSNP13)
		 * @return
		 */
		public	function genNSADC(list_type:String, email:String, friendly_name:String = null):Message
		{
			var m:Message = new Message();
			m.command = Command.ADC;
			m.isText = true;
			if (friendly_name)
				m.param = [list_type, 'N=' + email, 'F=' + friendly_name];
			else
				m.param = [list_type, 'N=' + email];
			return m;
		}
		
		/**
		 * Add users to your contact lists (deprecated as of MSNP11)
		 * @return
		 */
		public	function genNSADD(list_type:String, email:String, friendly_name:String = null, group:Group = null):Message
		{
			var m:Message = new Message();
			m.command = Command.ADD;
			m.isText = true;
			var params:Array = [list_type, email];
			if (friendly_name)
				params.push(friendly_name);
			else
				params.push(email);
			if ((group)&&(list_type == ListType.FOWARD))
				params.push(group.data.id);
			else if (list_type == ListType.FOWARD)
				params.push("0");
			return m;
		}
		
		/**
		 * Create groups
		 * @return
		 */
		public	function genNSADG(name:String):Message
		{
			var m:Message = new Message();
			m.command = Command.ADG;
			m.isText = true;
			m.param = [escape(name), '0'];
			return m;
		}
		
		/**
		 * Change client's online status
		 * @return
		 */
		public	function genNSCHG(status:String):Message
		{
			var m:Message = new Message();
			m.command = Command.CHG;
			m.isText = true;
			m.param = [status, Info.CLIENT];
			return m;
		}
		
		/**
		 * Query client's online status
		 * @return
		 */
		public	function genNSFQY():Message
		{
			return null;
		}
		
		/**
		 * Unknown
		 * @return
		 */
		public	function genNSGCF():Message
		{
			return null;
		}
		
		/**
		 * Gracefully logout
		 * @return
		 */
		public	function genNSOUT():Message
		{
			var m:Message = new Message();
			m.command = Command.OUT;
			m.isEmbed = true;
			m.param = [];
			return m;
		}
		
		/**
		 * Client ping
		 * @return
		 */
		public	function genNSPNG():Message
		{
			return null;
		}
		
		/**
		 * Server response to PNG
		 * @return
		 */
		public	function genNSQNG():Message
		{
			return null;
		}
		
		/**
		 * Response to CHL by client
		 * @return
		 */
		public	function genNSQRY(md5digest:String):Message
		{
			var m:Message = new Message();
			m.command = Command.QRY;
			m.isBinary = true;
			m.param = [Info.PRD_ID];
			m.data = md5digest;
			return m;
		}

		/**
		 * Unknown
		 * @return
		 */
		public	function genNSSBS():Message
		{
			return null;
		}
		
		/**
		 * Begin synchronization/download contact list (deprecated as of MSNP13 , Passport 3.0)
		 * @return
		 */
		public	function genNSSYN():Message
		{
			var m:Message = new Message();
			m.command = Command.SYN;
			m.isText = true;
			m.param = [Info.LISTVER];
			return m;
		}

		
		/**
		 * Change display name
		 * @return
		 */
		public	function genNSREA(new_name:String):Message
		{
			var m:Message = new Message();
			m.command = Command.REA;
			m.isText = true;
			m.param = [account.data.email, escape(new_name)];
			return m;
		}
		
		/**
		 * Rename groups (deprecated as of MSNP13 , Passport 3.0)
		 * @return
		 */
		public	function genNSREG(group:Group, new_name:String):Message
		{
			var m:Message = new Message();
			m.command = Command.REG;
			m.isText = true;
			m.param = [group.data.id, escape(new_name)];
			return m;
		}
		
		/**
		 * Remove contacts (deprecated as of MSNP13 , Passport 3.0)
		 * @return
		 */
		public	function genNSREM(list_type:String, friend:Friend):Message
		{
			var m:Message = new Message();
			m.command = Command.REM;
			m.isText = true;
			m.param = [list_type, friend.data.email];
			if ((friend.data.group)&&(list_type == ListType.FOWARD))
				m.param.push(friend.data.group.data.id);
			return m;
		}
		
		/**
		 * Remove contact
		 * @return
		 */
		public	function genNSRML():Message
		{
			return null;
		}
		
		/**
		 * Remove groups
		 * @return
		 */
		public	function genNSRMG(group:Group):Message
		{
			var m:Message = new Message();
			m.command = Command.RMG;
			m.isText = true;
			m.param = [group.data.id];
			return m;
		}
		
		/**
		 * Opens new chat session on switchboard server
		 * @return
		 */
		public	function genNSXFR():Message
		{
			var m:Message = new Message();
			m.command = Command.XFR;
			m.isText = true;
			m.param = ['SB'];
			return m;
		}
		
		/**
		 * Inform you with a user PSM/Media
		 * @return
		 */
		public	function genNSUBX(personal_message:String = '', current_media:String = ''):Message
		{
			var m:Message = new Message();
			m.command = Command.UBX;
			m.isBinary = true;
			m.param = [account.data.email];
			m.data = '<Data><PSM>' + personal_message + '</PSM><CurrentMedia></CurrentMedia></Data>';
			return m;
		}
		
		/**
		 * Sends an email invitation to a Passport member
		 * @return
		 */
		public	function genNSSDC(friend:Friend, your_message:String, locale_type:String = LocaleType.ENGLISH_US):Message
		{
			var m:Message = new Message();
			m.command = Command.SDC;
			m.isBinary = true;
			m.param = [friend.data.email, locale_type, 'MSMSGS', 'WindowsMessenger', 'X', 'X', escape(account.data.name)];
			m.data = your_message;
			return m;
		}
		
		/**
		 * Block or allow new switchboard sessions
		 * @return
		 */
		public	function genNSIMS(on_off:Boolean):Message
		{
			var m:Message = new Message();
			m.command = Command.IMS;
			m.isText = true;
			m.param = [(on_off) ? 'on' : 'off'];
			return m;
		}
		
		/**
		 * Client challenge
		 * @return
		 */
		public	function genNSCHL():Message
		{
			return null;
		}
		
		/**
		 * Principal signed off
		 * @return
		 */
		public	function genNSFLN():Message
		{
			return null;
		}
		
		/**
		 * Principal changed presence/signed on
		 * @return
		 */
		public	function genNSNLN():Message
		{
			return null;
		}
		
		/**
		 * Client invited to chat session
		 * @return
		 */
		public	function genNSRNG():Message
		{
			return null;
		}
		
		/**
		 * Log in to switchboard chat session using invitation
		 * @return
		 */
		public	function genSBANS(ticket:String, session:Session):Message
		{
			var m:Message = new Message();
			m.command = Command.ANS;
			m.isText = true;
			m.param = [account.data.email, ticket, session.data.id];
			return m;
		}
		
		/**
		 * Defines which principals are in the current chat session
		 * @return
		 */
		public	function genSBIRO():Message
		{
			return null;
		}
		
		/**
		 * Log in to switchboard chat session after requesting session from NS
		 * @return
		 */
		public	function genSBUSR():Message
		{
			return null;
		}
		
		/**
		 * Invite a user to a chat session
		 * @return
		 */
		public	function genSBCAL(friend:Friend):Message
		{
			var m:Message = new Message();
			m.command = Command.CAL;
			m.isText = true;
			m.param = [friend.data.email];
			return m;
		}
		
		/**
		 * Response to CAL, when user connected successfully
		 * @return
		 */
		public	function genSBJOI():Message
		{
			return null;
		}
		
		/**
		 * Used to send and receive messages in the chat session
		 * @return
		 */
		public	function genSBMSG():Message
		{
			return null;
		}
		
		/**
		 * Contact has left conversation
		 * @return
		 */
		public	function genSBBYE():Message
		{
			return null;
		}
		
		/**
		 * Gracefully leave switchboard chat session
		 * @return
		 */
		public	function genSBOUT():Message
		{
			return null;
		}
		
/*		
		public	function genPVER():Message
		{
			var m:Message = new Message();
			m.command	= Command.PVER;
			m.isText	= true;
			m.param		= ['3.615', '3.0'];
			return m;
		}

		public	function genAUTH():Message
		{
			var m:Message = new Message();
			m.command	= Command.AUTH;
			m.isText	= true;
			m.param		= ['DES'];
			return m;
		}

		public	function genREQS():Message
		{
			var m:Message = new Message();
			m.command	= Command.REQS;
			m.isText	= true;
			m.param		= ['DES', account.data.email];
			return m;
		}

		public	function genLSIN():Message
		{
			var id:String;
			if (account.data.email.indexOf('@nate.') >= 0)
				id = account.data.email.substr(0, account.data.email.indexOf('@'));
			else
				id = account.data.email;
			var md5:String	= MD5.hash(account.data.password + id);
			var m:Message	= new Message();
			m.command	= Command.LSIN;
			m.isText	= true;
			m.param		= [account.data.email, md5, 'MD5', '3.615', 'UTF8'];
			return m;
		}

		public	function genLIST():Message
		{
			var m:Message = new Message();
			m.command	= Command.LIST;
			m.isText	= true;
			return m;
		}

		public	function genGLST():Message
		{
			var m:Message = new Message();
			m.command	= Command.GLST;
			m.isText	= true;
			m.param		= ['0'];
			return m;
		}

		public	function genONST(state:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ONST;
			m.isText	= true;
			m.param		= [state, '0'];
			return m;
		}

		public	function genCONF():Message
		{
			var m:Message = new Message();
			m.command	= Command.CONF;
			m.isText	= true;
			m.param		= ['3821', '0'];
			return m;
		}

		public	function genCNIK(nick:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.CNIK;
			m.isText	= true;
			m.param		= [Codec.encode(nick)];
			return m;
		}

		public	function genADSB(email:String, g:String, msg:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ADSB;
			m.isText	= true;
			m.param		= ['REQST', '%00', Codec.encode(email), g, Codec.encode(msg)];
			return m;
		}

		public	function genADDB(email:String, id:String, list:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ADDB;
			m.isText	= true;
			m.param		= [list, id, email];
			return m;
		}

		public	function genRMVB(email:String, id:String, list:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.RMVB;
			m.isText	= true;
			m.param		= [list, id, email, '0'];
			return m;
		}

		public	function genMVBG(email:String, id:String, fromG:String, toG:String):Message
		{
			var payload:Array = ['0', id, email, fromG, toG]; 
			var m:Message = new Message();
			m.command	= Command.MVBG;
			m.isBinary	= true;
			m.param		= [account.gm.version];
			m.data		= payload.join(' ') + '\r\n';
			return m;
		} 

		public	function genADDG(n:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ADDG;
			m.isText	= true;
			m.param		= [account.gm.version, Codec.encode(n)];
			return m;
		}

		public	function genRENG(g:String, n:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.RENG;
			m.isText	= true;
			m.param		= [account.gm.version, g, Codec.encode(n)];
			return m;
		}

		public	function genRMVG(g:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.RMVG;
			m.isText	= true;
			m.param		= [account.gm.version, g];
			return m;
		}

		public	function genPING():Message
		{
			var m:Message = new Message();
			m.command	= Command.PING;
			m.isText	= true;
			return m;
		}

		public	function genRESS():Message
		{
			var m:Message = new Message();
			m.command	= Command.RESS;
			m.isText	= true;
			return m;
		}

		public	function genCTOC(email:String, msg:Message):Message
		{
			var m:Message = new Message();
			m.command	= Command.CTOC;
			m.isBinary	= true;
			m.param		= [email, 'N'];
			m.data		= msg.toString();
			return m;
		}

		public	function genINVT(host:String, port:int, s:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.INVT;
			m.isEmbed	= true;
			m.param		= [account.data.email, host, port.toString(), s];
			return m;
		}

		public	function genENTR(s:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.ENTR;
			m.isText	= true;
			m.param		= [account.data.email, Codec.encode(account.data.nick), Codec.encode(account.data.name), s, 'UTF8', 'P'];
			return m;
		}

		public	function genMESG(msg:Message):Message
		{
			var m:Message = new Message();
			m.command	= Command.MESG;
			m.isText	= true;
			m.param		= [msg.toString()];
			return m;
		}

		public	function genMSG(msg:String, font:String, color:String, type:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.MSG;
			m.isEmbed	= true;
			m.param		= [font+'%09'+color+'%09'+type+'%09'+Codec.encode(msg)];
			return m;
		}

		public	function genTYPING(type:String):Message
		{
			var m:Message = new Message();
			m.command	= Command.TYPING;
			m.isEmbed	= true;
			m.param		= [type];
			return m;
		}

		public	function genEMOTICON(custom:Boolean):Message
		{
			var m:Message = new Message();
			m.command	= Command.EMOTICON;
			m.isEmbed	= true;
			if (custom)
				m.param	= ['USECUST%091'];
			else
				m.param	= ['USECUST%090'];
			return m;
		}
*/		
	}
}



