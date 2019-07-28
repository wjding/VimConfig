" Vim syntax file
" $Id: debug.log.vim,v 1.4 2005/02/11 06:05:02 wjding Exp $ 
" Language:	
" Maintainer:	Steven Ding
" Last Change:	2004 Jun. 16
" $Log: debug.log.vim,v $
" Revision 1.4  2005/02/11 06:05:02  wjding
" Add call to logfunc.vim and map a command \gs
"
" Revision 1.3  2004/08/03 06:33:44  wjding
" Add two key words: EMsgSetAppStateTimerReq EMsgSetAppStateTimerRsp
"
" Revision 1.2  2004/06/30 09:39:39  wjding
" Add in Id and Log for CVS.
"
"

" API messages
syn keyword cApiMessage EMsgAnalyzeDigit EMsgAnswerReceived EMsgCallCreated EMsgCallReceived EMsgCallReleased EMsgConferenceConnected EMsgConferenceCreated EMsgConferenceDisconnected EMsgConferenceReleased EMsgConnectConference EMsgConnectTrunk EMsgCreateCall EMsgCreateConference EMsgDialTrunk EMsgDigitAnalyzed EMsgDisconnectConference EMsgInformationIndication EMsgInformationResponse EMsgNumberQueryReq EMsgNumberQueryRsp EMsgParkTrunk EMsgReleaseCall EMsgReleaseConference EMsgReleaseTrunk EMsgTrunkConnected EMsgTrunkDialed EMsgTrunkParked EMsgTrunkReleased EMsgSetAppStateTimerReq EMsgSetAppStateTimerRsp
"syn keyword cComment ctiExtQueryHostStatus ctiExternalCommand

" CSA Number
syn match Csa display "\<CallID=-\{0,1\}[0-9]*"
syn match Trunk display "\<TrunkNumber=-\{0,1\}[0-9]*"
syn match Resource display "\<ResourceNumber=-\{0,1\}[0-9]*"
syn match Calling display "\<CallingNumber=[0-9]*"
syn match Called display "\<CalledNumber=[0-9]*"
syn match Dialed display "\<DialedNumber=[0-9]*"
syn match Error display "\[ERROR.*" contains=cApiMessage,Csa,Key,cNumber

" API Message
syn region cApiMContent start=/^\tSequenceNumber=/ end=/^\[/ contains=Csa,cNumbers,Trunk,Resource,Calling,Called,Dialed

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	cNumbers	display transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctalError,cOctal

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_debuglog_syn_inits")
  if version < 508
    let did_debuglog_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cFormat		cSpecial
  HiLink cCppString		cString
  HiLink cCommentL		cComment
  HiLink cCommentStart		cComment
  HiLink Csa			Label
  HiLink Trunk			Label
  HiLink Resource		Label
  HiLink Calling		Label
  HiLink Called			Label
  HiLink Dialed			Label
  HiLink Key			Label
  HiLink cUserLabel		Label
  HiLink cConditional		Conditional
  HiLink cRepeat		Repeat
  HiLink cCharacter		Character
  HiLink cSpecialCharacter	cSpecial
  HiLink cNumber		Number
  HiLink cOctal			Number
  HiLink cOctalZero		PreProc	 " link this to Error if you want
  HiLink cFloat			Float
  HiLink cOctalError		cError
  HiLink cParenError		cError
  HiLink cErrInParen		cError
  HiLink cErrInBracket		cError
  HiLink cCommentError		cError
  HiLink cCommentStartError	cError
  HiLink cSpaceError		cError
  HiLink cSpecialError		cError
  HiLink cOperator		Operator
  HiLink cStructure		Structure
  HiLink cStorageClass		StorageClass
  HiLink cInclude		Include
  HiLink cPreProc		PreProc
  HiLink cDefine		Macro
  HiLink cIncluded		cString
  HiLink cError			Error
  HiLink cStatement		Statement
  HiLink cPreCondit		PreCondit
  HiLink cType			Type
  HiLink cApiMessage		Type
  HiLink cConstant		Constant
  HiLink cCommentString		cString
  HiLink cComment2String	cString
  HiLink cCommentSkip		cComment
  HiLink cString		String
  HiLink cComment		Comment
  HiLink cSpecial		SpecialChar
  HiLink cTodo			Todo
  HiLink cCppSkip		cCppOut
  HiLink cCppOut2		cCppOut
  HiLink cCppOut		Comment
  HiLink cApiMContent		ModeMsg

  delcommand HiLink
endif

so ~/.vim/ftplugin/logfunc.vim

let b:current_syntax = "debuglog"

" vim: ts=8

