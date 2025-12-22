#include 'Protheus.ch'
#include 'RwMake.ch'
#include 'TbiConn.ch'

/*
Data      : 28/07/10
Descricao : Tela de Insercao de Requisicao de Viagem
*/

User Function INCOMC01()
   Local aHeaderCC := {}
   Local aHeaderPA := {}
   Local aHeaderLO := {}
   Local aHeaderHO := {}
   
   Prepare Environment Empresa '01' Filial '01' Tables 'SZH,SZ7,CTT'
   
   Private cRequisicao  := ''
   Private cRequisitante:= ''
   Private cNomeRequis  := ''
   Private cViajante    := ''
   Private cNomeViajante:= ''
   Private cDescricao   := ''
   Private cPassaporte  := ''
   Private cMoeda       := ''
   Private cAgenda      := ''
   Private cDetalhe     := ''
   Private cJustificativ:= ''
   Private cJustUrgencia:= ''
   
   Private dEmissao     := STOD('  /  /  ')
   Private dNecessidade := STOD('  /  /  ')
   Private dViagem      := STOD('  /  /  ')
   Private dVolta       := STOD('  /  /  ')
   
   Private nAprovador   := 1   
   Private nAgencia     := 1
   Private nTipoViagem  := 1
   Private nPais        := 1
   Private nEstado      := 1
   Private nCidade      := 1
   Private nPassPort    := 1
   Private nMoeda      := 1
   Private nAdiantamento:= 0
   Private nTaxa        := 0
   
   
   Private aAprovador   := {' ',' '}
   Private aAgencia     := {' ',' '}
   Private aTipo        := {' ',' '}
   Private aPais        := {' ',' '}
   Private aEstado      := {' ',' '}
   Private aCidade      := {' ',' '}
   Private aPassPort    := {'Sim','Nao'}
   Private aMoeda       := {'Real R$','Dolar U$$','Euro '}   
   
   Private oPais        := Nil
   Private oEstado      := Nil
   Private oCidade      := Nil
   Private oPassPort    := Nil
   Private oMoeda       := Nil
   Private oAgenda      := Nil
   Private oDetalhe     := Nil
   Private oJustificativ:= Nil
   Private cJustUrgencia:= Nil
   Private oDlg   := Nil
   
   Private nLin     := 020
   Private nCol     := 000
   Private nPercRes := 100
   
   cLinOk   := 'Allwaystrue'
   cTudOk   := 'Allwaystrue'
   cIniPos  := ''
   aAlter   := {}
   nFreeze  := 0
   nMax     := 99
   cFieldOk := ''
   cSuperDel:= 'AllwaysTrue'
   cDelOk   := 'AllwaysTrue'
   
   
   aHeaderCC := CriaHeader('SZH','ZH_FILIAL/ZH_NUM')
   
	@ 010,010   TO 900,1300 DIALOG oDlg TITLE OemToAnsi("Requisicao de Viagem")
	@ nLin + 000 ,nCol + 005 TO 470,220 Title 'Informacoes da Requisicao'
	
	@ nLin + 000 ,nCol + 220 TO 130,nCol + 650 Title 'Centro de Custo Financiadores'
	  
	  oGetD:= MsNewGetDados():New(nLin + 08,nCol + 230,nLin + 86,nCol +640, GD_INSERT + GD_UPDATE + GD_DELETE,cLinOk,cTudOk,cIniPos,aAlter,nFreeze,nMax,cFieldOk, cSuperDel,cDelOk, oDLG, aHeaderCC[01], aHeaderCC[02])
	  @ nLin + 000 ,nCol + 220 TO 130,nCol + 650 Title 'Centro de Custo Financiadores'
	  
     //oGetD:= MsNewGetDados():New(nLin + 06,nCol + 230,nLin + 56,nCol +640, GD_INSERT + GD_UPDATE + GD_DELETE,'AllwaysTrue',cTudoOk,cIniCpos,aAlterGDa,nFreeze,nMax,cFieldOk, cSuperDel,cDelOk, oDLG, aHeader, aCols)
	  
	@ nLin + 006,nCol + 010 Say 'Requisicao ' Pixel Of oDlg
	@ nLin + 013,nCol + 010 Get cRequisicao   Size 200,10 Pixel Of oDlg
	  
	@ nLin + 026,nCol + 010 Say 'Requisitante ' Pixel Of oDlg
	@ nLin + 033,nCol + 010 Get cRequisitante   Size 50,10 Pixel Of oDlg
	@ nLin + 033,nCol + 060 Get cNomeRequis     Size 150,10 Pixel Of oDlg
	  
	@ nLin + 046,nCol + 010 Say 'Viajante '    Pixel Of oDlg
	@ nLin + 053,nCol + 010 Get cViajante      Size 50,10 Pixel Of oDlg
	@ nLin + 053,nCol + 060 Get cNomeViajante  Size 150,10 Pixel Of oDlg
	
	@ nLin + 066,nCol + 010 Say 'Aprovador '    Pixel Of oDlg
	@ nLin + 073,nCol + 010 MsComboBox nAprovador Items  aAprovador  Size 100,10 Pixel Of oDlg
	
	@ nLin + 086,nCol + 010 Say 'Data de Emissao '    Pixel Of oDlg
	@ nLin + 093,nCol + 010 Get dEmissao  Size 50,10 Pixel Of oDlg
	
	@ nLin + 086,nCol + 120 Say 'Data de Necessidade '    Pixel Of oDlg
	@ nLin + 093,nCol + 120 Get dNecessidade  Size 50,10 Pixel Of oDlg
	
	@ nLin + 106,nCol + 010 Say 'Agencia de Viagem'  Pixel of oDlg
	@ nLin + 113,nCol + 010 MsComboBox oAgencia Var nAgencia Items aAgencia   Pixel of oDlg
	
	@ nLin + 106,nCol + 120 Say 'Tipo de Viagem'  Pixel of oDlg
	@ nLin + 113,nCol + 120 MsComboBox nTipoViagem Items aTipo  Pixel of oDlg
	
	@ nLin + 126,nCol + 010 Say 'Pais'  Pixel of oDlg
	@ nLin + 133,nCol + 010 MsComboBox oPais Var nPais Items aPais  Pixel of oDlg
	
	@ nLin + 126,nCol + 070 Say 'Estado'  Pixel of oDlg
	@ nLin + 133,nCol + 070 MsComboBox oEstado Var nEstado Items aEstado  Pixel of oDlg

	@ nLin + 126,nCol + 120 Say 'Cidade'  Pixel of oDlg
	@ nLin + 133,nCol + 120 MsComboBox oCidade Var nCidade Items aCidade  Pixel of oDlg
	
	@ nLin + 146,nCol + 010 Say 'Data de Ida '    Pixel Of oDlg
	@ nLin + 153,nCol + 010 Get dViagem  Size 50,10 Pixel Of oDlg 

	@ nLin + 146,nCol + 120 Say 'Data de Volta '    Pixel Of oDlg
	@ nLin + 153,nCol + 120 Get dVolta  Size 50,10 Pixel Of oDlg 
		
	@ nLin + 166,nCol + 010 Say 'Passaporte'  Pixel of oDlg
	@ nLin + 173,nCol + 010 MsComboBox oPassport Var nPassport Items aPassPort  Pixel of oDlg
	
	@ nLin + 166,nCol + 120 Say 'Moeda'  Pixel of oDlg
	@ nLin + 173,nCol + 120 MsComboBox oMoeda Var nMoeda Items aMoeda  Pixel of oDlg
	
	@ nLin + 186,nCol + 010 Say 'Adiantamento'    Pixel Of oDlg
	@ nLin + 193,nCol + 010 Get nAdiantamento      Size 50,10 Pixel Of oDlg
	
	@ nLin + 186,nCol + 120 Say 'Taxa Cambial'    Pixel Of oDlg
	@ nLin + 193,nCol + 120 Get nTaxa      Size 50,10 Pixel Of oDlg
	
	@ nLin + 206,nCol + 010 Say 'Agenda Viagem'    Pixel Of oDlg
	@ nLin + 213,nCol + 010 Get cAgenda  Size 200,50  MEMO Object oAgenda //Pixel Of oDlg

	@ nLin + 266,nCol + 010 Say 'Detalhamento'    Pixel Of oDlg
	@ nLin + 273,nCol + 010 Get cDetalhe  Size 200,50  MEMO Object oDetalhe //Pixel Of oDlg

	@ nLin + 326,nCol + 010 Say 'Justificativa'    Pixel Of oDlg
	@ nLin + 333,nCol + 010 Get cJustificativ  Size 200,50  MEMO Object oJustificativ //Pixel Of oDlg
	
	@ nLin + 386,nCol + 010 Say 'Justificativa Urgencia'    Pixel Of oDlg
	@ nLin + 393,nCol + 010 Get cJustUrgencia  Size 200,50  MEMO Object oJustUrgencia //Pixel Of oDlg		
	

	Activate Dialog oDlg Centered
	      //ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,oDlg:End() },{|| oDlg:End() })

Return Nil

Static Function CriaHeader(cTbl,cCampos)

  Local aHeader := {}
  Local aAreaSX3:= SX3->(GetArea())
  Local aCols   := {}
  Local nK
   
  SX3->(dbSetOrder(1))
  SX3->(dbSeek(cTbl))
   
  WHile cTbl = SX3->X3_ARQUIVO
      If cNivel >= SX3->X3_NIVEL .And. X3USO(SX3->X3_USADO) .And. !(SX3->X3_CAMPO $ cCampos)
          aAdd(aHeader,{ Trim(X3Titulo()), ;  //1  Titulo do Campo
								 SX3->X3_CAMPO   , ;  //2  Nome do Campo
								 SX3->X3_PICTURE , ;  //3  Picture Campo
								 SX3->X3_TAMANHO , ;  //4  Tamanho do Campo
								 SX3->X3_DECIMAL , ;  //5  Casas decimais
								 SX3->X3_VALID   , ;  //6  Validacao do campo
								 SX3->X3_USADO   , ;  //7  Usado ou naum
								 SX3->X3_TIPO    , ;  //8  Tipo do campo
								 SX3->X3_ARQUIVO , ;  //9  Arquivo
								 SX3->X3_CONTEXT } )  //10 Visualizar ou alterar
          
      EndIf
      SX3->(dbSkip())
  EndDo
  SX3->(GetArea())
  aAdd(aCols,Array(Len(aHeader)+1))
  
  For nK := 1 To Len(aHeader)
    aCols[01,nK] := CriaVar(aHeader[nK,02])
  Next
    aCOls[01,nK] := .F.
Return {aHeader,aCols}





/* powered by DXRCOVRB */
