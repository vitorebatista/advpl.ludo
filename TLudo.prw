#INCLUDE "PROTHEUS.CH"

#DEFINE __cDirectory__ GetTempPath() //+"LUDO"+If(IsSrvUnix(),"/","\") //"C:\LUDO\" //

Static cMGet := ""

user function abc()
return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Classe    ³TLudo      ³Autor ³ Felipe Nathan Welter  ³ Data ³08/09/2010³±±
±±³          ³           ³      ³ Vitor Emanuel Batista ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Class TLudo

	DATA nRow    AS INTEGER
	DATA nCol    AS INTEGER
	DATA nWidth  AS INTEGER
	DATA nHeight AS INTEGER
	DATA oWnd    AS OBJECT
	DATA oTPanel AS OBJECT
	DATA oMGet AS OBJECT
	DATA nId     AS INTEGER
	DATA oBlue   AS OBJECT
	DATA oYellow AS OBJECT
	DATA oRed    AS OBJECT
	DATA oGreen  AS OBJECT
	DATA nMsgCnt AS INTEGER

	DATA aTrack  AS ARRAY INIT {} //Posicoes X e Y do caminho a ser percorrido
	DATA aTrackWin AS ARRAY INIT {} //Posicoes de X e Y do caminho de vitoria
	DATA nIdDice AS INTEGER //Id do shape do Dado
	DATA nTurn AS INTEGER //jogador da vez

	DATA oDice AS OBJECT //Objeto Dado
	DATA nValueDice AS INTEGER //Valor atual do Dado

	DATA lTurn AS BOOLEAN
	DATA lDice AS BOOLEAN

	DATA oKingdom1 AS OBJECT
	DATA oKingdom2 AS OBJECT
	DATA oKingdom3 AS OBJECT
	DATA oKingdom4 AS OBJECT

	DATA oPlayer1 AS OBJECT
	DATA oPlayer2 AS OBJECT
	DATA oPlayer3 AS OBJECT
	DATA oPlayer4 AS OBJECT

	Method ExportImage()

	Method New(nRow,nCol,nWidth,nHeight,oWnd) CONSTRUCTOR
	Method SetId()
	Method DirectoryImg()

	Method SeekSoldier(nShapeAtu)

	Method PrintDice(nValue) //Imprime o dado
	Method RandomDice() //Gera valor random para o dado
	Method PlayDice() //Metodo para o Jogador jogar o Dado

	Method StatusMsg(cMsg)	//Imprime na tela texto informativo

	Method NewGame(oP1,oP2,oP3,oP4) //Novo jogo
	Method Play(nVez)

EndClass

//--------------------------------------------------------
Method New(nRow,nCol,nWidth,nHeight,oWnd) Class TLudo
	::nRow    := nRow
	::nCol    := nCol
	::nWidth  := nWidth
	::nHeight := nHeight
	::oWnd    := oWnd
	::nId     := 0
	::nIdDice := 0
	::nValueDice := 6

	::nMsgCnt := 0
	::lTurn   := .F.
	::lDice   := .T.

	::aTrack := {	{202,436},{202,402},{202,368},{202,334},{202,300},;
						{170,270},{136,270},{102,270},{068,270},{034,270},{000,270},;
						{000,235},{000,201},;
						{034,201},{068,201},{102,201},{136,201},{170,201},;
						{202,170},{202,136},{202,102},{202,068},{202,034},{202,000},;
						{236,000},{270,000},;
						{270,034},{270,068},{270,102},{270,136},{270,170},;
						{301,201},{335,201},{369,201},{403,201},{438,201},{471,201},;
						{471,235},{471,269},;
						{438,270},{403,270},{369,270},{335,270},{301,270},;
						{270,300},{270,334},{270,368},{270,402},{270,436},;
						{270,470},{236,470},{202,470};
					}
	::aTrackWin := {	{{236,034},{236,068},{236,102},{236,136},{236,170},{236,204}},; //BLUE
							{{438,235},{403,235},{369,235},{335,235},{301,235},{267,235}},; //YELLOW
							{{236,436},{236,402},{236,368},{236,334},{236,300},{236,266}},; //GREEN
							{{034,236},{068,236},{102,236},{136,236},{170,236},{204,236}}} //RED

	::ExportImage()

	::oTPanel := tPaintPanel():New(nRow,nCol,nWidth,nHeight,oWnd)
		::oTPanel:Align := CONTROL_ALIGN_ALLCLIENT

		::oMGet:= tMultiget():New (10,260,{|u|if(Pcount()>0,cMGet:=u,cMGet)},::oTPanel,110,145,,.T.,,,,.T.,,,,,,.F.,,,,.F.,)
			::oMGet:EnableHScroll(.T.)

		::oDice := TButton():New( 160, 290, "Jogar Dado",::oTPanel,{|| ::PlayDice()},40,15,,,.F.,.T.,.F.,,.F.,{|| ::lDice},,.F. )
		::oDice:SetCss("QPushButton{ border-radius: 3px;border: 1px solid #4D90FE; color: #FFFFFF; background-color: #3079ED;  }")

		//::oTPanel:blClicked := {|nPosX,nPosY| Alert("X: "+Str(nPosX) + "Y: "+Str(nPosY))}
		::oTPanel:blClicked := {|nPosX,nPosY| LeftClick(Self,nPosX,nPosY)}

		//Cria Container
		::oTPanel:addShape("id="+cValToChar(::SetId())+";type=1;left=0;top=0;width="+cValToChar(::oTPanel:nWidth)+";height="+cValToChar(::oTPanel:nHeight)+";"+;
		               	 "gradient=1,0,0,0,0,0.0,#FFFFFF;pen-width=1;pen-color=#ffffff;can-move=0;can-mark=0;is-container=1;")

		//Cria imagem do tabuleiro
		::oTPanel:addShape("id="+cValToChar(::SetId())+";type=8;left=0;top=0;"+;
								";width=730;height=722;image-file="+::DirectoryImg()+"\ludo.png;can-move=0;can-deform=0;is-container=1;")

		::oKingdom1 := TLudoKingdom():New("BLUE",Self)
		::oKingdom2 := TLudoKingdom():New("YELLOW",Self)
		::oKingdom3 := TLudoKingdom():New("GREEN",Self)
		::oKingdom4 := TLudoKingdom():New("RED",Self)

		::oPlayer1 := 	TPlayer():New(1,::oKingdom1)
		::oPlayer2 := 	TPlayer():New(2,::oKingdom2)
		::oPlayer3 := 	TPlayer():New(2,::oKingdom3)
		::oPlayer4 := 	TPlayer():New(2,::oKingdom4)

		::StatusMsg("Tire o número 1 ou 6 para sair com o peão.")
Return Self

//--------------------------------------------------------
Method DirectoryImg() Class TLUDO
Return __cDirectory__

//--------------------------------------------------------
Method SetId() Class TLUDO
Return ++::nId

Method PrintDice(nValue) Class TLUDO
	Local nRow := 385
	Local nCol := 590

	If ::nIdDice > 0
		::oTPanel:DeleteItem(::nIdDice)
	Else
		::nIdDice := ::SetId()
	EndIf

	::oTPanel:addShape("id="+cValToChar(::nIdDice)+";type=8;left="+cValToChar(nCol)+";top="+cValToChar(nRow)+";"+;
					";width=730;height=722;image-file="+::DirectoryImg()+"\DADO"+cValToChar(nValue)+".png;can-move=0;can-deform=0;is-container=1;")

Return

//--------------------------------------------------------
Method RandomDice() Class TLUDO
	Local nX

	For nX := 1 To 4
		::nValueDice := Randomize(1,7)
		::PrintDice(::nValueDice)
		::oWnd:CtrlRefresh()
		::oWnd:Refresh()
		::oWnd:CommitControls()
		sleep(100)
	Next nX

Return ::nValueDice

//--------------------------------------------------------
Method StatusMsg(cMsg) Class TLUDO
	/*::oMGet:GoEnd()

*/
	//cMGet += "["+cValToChar((::nMsgCnt++))+"] "+cMsg+CRLF
	::oMGet:AppendText("["+cValToChar((::nMsgCnt++))+"] "+cMsg+CRLF)

	::oMGet:SetFocus()
	::oMGet:Refresh()
	::oWnd:Refresh()
	::oTPanel:Refresh()
	::oTPanel:SetFocus()
	::oWnd:CommitControls()
	//::oMGet:GoEnd()
Return

//--------------------------------------------------------
Method NewGame(oP1,oP2,oP3,oP4) Class TLUDO

	Local aValues := Array(4)
	Local nX := 1, nMax := 0, nFst := 0, nPlyrs := 0

	::nMsgCnt := 0

	While nFst == 0
		::RandomDice()
		aValues[1]  := {::nValueDice,1}
		::StatusMsg("Jogador "+cValToChar(aValues[1,2])+" tirou "+cValToChar(aValues[1,1])+".")
		//::StatusMsg("Jogue o dado para saber quem começa a partida!")
		::RandomDice()
		aValues[2]  := {::nValueDice,2}
		::StatusMsg("Jogador "+cValToChar(aValues[2,2])+" tirou "+cValToChar(aValues[2,1])+".")
		::RandomDice()
		aValues[3]  := {::nValueDice,3}
		::StatusMsg("Jogador "+cValToChar(aValues[3,2])+" tirou "+cValToChar(aValues[3,1])+".")
		::RandomDice()
		aValues[4]  := {::nValueDice,4}
		::StatusMsg("Jogador "+cValToChar(aValues[4,2])+" tirou "+cValToChar(aValues[4,1])+".")

		//identifica maior valor gerado
	   aEval(aValues,{|x|If(x[1] > nMax,nMax := x[1],Nil)})
		//identifica quantidade de jogadores com o maior valor
	   aEval(aValues,{|x|If(x[1] = nMax,nPlyrs++,Nil)})
		If (nPlyrs > 1)
			::StatusMsg("Houve empate entre "+cValToChar(nPlyrs)+" jogadores. Novo lançamento necessário.")
			nPlyrs := 0
			nMax := 0
		Else
			aEval(aValues,{|x|If(x[1] = nMax,nFst := x[2],Nil)})
			::StatusMsg("Jogador a começar: "+cValToChar(nFst))
		EndIf
	EndDo

	::Play(nFst)

Return

Method PlayDice() Class TLUDO
	Local aSoldier := {::oKingdom1:oSoldier1,::oKingdom1:oSoldier2,::oKingdom1:oSoldier3,::oKingdom1:oSoldier4}
	Local lMove    := .F.
	Local nX

	::RandomDice()

	::StatusMsg("Você tirou "+cValToChar(::nValueDice))

	/*If ::oKingdom1:oSoldier1:nTrack == 0 .And. ;
		::oKingdom1:oSoldier2:nTrack == 0 .And. ;
		::oKingdom1:oSoldier3:nTrack == 0 .And. ;
		::oKingdom1:oSoldier4:nTrack == 0 .And. ;
		::nValueDice != 1 .And. ::nValueDice != 6

		lMove := .F.
	Else*/
	For nX := 1 To Len(aSoldier)
		If !aSoldier[nX]:lWin .And. (!aSoldier[nX]:lTrackWin .Or. aSoldier[nX]:nTrack + ::nValueDice <= 6) .And.;
			(aSoldier[nX]:nTrack > 0 .Or. ::nValueDice == 1 .Or. ::nValueDice == 6)
			lMove := .T.
		EndIf
	Next nX

	//EndIf

	If lMove
		::lTurn := .T.
		::lDice := .F.
		::StatusMsg("Movimente um soldado.")
	Else
		::StatusMsg("Pulando jogada")
		::Play(2)
	EndIf

Return


//--------------------------------------------------------
Method Play(nTurn) Class TLUDO
	Local nX, x, y, nPos
	Local oSoldierMove
	Local nRandom  := ::RandomDice()
	Local aPlayer  := {::oPlayer1,::oPlayer2,::oPlayer3,::oPlayer4}
	Local aSoldier := {	aPlayer[nTurn]:oKingdom:oSoldier1,aPlayer[nTurn]:oKingdom:oSoldier2,;
								aPlayer[nTurn]:oKingdom:oSoldier3,aPlayer[nTurn]:oKingdom:oSoldier4}
	Local aValues := {{0,1,0,0},{0,2,0,0},{0,3,0,0},{0,4,0,0}} //{y-x,soldier,x,y}

	::nTurn := nTurn

	If ::nTurn != 1  //vez do computador

		::StatusMsg("Vez do Jogador "+cValToChar(::nTurn)+" ("+aPlayer[::nTurn]:oKingdom:cColor+")")

		//Seleciona qual soldado ira mover
		For nX := 1 To 4
			aSoldier[nX]:updateValues()

			//- FR: fator de risco: Número inteiro, de 0 a 1, que define o risco sobre determinada peça em um momento determinado:
			nFR  := (aSoldier[nX]:nAB1 * 0.75 + aSoldier[nX]:nAB2 * 0.25) / 6

			//- FA: fator de ataque:
			nFA  := (aSoldier[nX]:nAF1 * 0.75 + aSoldier[nX]:nAF2 * 0.25) / 6

			//- FBP: fator de bloqueio próprio:
			nFBP := (aSoldier[nX]:nTF - aSoldier[nX]:nTB * -1/6)

			//- FD: fator de distância:
			nFD  := abs(1 - (aSoldier[nX]:nCR / (52+1)))

			nBS  := If(aSoldier[nX]:nTrack == 0,nFA-nFR,0)

								//apenas para debug
								/*::StatusMsg("sold. "+cValToChar(nX)+"- FR: "+cValToChar(nFR))
								::StatusMsg("sold. "+cValToChar(nX)+"- FA: "+cValToChar(nFA))
								::StatusMsg("sold. "+cValToChar(nX)+"- FBP: "+cValToChar(nFBP))
								::StatusMsg("sold. "+cValToChar(nX)+"- FD: "+cValToChar(nFD))*/

								//------------------------

			//Verifica o modo de jogo do reino - posicao atual
			If aPlayer[nTurn]:oKingdom:nMode == 1  //attack
				x := (((nFA - nFR) * 0.75 + (nFBP) * 0.25 ) * 0.80) + (nFD * 0.10 + nBS * 0.10)
			ElseIf aPlayer[nTurn]:oKingdom:nMode == 2  //defend
				x := (((nFA - nFR) * 0.40 + (nFBP) * 0.60 ) * 0.80) + (nFD * 0.10 + nBS * 0.10)
			ElseIf aPlayer[nTurn]:oKingdom:nMode == 3  //both
				x := ( (((nFA - nFR) * 0.75 + (nFBP) * 0.25 ) * 0.80) + (nFD * 0.10 + nBS * 0.10) + (((nFA - nFR) * 0.40 + (nFBP) * 0.60 ) * 0.80) + (nFD * 0.10 + nBS * 0.10) ) / 2
			EndIf

			//simula a movimentacao do soldado
			nOldTrack := aSoldier[nX]:nTrack
			aSoldier[nX]:nTrack += If(aSoldier[nX]:nTrack == 0, aPlayer[nTurn]:oKingdom:nPosIni, 0) + nRandom
			aSoldier[nX]:updateValues()

			nFR  := (aSoldier[nX]:nAB1 * 0.75 + aSoldier[nX]:nAB2 * 0.25) / 6
			nFA  := (aSoldier[nX]:nAF1 * 0.75 + aSoldier[nX]:nAF2 * 0.25) / 6
			nFBP := (aSoldier[nX]:nTF - aSoldier[nX]:nTB * -1/6)
			nFD := abs(1 - (aSoldier[nX]:nCR / (52+1)))

			//Verifica o modo de jogo do reino  - posicao posterior (caso mova)
			If aPlayer[nTurn]:oKingdom:nMode == 1  //attack
				y := (((nFA - nFR) * 0.75 + (nFBP) * 0.25 ) * 0.80) + (nFD * 0.10 + nBS * 0.10)
			ElseIf aPlayer[nTurn]:oKingdom:nMode == 2  //defend
				y := (((nFA - nFR) * 0.40 + (nFBP) * 0.60 ) * 0.80) + (nFD * 0.10 + nBS * 0.10)
			ElseIf aPlayer[nTurn]:oKingdom:nMode == 3  //both
				y := ( (((nFA - nFR) * 0.75 + (nFBP) * 0.25 ) * 0.80) + (nFD * 0.10 + nBS * 0.10) + (((nFA - nFR) * 0.40 + (nFBP) * 0.60 ) * 0.80) + (nFD * 0.10 + nBS * 0.10) ) / 2
			EndIf

			aSoldier[nX]:nTrack := nOldTrack
			aSoldier[nX]:updateValues()

			//calcula variacao do fator
			aValues[nX] := {(y-x),nX,y,x}

		Next nX

		//Seleciona soldado a se mover
		aSort(aValues,,,{|x,y| x[1] > y[1] }) //maior->menor
		For nX := 1 To Len(aValues)
			If aSoldier[ aValues[nX,2] ]:nTrack == 0
				If nRandom == 1 .Or. nRandom == 6
					oSoldierMove := aSoldier[ aValues[nX,2] ]
					Exit
				EndIf
			ElseIf (!aSoldier[ aValues[nX,2] ]:lTrackWin .Or. aSoldier[ aValues[nX,2] ]:nTrack + nRandom <= 6) ;
					.And. !aSoldier[ aValues[nX,2] ]:lWin
				oSoldierMove := aSoldier[ aValues[nX,2] ]
				Exit
			EndIf
		Next nX

		//Move soldado selecionado
		If ValType(oSoldierMove) == "O"
			oSoldierMove:Move(nRandom)
		EndIf

		//::StatusMsg("Jogador tirou o número "+cValToChar(::nValueDice)+CRLF)


		//Faz as jogadas para os proximos Jogadores
		If nRandom != 6
			::nTurn++
			::nTurn := If(::nTurn > 4, 1, ::nTurn)
		EndIf

		::Play(::nTurn)

	Else  //vez do humano
		::lDice := .T.
		::lTurn := .F.
		::StatusMsg("Sua vez! Jogue o dado...")
	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LeftClick    ³Autor³Vitor Emanuel Batista ³ Data ³04/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao executada pelo clique da esqueda do mouse            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³LUDO                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LeftClick(oTLudo,nPosX,nPosY)
	Local oSoldier

	oSoldier := oTLudo:SeekSoldier(oTLudo:oTPanel:ShapeAtu)
	If oSoldier == Nil
		Return
	EndIf

	If !oTLudo:lTurn
		oTLudo:StatusMsg("Jogue o dado.")
		Return
	EndIf

	If oSoldier:cKingdom == "BLUE" //Permite a movimentacao apenas para o reinado AZUL
		If oSoldier:nTrack == 0
			If oTLudo:nValueDice != 1 .And. oTLudo:nValueDice != 6
				oTLudo:StatusMsg("Para sair da base, deverá ser tirado o número 1 ou 6.")
				Return
			EndIf
		ElseIf oSoldier:lWin
			oTLudo:StatusMsg("Soldado já ganhou. Mova outro soldado.")
			Return
		ElseIf oSoldier:lTrackWin .And. oSoldier:nTrack + oTLudo:nValueDice > 6
			oTLudo:StatusMsg("Deverá ser tirado o número "+cValToChar(6 - oSoldier:nTrack)+" para este soldado.")
			Return
		EndIf

		oSoldier:Move(oTLudo:nValueDice)

		If oTLudo:nValueDice == 6
			oTLudo:lDice := .T.
			oTLudo:lTurn := .F.
			oTLudo:StatusMsg("Jogue novamente o dado.")
		Else
			oTLudo:Play(2)
		EndIf
	EndIf

Return


//--------------------------------------------------------
Method SeekSoldier(nShapeAtu) Class TLUDO
	Local nX,nY
	Local aKingdom := {::oKingdom1,::oKingdom2,::oKingdom3,::oKingdom4}

	For nX := 1 To 4
		aSoldier := {aKingdom[nX]:oSoldier1,aKingdom[nX]:oSoldier2,aKingdom[nX]:oSoldier3,aKingdom[nX]:oSoldier4}
		For nY := 1 To 4
			If aSoldier[nY]:nID == nShapeAtu
				Return aSoldier[nY]
			EndIf
		Next nY
	Next nX

Return Nil

Method ExportImage() Class TLUDO

	Local aImage := {	"DICE_1.PNG","DICE_2.PNG","DICE_3.PNG","DICE_4.PNG","DICE_5.PNG","DICE_6.PNG",;
						"SOLDIER_RED.PNG","SOLDIER_GREEN.PNG","SOLDIER_BLUE.PNG","SOLDIER_YELLOW.PNG","LUDO.PNG"}
	Local nImage

	For nImage := 1 To Len(aImage)
		cImageTo := ::DirectoryImg()+aImage[nImage]
		If !Resource2File(aImage[nImage],cImageTo)
			Final("No found image: " + aImage[nImage])
		EndIf
	Next nImage

Return