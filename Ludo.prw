#INCLUDE "PROTHEUS.CH"


//---------------------------------------------------------------------
/*/{Protheus.doc} Ludo
Função principal do jogo Ludo

@author Felipe Nathan Welter
@author Vitor Emanuel Batista
@since 08/09/2010
/*/
//-------------------------------------------------------------------
User Function Ludo()
	Local oDlg
	Local oTLudo
	Local cTitle := "LUDO [FELIPE NATHAN WELTER / VITOR EMANUEL BATISTA]"

	//Variaveis de Largura/Altura da Janela
	Local nAltura    := 520
	Local nLargura   := 755
	

	Define Dialog oDlg Title cTitle From 0,0 To nAltura,nLargura COLOR CLR_BLACK, CLR_WHITE Pixel
		oDlg:lEscClose := .F.

		oTLudo := TLudo():New(0,0,(nLargura-15)/2,(nAltura-30)/2,oDlg)
			
		//Cria Menu superior
		CreateMenuBar(oDlg,oTLudo)

	ACTIVATE DIALOG oDlg CENTERED ON INIT oTLudo:Activate()


Return


Static Function CreateMenuBar(oDlg,oTLudo)

	oTMenuBar := TMenuBar():New(oDlg)
		oTMenuBar:SetCss("QMenuBar{background-color:#eeeddd;}")
		oTMenuBar:Align     := CONTROL_ALIGN_TOP
		oTMenuBar:nClrPane  := RGB(238,237,221)
		oTMenuBar:bRClicked := {||}

		oArquivo     := TMenu():New(0,0,0,0,.T.,,oDlg)
		oAjuda       := TMenu():New(0,0,0,0,.T.,,oDlg)

		oTMenuBar:AddItem( '&Arquivo' , oArquivo, .T.)
		oTMenuBar:AddItem( 'Aj&uda' , oAjuda, .T.)

		oArquivo:Add(TMenuItem():New(oDlg,"Novo Jogo",,,,{|| oTLudo:NewGame()},,'',,,,,,,.T.))
		oArquivo:Add(TMenuItem():New(oDlg,"Sair",,,,{|| If(MsgYesNo("Deseja realmente sair do jogo?"),oDlg:End(),)},,'FINAL',,,,,,,.T.))
		oAjuda:Add(TMenuItem():New(oDlg,'&Sobre...        F1',,,,{|| HelProg()},,'RPMPERG',,,,,,,.T.))
	

Return

//TODO Desenvolver Sobre...
Static Function HelProg()


Return