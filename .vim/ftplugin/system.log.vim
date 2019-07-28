" Vim syntax file
" $Id: system.log.vim,v 1.7 2005/02/11 06:05:03 wjding Exp $ 
"
" Log:		system.log
" Maintainer:	Steven Ding (wjding@lucent.com)
" Last Change:	2004 Jun. 16
"
" $Log: system.log.vim,v $
" Revision 1.7  2005/02/11 06:05:03  wjding
" Add call to logfunc.vim and map a command \gs
"
" Revision 1.6  2004/07/08 08:35:45  wjding
" Change the Error syntax definition because of lack of a "\".
"
" Revision 1.5  2004/07/06 01:10:37  wjding
" Add my mail in the header.
"
" Revision 1.4  2004/07/06 01:08:51  wjding
" Add "Err" matching.
"
" Revision 1.3  2004/07/06 01:07:33  wjding
" Update SPN/CHN matching.
"
" Revision 1.2  2004/06/30 09:39:39  wjding
" Add in Id and Log for CVS.
" 

" API messages
syn keyword cApiMessage ctiExtAnalyzeDigits ctiExtAnswerReceived ctiExtCallReceived ctiExtConnectConference ctiExtConnectTrunk ctiExtCreateCall ctiExtCreateConference ctiExtDialTrunk ctiExtDisconnectConference ctiExtInformationResponse ctiExtNumberQueryResponse ctiExtParkTrunk ctiExtReleaseCall ctiExtReleaseConference ctiExtReleaseTrunk ctiExtResetHost ctiExtSystemStatusReported ctiExtTrunkReleased ctiSendAnswerReceived ctiSendCallCreated ctiSendCallReceived ctiSendCallReleased ctiSendConferenceConnected ctiSendConferenceCreated ctiSendConferenceDisconnected ctiSendConferenceReleased ctiSendDigitAnalyzed ctiSendInformationIndication ctiSendNumberQueryRequest ctiSendTrunkConnected ctiSendTrunkDialed ctiSendTrunkParked ctiSendTrunkReleased ctiExtLoginRequest ctiExtLogoutRequest
syn keyword cH225Message ALERT CONNECT FAC PROCEED REL
syn keyword cH245Message VDAC_OLC_ACK VDAC_TERMCAP_ACK
"syn keyword cComment ctiExtQueryHostStatus ctiExternalCommand

" CSA Number
if version >= 600
  syn match Csa display "CSA -\{0,1\}:\{0,1\}[0-9]*"
  syn match Key display "\(SPN\|CHN\)[ 	]-\{0,1\}:\{0,1\}[0-9]*"
  syn match Key display "\(virtual\|vitual\) trunk [0-9]\{1,\}"
  syn match cNumber display "from DNIS = ([0-9]*)([0-9]*)"
  syn match Error display "\(ERROR\|Error\|Err\).*" contains=cApiMessage,Csa,Key,cNumber
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
if version >= 600
  syn match	cNumbers	display transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctalError,cOctal
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_c_syn_inits")
  if version < 508
    let did_c_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cFormat		cSpecial
  HiLink cCppString		cString
  HiLink cCommentL		cComment
  HiLink cCommentStart		cComment
  HiLink cH225Message		cComment
  HiLink cH245Message		cComment
  HiLink Csa			Label
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

  delcommand HiLink
endif

so ~/.vim/ftplugin/logfunc.vim

let b:current_syntax = "system.log"

" vim: ts=8
