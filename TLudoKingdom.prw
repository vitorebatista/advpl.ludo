#INCLUDE "PROTHEUS.CH"

user function abc3()
return
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
Class TLudoKingdom
	
	//DATA aPosIni   AS ARRAY {} //Posicoes iniciais no Reino
	//DATA aTrail    AS ARRAY {}  //Caminhos 
	//DATA aTrailWin AS ARRAY {} //Caminho da vitoria
	DATA cKingdom  AS STRING
	DATA nKingdom AS INTEGER
	DATA cColor AS STRING
	DATA oParent   AS OBJECT
	DATA nRow
	DATA nCol
	DATA nPosIni AS INTEGER
	DATA oSoldier1 AS OBJECT
	DATA oSoldier2 AS OBJECT
	DATA oSoldier3 AS OBJECT
	DATA oSoldier4 AS OBJECT
	DATA nMode AS INTEGER //1=Attack;2=Defend;3=Both
	
	Method New(cKingdom,oParent) CONSTRUCTOR
	
EndClass
	
Method New(cKingdom,oParent) Class TLudoKingdom
	
	::cKingdom  := cKingdom
	::cColor    := cKingdom
	::oParent   := oParent

	::nRow := 0
	::nCol := 0

	If cKingdom == "BLUE"
		::nRow := 0
		::nCol := 303
		::nPosIni := 27
		::nKingdom := 1
	ElseIf cKingdom == "YELLOW"
		::nRow := 303
		::nCol := 303
		::nPosIni := 40
		::nKingdom := 2
	ElseIf cKingdom == "GREEN"
		::nRow := 303
		::nCol := 0
		::nPosIni := 1
		::nKingdom := 3
	ElseIf cKingdom == "RED"
		::nRow := 0
		::nCol := 0
		::nPosIni := 14
		::nKingdom := 4
	EndIf
	
	//define modo do jogador
	::nMode := Randomize(1,4)
	If ::nMode == 1
		cModo := "ATAQUE"
	ElseIf ::nMode == 2
		cModo := "DEFESA"
	ElseIf ::nMode == 3
		cModo := "ATAQUE E DEFESA"
	Endif
	::oParent:StatusMsg(::cKingdom+" modo do jogador: "+cModo)
	//::nMode := 1

	::oSoldier1 := TLudoSoldier():New(1,Self)
	::oSoldier2 := TLudoSoldier():New(2,Self)
	::oSoldier3 := TLudoSoldier():New(3,Self)
	::oSoldier4 := TLudoSoldier():New(4,Self)

Return Self