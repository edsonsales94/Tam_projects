#INCLUDE "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "MSOLE.CH"
#INCLUDE "TCBROWSE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCOME05  ºAutor  ³Ener Fredes         º Data ³  05/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para a exportação dos anexos conforme os parametros.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS - PE MT160WF - ANALISE DE COTAÇÃO                  º±±
±±º          ³ COMPRAS - PE MT110CON - SOLICITACAO DE COMPRA              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function INCOME05(cTipo,cNum)
	Private oDlg,oBtn,oGet
	Private aItem := {}
	
	Private aRotina := {	{"Pesquisar" , "AxPesqui", 0, 1},;
								{"Visualizar", "AxVisual", 0, 2},;
								{"Incluir"   ,	"AxInclui", 0, 3},;
								{"Alterar"   , "AxAltera", 0, 4},;
								{"Excluir"   , "AxDeleta", 0, 5}}
	
	SZF->(DbSetOrder(1))
	SZF->(DbSeek(xFilial("SZF")+cTipo+cNum,.T.))
	While !SZF->(Eof()) .And. SZF->ZF_TIPO == cTipo .And. SZF->ZF_NUM == cNum
		Aadd( aItem , { Alltrim(SZF->ZF_ARQSRV), Alltrim(SZF->ZF_ARQ)})
		SZF->(DbSkip())
	Enddo
	
	If !EmptY(aItem)
		@ 00,00 To 270,700 Dialog oDlg Title "Exportar Arquivos"
		
		oLbx := RDListBox(01,01,385,64, aItem,  {"Arquivo","Arquivo Servidor"})
		
		oBtn := TButton():New( 104,005, '&Exportar' , oDlg,{|| fExpAnexar()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
		oBtn := TButton():New( 104,085, '&Sair'     , oDlg,{|| Close(oDlg) }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
		
		ACTIVATE DIALOG oDlg CENTERED
	Else
		Alert("Sem Anexos")
	EndIf
	
Return

Static function fExpAnexar()
	Local cCaminho := cGetFile( "*.*" , "Anexar Cotações",1,'C:\',.T.,GETF_NETWORKDRIVE + GETF_LOCALHARD+GETF_RETDIRECTORY )   //---anexo
	Local cPathWeb := GetPvProfString("HTTP","uploadpath","\web\followup",GetAdv97())
	
	If !Empty(cCaminho)
		//INCLUIDO POR WERMESON
		
		//Local HandleWord (onde sera criado o arquivo local)
		MontaDir(cCaminho)
		
		// Caso encontre arquivo ja gerado na estacao
		//com o mesmo nome apaga primeiramente antes de gerar a nova impressao
		If File( Alltrim( cCaminho + aItem[oLbx:nat,1] ) )
			Ferase( Alltrim( cCaminho + aItem[oLbx:nat,1] ) )
		Endif
		
		//FIM ALTERAÇÃO WERMESON
		
		If CPYS2T(cPathWeb+"\"+aItem[oLbx:nat,1],cCaminho, .T.)
			Alert("Exportação realizada com sucesso!!")
		Else
			Alert("Problemas com a exportaçao dos arquivos!!")
		EndIf
	EndIf
Return
