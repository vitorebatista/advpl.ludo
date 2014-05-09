#INCLUDE "PROTHEUS.CH"

user function abc1()
return

//Posicao inicial do soldado no reinado
Static aPosIni := {{85,50},{119,84},{85,118},{51,84}}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Classe    ³TLudoKingdom³Autor³ Felipe Nathan Welter  ³ Data ³08/09/2010³±±
±±³          ³            ³     ³ Vitor Emanuel Batista ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Class TLudoSoldier

	DATA oParent

	DATA cKingdom AS STRING //Reinado em que o soldado pertence
	DATA nPosX AS INTEGER //Indica a posicao em X do soldado
	DATA nPosY AS INTEGER //Indica a posicao em Y do soldado
	DATA cImage AS STRING //Indica o caminho da imagem
	DATA nID AS INTEGER //Indica o ID do shape a ser criado
	DATA nNumber AS INTEGER //Indica o numero do soldado
	DATA nTrack AS INTEGER

	DATA lWin AS BOOLEAN //Indica se soldado chegou ao final
	DATA lTrackWin AS BOOLEAN //Indica se soldado esta no caminho da vitoria

	//nCP - Número de casas percorridas (até entrar na zona segura): n contido em N <= 52.
	DATA nCP AS INTEGER
	//nCR - Número de casas restantes (até entrar na zona segura): n contido em N <= 52.
	DATA nCR AS INTEGER
	//nAF1 - Número de casas advers. até 6 casas a frente: n contido em N <= 6
	DATA nAF1 AS INTEGER
	//nAF2 - Número de casas advers. entre 6 e 12 casas a frente: n contido em N <= 6.
	DATA nAF2 AS INTEGER
	//nAB1 - Número de casas advers. até 6 casas atrás: n contido em N <= 6.
	DATA nAB1 AS INTEGER
	//nAB2 - Número de casas advers. entre 6 e 12 casas atrás: n contido em N <= 6.
	DATA nAB2 AS INTEGER
	//nDTA - Distância da próxima torre adversária: n contido em N <= 6.
	DATA nDTA AS INTEGER
	//nDT - Distância da próxima torre própria: n contido em N <= 6.
	DATA nDT AS INTEGER
	//nTF - Distância para formação de torre (até próximo peão): n contido em N <= 6.
	DATA nTF AS INTEGER
	//nTB - Distância de formação de torre (peão anterior): n contido em N <= 6.
	DATA nTB AS INTEGER

	Method New(nNumber,oParent) CONSTRUCTOR

	Method Move(nTrack)
	Method setNewPos(nTrack)
	Method updateValues()

EndClass

Method New(nNumber,oParent) Class TLudoSoldier

	Local cMark

	::cKingdom := oParent:cKingdom

	::nPosX    := aPosIni[nNumber][1]+oParent:nCol //Posicao em X no Reinado + Posicao em X do Reinado
	::nPosY    := aPosIni[nNumber][2]+oParent:nRow //Posicao em Y no Reinado + Posicao em Y do Reinado
	::nTrack   := 0 //Posicao na array aTrack (0 - Reinado)
	::oParent  := oParent
	::nNumber  := nNumber
	::cImage   := ::oParent:oParent:DirectoryImg() + "SOLDIER_" + ::cKingdom + ".PNG"
	::nID      := ::oParent:oParent:SetId()
	::lWin     := .F.
	::lTrackWin:= .F.

	If ::cKingdom == "BLUE"
		cMark := "can-mark=1;"
	Else
		cMark := "can-mark=0;"
	EndIf

	::oParent:oParent:oTPanel:addShape(	"id="+cValToChar(::nID)+;
													";type=8;left="+cValToChar(::nPosX)+;
													";top="+cValToChar(::nPosY)+;
													";width=42;height=38;image-file="+::cImage+";can-move=0;can-deform=0;is-container=0;"+cMark)

	::nCP := 0 //nCP - Número de casas percorridas (até entrar na zona segura): n contido em N <= 52.
	::nCR := 52 //nCR - Número de casas restantes (até entrar na zona segura): n contido em N <= 52.
	::nAF1 := 0 //nAF1 - Número de casas advers. até 6 casas a frente: n contido em N <= 6
	::nAF2 := 0 //nAF2 - Número de casas advers. entre 6 e 12 casas a frente: n contido em N <= 6.
	::nAB1 := 0 //nAB1 - Número de casas advers. até 6 casas atrás: n contido em N <= 6.
	::nAB2 := 0 //nAB2 - Número de casas advers. entre 6 e 12 casas atrás: n contido em N <= 6.
	::nDTA := 0 //nDTA - Distância da próxima torre adversária: n contido em N <= 6.
	::nDT := 0 //nDT - Distância da próxima torre própria: n contido em N <= 6.
	::nTF := 0 //nTF - Distância para formação de torre (até próximo peão): n contido em N <= 6.
	::nTB := 0 //nTB - Distância de formação de torre (peão anterior): n contido em N <= 6.

Return Self

//--------------------------------------------------------
Method Move(nTrack) Class TLudoSoldier
	Local nX, nY
	Local nNewTrack
	Local nTrackAtu:= ::nTrack
	Local aTrack   := ::oParent:oParent:aTrack
	Local aKingdom := {::oParent:oParent:oKingdom1,::oParent:oParent:oKingdom2,::oParent:oParent:oKingdom3,::oParent:oParent:oKingdom4}

	If nTrackAtu == 0 //saida da base
		If nTrack != 1 .And. nTrack != 6
			::oParent:oParent:StatusMsg("Para sair da base deverá ser tirado o número 1 ou 6.")
			Return
		EndIf

		nNewTrack := ::oParent:nPosIni
	Else
		::oParent:oParent:StatusMsg("Jogador "+cValToChar(::oParent:nKingdom)+" tirou o número "+cValToChar(nTrack))
		nNewTrack := nTrackAtu + nTrack

 		//Indica que soldado esta saindo do caminho de risco para o de vitoria
 		If ::lTrackWin .Or. nTrackAtu < ::oParent:nPosIni .And. nNewTrack >= ::oParent:nPosIni
 			If !::lTrackWin
	 			nNewTrack := nNewTrack - ::oParent:nPosIni
	 		EndIf
 			aTrack := ::oParent:oParent:aTrackWin[::oParent:nKingdom]
 			::lTrackWin := .T.
 			If nNewTrack == 6
 				::lWin := .T.
 			EndIf
 		EndIf

	EndIf

	If nNewTrack > Len(::oParent:oParent:aTrack)
		For nX := 1 To nTrackAtu - Len(::oParent:oParent:aTrack)
			::setNewPos(nTrackAtu+nX,aTrack)
		Next nX
		nTrack := nNewTrack - Len(::oParent:oParent:aTrack)-1
		nNewTrack := 1
		::setNewPos(1,aTrack)
	Else
		nNewTrack -= nTrack
	EndIf

	For nX := 1 To nTrack
		::setNewPos(nNewTrack+nX,aTrack)
	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe outro soldado na mesma casa ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aKingdom)
		If nX != ::oParent:nKingdom
			aSoldier := {aKingdom[nX]:oSoldier1,aKingdom[nX]:oSoldier2,aKingdom[nX]:oSoldier3,aKingdom[nX]:oSoldier4}

			For nY := 1 To Len(aSoldier)
				If aSoldier[nY]:nPosX == ::nPosX .And. aSoldier[nY]:nPosY == ::nPosY

					//Mata soldado adversario e coloca na posicao inicial do seu reinado
					aSoldier[nY]:nPosX  := aPosIni[nY][1]+aKingdom[nX]:nCol
					aSoldier[nY]:nPosY  := aPosIni[nY][2]+aKingdom[nX]:nRow
					aSoldier[nY]:nTrack := 0
					::oParent:oParent:oTPanel:SetPosition(aSoldier[nY]:nID,aSoldier[nY]:nPosX ,aSoldier[nY]:nPosY )
					::oParent:oParent:StatusMsg("Soldado voltou a base! :(")


				EndIf
			Next nY
		EndIf
	Next nX


	::updateValues()

Return


//--------------------------------------------------------
Method setNewPos(nTrack,aTrack) Class TLudoSoldier
	Default aTrack := ::oParent:oParent:aTrack

	If Len(aTrack) >= nTrack .And. nTrack > 0
		::nPosX  := aTrack[nTrack][1]
		::nPosY  := aTrack[nTrack][2]
		::nTrack := nTrack

		::oParent:oParent:oTPanel:SetPosition(::nID,::nPosX,::nPosY)
		::oParent:oParent:oWnd:CommitControls()
		sleep(10)
	Else
		//TODO Verificar o porque de estar retornando um valor negativo
		//::oParent:oParent:StatusMsg("ERRO COM O VALOR nTrack: " + cValToChar(nTrack)+CRLF+"aTrack: "+cValToChar(Len(aTrack)))
	EndIf
Return

//--------------------------------------------------------
//--------------------------------------------------------
Method updateValues() Class TLudoSoldier

	Local nX := 0, nY := 0
	Local aAdvers :=  {}
	Local nQtd := 0
	Local aInterval := {{0,52}}
	Local nAdvTrack := 0

	If(::oParent:oParent:nTurn != 1, aAdd(aAdvers,::oParent:oParent:oPlayer1), Nil)
	If(::oParent:oParent:nTurn != 2, aAdd(aAdvers,::oParent:oParent:oPlayer2), Nil)
	If(::oParent:oParent:nTurn != 3, aAdd(aAdvers,::oParent:oParent:oPlayer3), Nil)
	If(::oParent:oParent:nTurn != 4, aAdd(aAdvers,::oParent:oParent:oPlayer4), Nil)


	//--------------------nCP := 0 //nCP - Número de casas percorridas (até entrar na zona segura): n contido em N <= 52.
	::nCP := If(::nTrack == 0, 0, If (::nTrack < ::oParent:nPosIni,   Len(::oParent:oParent:aTrack) - ::oParent:nPosIni + ::nTrack,  ::nTrack - ::oParent:nPosIni) )

	//--------------------nCR := 52 //nCR - Número de casas restantes (até entrar na zona segura): n contido em N <= 52.
	::nCR := Len(::oParent:oParent:aTrack) - ::nCP


	//--------------------nAF1 := 0 //nAF1 - Número de casas advers. até 6 casas a frente: n contido em N <= 6
	aInterval[1,1] := ::nTrack
	aInterval[1,2] := ::nTrack+6
	aInterval[1,2] := If(aInterval[1,2] > Len(::oParent:oParent:aTrack), aInterval[1,2]-Len(::oParent:oParent:aTrack), aInterval[1,2])
	nQtd := 0

	//percorre todos jogadores adversarios
	For nX := 1 To Len(aAdvers)
		aAdvSoldier := {aAdvers[nX]:oKingdom:oSoldier1, aAdvers[nX]:oKingdom:oSoldier2, aAdvers[nX]:oKingdom:oSoldier3, aAdvers[nX]:oKingdom:oSoldier4}

		//para cada adversario seleciona seus soldados
		For nY := 1 To Len (aAdvSoldier)
			nAdvTrack := aAdvSoldier[nY]:nTrack

			If nAdvTrack == 0
				Loop
			EndIf

			//verifica se soldado adversario esta proximo, na "zona de perigo"
			If (aInterval[1,1] < aInterval[1,2]) //intervalo crescente (5-17)
				If (nAdvTrack >= aInterval[1,1] .And. nAdvTrack <= aInterval[1,2])
					nQtd++
				EndIf
			Else  //intervalo inverso (50-10)
				If (nAdvTrack >= aInterval[1,1] .And. nAdvTrack <= aInterval[1,2])
					nQtd++
				EndIf
			EndIf
		Next nY
	Next nX

	::nAF1 := nQtd

	//--------------------nAF2 := 0 //nAF2 - Número de casas advers. entre 6 e 12 casas a frente: n contido em N <= 6.
	aInterval[1,1] := ::nTrack+6
	aInterval[1,2] := ::nTrack+12
	aInterval[1,1] := If(aInterval[1,1] > Len(::oParent:oParent:aTrack), aInterval[1,1]-Len(::oParent:oParent:aTrack), aInterval[1,1])
	aInterval[1,2] := If(aInterval[1,2] > Len(::oParent:oParent:aTrack), aInterval[1,2]-Len(::oParent:oParent:aTrack), aInterval[1,2])
	nQtd := 0

	//percorre todos jogadores adversarios
	For nX := 1 To Len(aAdvers)
		aAdvSoldier := {aAdvers[nX]:oKingdom:oSoldier1, aAdvers[nX]:oKingdom:oSoldier2, aAdvers[nX]:oKingdom:oSoldier3, aAdvers[nX]:oKingdom:oSoldier4}

		//para cada adversario seleciona seus soldados
		For nY := 1 To Len (aAdvSoldier)
			nAdvTrack := aAdvSoldier[nY]:nTrack

			If nAdvTrack == 0
				Loop
			EndIf

			//verifica se soldado adversario esta proximo, na "zona de perigo"
			If (aInterval[1,1] < aInterval[1,2]) //intervalo crescente (5-17)
				If (nAdvTrack >= aInterval[1,1] .And. nAdvTrack <= aInterval[1,2])
					nQtd++
				EndIf
			Else  //intervalo inverso (50-10)
				If (nAdvTrack >= aInterval[1,1] .And. nAdvTrack <= aInterval[1,2])
					nQtd++
				EndIf
			EndIf
		Next nY
	Next nX

	::nAF2 := nQtd

	//--------------------nAF1 := 0 //nAF1 - Número de casas advers. até 6 casas a frente: n contido em N <= 6
	aInterval[1,1] := ::nTrack-6
	aInterval[1,2] := ::nTrack
	aInterval[1,1] := If(aInterval[1,1] < 0, Len(::oParent:oParent:aTrack)+(aInterval[1,1]) ,aInterval[1,1])
	nQtd := 0

	//percorre todos jogadores adversarios
	For nX := 1 To Len(aAdvers)
		nQtd := 0
		aAdvSoldier := {aAdvers[nX]:oKingdom:oSoldier1, aAdvers[nX]:oKingdom:oSoldier2, aAdvers[nX]:oKingdom:oSoldier3, aAdvers[nX]:oKingdom:oSoldier4}

		//para cada adversario seleciona seus soldados
		For nY := 1 To Len (aAdvSoldier)
			nAdvTrack := aAdvSoldier[nY]:nTrack

			If nAdvTrack == 0
				Loop
			EndIf

			//verifica se soldado adversario esta proximo, na "zona de perigo"
			If (aInterval[1,1] < aInterval[1,2]) //intervalo crescente (5-17)
				If (nAdvTrack >= aInterval[1,1] .And. nAdvTrack <= aInterval[1,2])
					nQtd++
				EndIf
			Else  //intervalo inverso (50-10)
				If (nAdvTrack >= aInterval[1,1] .And. nAdvTrack <= aInterval[1,2])
					nQtd++
				EndIf
			EndIf
		Next nY
	Next nX

	::nAB1 := nQtd

	//--------------------nAB2 := 0 //nAB2 - Número de casas advers. entre 6 e 12 casas atrás: n contido em N <= 6.
	aInterval[1,1] := ::nTrack-6
	aInterval[1,2] := ::nTrack-12
	aInterval[1,1] := If(aInterval[1,1] < 0, Len(::oParent:oParent:aTrack)+(aInterval[1,1]) ,aInterval[1,1])
	aInterval[1,2] := If(aInterval[1,2] < 0, Len(::oParent:oParent:aTrack)+(aInterval[1,2]) ,aInterval[1,2])
	nQtd := 0

	//percorre todos jogadores adversarios
	For nX := 1 To Len(aAdvers)
		nQtd := 0
		aAdvSoldier := {aAdvers[nX]:oKingdom:oSoldier1, aAdvers[nX]:oKingdom:oSoldier2, aAdvers[nX]:oKingdom:oSoldier3, aAdvers[nX]:oKingdom:oSoldier4}

		//para cada adversario seleciona seus soldados
		For nY := 1 To Len (aAdvSoldier)
			nAdvTrack := aAdvSoldier[nY]:nTrack

			If nAdvTrack == 0
				Loop
			EndIf

			//verifica se soldado adversario esta proximo, na "zona de perigo"
			If (aInterval[1,1] < aInterval[1,2]) //intervalo crescente (5-17)
				If (nAdvTrack >= aInterval[1,1] .And. nAdvTrack <= aInterval[1,2])
					nQtd++
				EndIf
			Else  //intervalo inverso (50-10)
				If (nAdvTrack >= aInterval[1,1] .And. nAdvTrack <= aInterval[1,2])
					nQtd++
				EndIf
			EndIf
		Next nY
	Next nX

	::nAB2 := nQtd

	//nDTA := 0 //nDTA - Distância da próxima torre adversária: n contido em N <= 6.
	//nDT := 0 //nDT - Distância da próxima torre própria: n contido em N <= 6.
	//nTF := 0 //nTF - Distância para formação de torre (até próximo peão): n contido em N <= 6.
	//nTB := 0 //nTB - Distância de formação de torre (peão anterior): n contido em N <= 6.

Return