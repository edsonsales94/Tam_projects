#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"
#include "RwMake.ch"

/*---------------------------------------------------------------------------------------------------------------------------------------------------
OBJETIVO 1: Montagem da Tela de Pesquisa de Produto por DESCRIÇÃO, FABRICANTE, REFERENCIA e GERAL na Venda Assistida
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

User Function AAESTC05()


Local cVar     := Nil
Local cwVar2   := Nil 
Local oGet     := Nil
Return u_telapesq()

//  .------------------------------
// |     aParam
// |     [01] -> Codigo do Cliente
// |     [02] -> Loja   do Cliente
// |     [03] -> Codigo do Produto
//  '------------------------------

//Default aParam := {'','',''}

Private cAlias     := Alias()
Private nOpc       := 0
Private lMark      := .F.
Private oOk        := LoadBitmap( GetResources(), "LBOK" )
Private oNo        := LoadBitmap( GetResources(), "LBNO" )
Private _cPesquisa := Space(40)
Private oDlg       := Nil
Private oSay1
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oLbx, owLbx
Private aVetor      := {}
Private cModApl1
Private cModApl2
Private cModApl3
Private cFilEst     := {}
Private aItems      := {}
Private oTipo       := NIL
Private _cTipo      := Space(30)
Private oPesquisa   := NIL
Private lPA         := .F.
Private nQtItem     := 0
Private nTotMarc    := 0
Private vCodFil 	:= {}
Private vCodFil2 	:= {}

Private adColsAux   := {}
//Private adParam     := aClone(aParam)

SetKey( 9, {||} )
SetKey(11, {||} )
SetKey(13, {||} )

//  .---------------------------------------------------------------------------
// |     Verifica as Filiais que irão trabalhar com a Transferência entre Lojas
//  '---------------------------------------------------------------------------
VFilial()

aAdd( aVetor  , { lMark, "", "", "", "", 0, "", 0, 0, "", "", "", "", "", .F.} )
aAdd( cFilEst , { "", "", "" } )

DEFINE FONT oFnt3 NAME "Ms Sans Serif" BOLD
DEFINE FONT oFnt3 NAME "MS Sans Serif" SIZE 0, -9 BOLD
DEFINE FONT oFnt4 NAME "Lucida Console" SIZE 0, -9 BOLD

DEFINE MSDIALOG oDlg TITLE "Consulta de Produtos"  From 5,15 To 38,160 OF oMainWnd
//oScr:= TScrollBox():New(oDldming,60,405,110,150,.T.,.T.,.T.)
aAdd(aItems,"Descricao")
aAdd(aItems,"Referencia")
aAdd(aItems,"Fabricante")
aAdd(aItems,"Geral")

@ 015,15 SAY "Tipo : " SIZE 35,8 OF oDlg PIXEL FONT oFnt3
@ 015,50 MSCOMBOBOX oTipo VAR _cTipo ITEMS aItems SIZE 100,50 OF oDlg PIXEL

@ 030,15 SAY "Pesquisar : " SIZE 35,8 OF oDlg PIXEL Font oFnt3

@ 030,50 MSGET oPesquisa  VAR _cPesquisa PICTURE "@!" Size 220,10 Pixel of oDlg VALID Pesquisa(_cTipo)

@ 045,05 LISTBOX oLbx     VAR cVar ;
         FIELDS HEADER " ","Referencia", "Código","Descrição","UM","Pr. Venda 1a.UM", "2a.UM","Pr.Venda 2a.UM","Estoque Disp.","Saldo Orc.", "Pr. Venda","Fabrica","Mod/Apl 1","Mod/Apl 2","Mod/Apl 3","PA";
SIZE 390,180 OF oDlg PIXEL ON CHANGE Apertou() ON dblClick( Inverter(oLbx:nAt,@aVetor,@oLbx),oLbx:Refresh(.F.))

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {IIF(aVetor[oLbx:nAt,01],oOk,oNo),;
aVetor[oLbx:nAt,02],;
aVetor[oLbx:nAt,03],;
aVetor[oLbx:nAt,04],;
aVetor[oLbx:nAt,05],;
Transform(aVetor[oLbx:nAt,06],PesqPict("SB1","B1_PRV1",18,2)),;
aVetor[oLbx:nAt,07],;
Transform(aVetor[oLbx:nAt,08],PesqPict("SB1","B1_PRV1",18,2)),;
Transform(aVetor[oLbx:nAt,09],PesqPict("SB2","B2_QATU",18,2)),;
Transform(aVetor[oLbx:nAt,10],PesqPict("SB2","B2_QATU",18,2)),;
Transform(aVetor[oLbx:nAt,11],PesqPict("SB0","B0_PRV1",18,2)),;
aVetor[oLbx:nAt,12],;
aVetor[oLbx:nAt,13],;
aVetor[oLbx:nAt,14]}}
oLbx:Refresh()
oLbx:nAt := 1

oPesquisa:SetFocus()

@180, 415 Say oSay6 PROMPT " M O D E L O  / A P L I C A C A O "  SIZE 110,7 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFnt3
@030, 410 SAY oSAY4 PROMPT "ESTOQUE NAS FILIAIS  " SIZE 130,7 OF oDlg PIXEL RIGHT COLOR CLR_RED FONT oFnt3

@188, 405 GET oSay1 VAR cModApl1 SIZE 150,10 PIXEL OF oDlg FONT oFnt3 When .f.
//@005, 005 SAY oSAY5 PROMPT cFilEst SIZE 150,300 OF oScr PIXEL COLOR CLR_RED FONT oFnt4

@045, 405 LISTBOX owLbx VAR cwVar2 FIELDS HEADER "Filial", "Armazem", "Saldo" SIZE 160,125 OF oDlg PIXEL	
		owLbx:SetArray( cFilEst )
		owLbx:bLine := {|| { cFilEst[owLbx:nAt,1],;
		 					 cFilEst[owLbx:nAt,2],;
		 					 cFilEst[owLbx:nAt,3]};
		 			   }                         
owLbx:Refresh()
owLbx:nAt := 1
	
@205, 405 GET oSay2 VAR cModApl2 SIZE 150,10 PIXEL OF oDlg FONT oFnt3 When .f.
@220, 405 GET oSay3 VAR cModApl3 SIZE 150,10 OF oDlg PIXEL FONT oFnt3 When .f.

ACTIVATE MSDIALOG oDlg ON INIT;
EnchoiceBar(oDlg,{|| IIf(ValidMarK(adColsAux),(nOpc:=1,oDlg:End()), ) },{||oDlg:End()}) CENTERED

Return(nOpc==1)
//
//
//
Static Function Pesquisa(cTipo)

Local cQry

If !Empty(_cPesquisa)
	
	cQry := "SELECT  * "
	cQry += "FROM "+RetSQLName("SB1")+" B1 "
	
   cQry += "WHERE B1.D_E_L_E_T_=' ' "
	cQry +=       "AND B1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQry +=       "AND B1.B1_MSBLQL <> '1' "

	Do Case
		Case cTipo == "Referencia";   cQry += "AND B1.B1_REFEREN LIKE '%" + Alltrim(_cPesquisa) + "%' ORDER BY B1.B1_REFEREN, B1.B1_ESPECIF "
		Case cTipo == "Descricao";    cQry += "AND B1.B1_ESPECIF LIKE '%" + Alltrim(_cPesquisa) + "%' ORDER BY B1.B1_ESPECIF, B1.B1_NOMFAB "
		Case cTipo == "Fabricante";   cQry += "AND B1.B1_NOMFAB LIKE  '%" + Alltrim(_cPesquisa) + "%' ORDER BY B1.B1_NOMFAB, B1.B1_ESPECIF "
		Case cTipo == "Geral";        cQry += "AND (B1.B1_ESPECIF LIKE '%"+Alltrim(_cPesquisa)+"%' OR "
			cQry += "B1.B1_NOMFAB LIKE  '%" + Alltrim(_cPesquisa) + "%' OR "
			cQry += "B1.B1_MODAPL1 LIKE '%" + Alltrim(_cPesquisa) + "%' OR "
			cQry += "B1.B1_MODAPL2 LIKE '%" + Alltrim(_cPesquisa) + "%' OR "
			cQry += "B1.B1_MODAPL3 LIKE '%" + Alltrim(_cPesquisa) + "%' OR "
			cQry += "B1.B1_REFEREN LIKE '%" + Alltrim(_cPesquisa) + "%') "
			cQry += "ORDER BY B1.B1_ESPECIF,B1.B1_NOMFAB, B1.B1_REFEREN "			
	EndCase
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "QRY", .T., .F. )
	
	dbSelectArea("SB0")
	dbSetOrder(1)
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	
	dbSelectArea("QRY")
	dbGoTop()
	
	aDel(aVetor,Len(aVetor))
	aSize(aVetor,0)
	
	While !QRY->(Eof())
		lTemSB0 := SB0->(DbSeek(xFilial("SB0")+QRY->B1_COD))
		nPreco 	:= 0
		nWPreco2 := 0
		
		If lTemSB0
			nPreco := SB0->B0_PRV1
		EndIf
		
		If QRY->B1_TIPCONV == "D"    // Divisor
   	       nWPreco2 := Round(nPreco * QRY->B1_CONV,2) 
        Else                  
		   nWPreco2 := Round(nPreco / QRY->B1_CONV,2)
		EndIf
				
		SB2->(DbSeek(xFilial("SB2")+QRY->B1_COD+QRY->B1_LOCPAD))
		
		//If Alltrim(QRY->B1_TIPO) == "PA"
		//	lPA 	:= u_VerPA(QRY->B1_COD,lTemSB0,QRY->B1_LOCPAD) // Função para verificação de Produto de KIT baseado na Estrutura de Produto (SG1) - FUNÇÕES ESPECIFICAS
		//EndIf
		
		If GETMV("MV_USARESE") == "S"         // Controle de Reserva CUSTOMIZADA
			nQtdOrc := u_SaldoOrc(QRY->B1_COD) // Funcao que soma a quantidade de produtos com Orcamentos em abertos e NAO vencidos
		Else
			nQtdOrc := 0 // Verificar
		Endif
		
		lMark := aScan(adColsAux,{|x| x[03] = QRY->B1_COD }) != 0
		aAdd( aVetor, { lMark, QRY->B1_REFEREN, QRY->B1_COD, QRY->B1_ESPECIF, QRY->B1_UM, nPreco, QRY->B1_SEGUM, nWPreco2, SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP), nQtdOrc, QRY->B1_NOMFAB, QRY->B1_MODAPL1, QRY->B1_MODAPL2, QRY->B1_MODAPL3, lPA} )
		lMark := .F.
		QRY->(DbSkip())
		
	Enddo
	
	QRY->(DbCloseArea())
	
	If Len(aVetor) = 0
      aAdd( aVetor , { lMark, "", "", "", "", 0, "", 0, 0, "", "", "", "", "", .F.} )
		MsgAlert("Não existe dados para seleção!!!",OemToAnsi("ATENCAO")  )
	EndIf
	aVetor := aSort(aVetor,,,{|x,y| x[04] < y[04]})
	oLbx:Refresh()
	owLbx:Refresh()
	Apertou()
	
EndIf

Return
//
//
//
Static Function Inverter(nPos,aVetor,oLbx)

aVetor[nPos][1] := !aVetor[nPos][1]

/*If aVetor[nPos][1] .and. aVetor[nPos][8] == 0
	MsgAlert("Produto sem Preço de Venda !!!","ATENCAO")
	aVetor[nPos][1]:=.F.
EndIf

If aVetor[nPos][1]
	nPosd := aScan(adColsAux,{|x| x[03] = aVetor[nPos,03] })
	If nPosd = 0
		nQuant := AAGETQTD()
		If nQuant > 0
			aAdd(adColsAux, aClone(aVetor[nPos]) )
			aAdd(adColsAux[Len(adColsAux)],nQuant)
		Else
			aVetor[nPos][1]:=.F.
		EndIf
	EndIf
Else
	nPosd := aScan(adColsAux,{|x| x[03] = aVetor[nPos,03] })
	if nPosd != 0
		adAux := aClone(adColsAux)
		adColsAux := {}
		For nD := 1 To Len(adAux)
			If nPosd != nD
				aAdd(adColsAux,adAux[nD])
			EndIf
		Next
		
		If Len(adColsAux) = 0
			adColsAux := {}
		EndIf
	EndIf
EndIf
  */
oLbx:Refresh()
Return
//
//
//
Static Function ValidMarK(aVetor)

Local lRet := .T.

Return(lRet)
//
//
//
//
//
//
//
//
Static Function Apertou()
Local lAux := .T.
cModApl1 := aVetor[oLbx:nAt,9]
cModApl2 := aVetor[oLbx:nAt,10]
cModApl3 := aVetor[oLbx:nAt,11]

cFilEst  := {}
//aAdd( cFilEst , {  "", "", "" } )
_xdEstTotal := 0
_xdUserHab  := SuperGetMv("MV_XUSRCUF",.F.,"000025;000000")
For I:=1 to Len(vCodFil)
	
	SB2->(dbSetOrder(1))
	
	If SB2->(MsSeek(vCodFil[I] + padr(aVetor[oLbx:nAt,3],TamSx3('B1_COD')[01])))
		
		Do While !SB2->(Eof()) .And. vCodFil[I] == SB2->B2_FILIAL .And. padr(aVetor[oLbx:nAt,3],TamSx3('B1_COD')[01]) == SB2->B2_COD
			
			If vCodFil[I] <> SubStr(cNumEmp,3,2) .Or. Alltrim(__cUserID)$_xdUserHab   // Somente o Estoque das demais Lojas, a Loja que o usuário está logado não será demonstrada
				//cFilEst += PadC(vCodFil2[i]+" Local "+SB2->B2_LOCAL+" --> "+Transform(SB2->B2_QATU,"@E 999,999,999.99") ,49)                 
			    //cFilEst += PADR( Padr(alltrim(vCodFil2[i]),25) +" Local: "+SB2->B2_LOCAL+" --> "+Transform(SB2->B2_QATU,"@E 999,999,999.99") , 150) + CHR(10)+CHR(13)
				//cFilEst += Padr(Alltrim(PADR( alltrim(vCodFil2[i]), 25)+" Local: "+SB2->B2_LOCAL+" --> "+Transform(SB2->B2_QATU,"@E 999,999.99")),150) + CHR(10)+CHR(13)
				If lAux 
					//cFilEst := {"","",""} //""//Space(02)
					lAux := .F.
				EndIf                    
				
				If SB2->B2_QATU > 0				
					aadd(cFilEst, {vCodFil2[i], SB2->B2_LOCAL, Transform(SB2->B2_QATU,"@E 999,999,999.99")})
					_xdEstTotal += If(SB2->B2_QATU > 0,SB2->B2_QATU,0)
				EndIf 
				
			EndIf
			SB2->(DbSkip())
			
		EndDo
		
	EndIf	
		
Next
                    
If Len(cFilEst) == 0
	cFilEst := {} 
	aAdd( cFilEst , {  "", "", "" } )
	_xdEstTotal := 0
EndIf
cModApl1 := Alltrim(Transform(_xdEstTotal,"@E 999,999,999.9999"))

owLbx:AArray := ACLONE(cFilEst)
owLbx:nAt := 1
oSay4:Refresh()
owLbx:Refresh()
oLbx:Refresh()

oSay1:Refresh()
oSay2:Refresh()
oSay3:Refresh()  

oSay1:SetContentAlign(1)
Return(.T.)
//  .---------------------------------------------------------------------------
// |     Verifica as Filiais que irão trabalhar com a Transferência entre Lojas
//  '---------------------------------------------------------------------------
Static Function VFilial()

Local _xdUserHab  := SuperGetMv("MV_XUSRCUF",.F.,"000025;000000")


cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SLJ")+" "
cQry += "WHERE LJ_RPCEMP = '"+SM0->M0_CODIGO+"' AND "
If !Alltrim(__cUserID)$_xdUserHab
   cQry += "LJ_RPCFIL <> '"+xFilial("SB2")+"' AND "
EndIf
cQry += "D_E_L_E_T_ <> '*' "
cQry += "ORDER BY LJ_RPCEMP, LJ_RPCFIL  "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"FIL",.T.,.T.)
dbSelectArea("FIL")

While !Eof()
	aAdd(vCodFil,  LJ_RPCFIL)
	aAdd(vCodFil2, PadC(ALLTRIM(LJ_NOME),20))
	dbSkip()
End

dbCloseArea("FIL")
Return()
//
//
//
Static Function AAGETQTD()

Local nQuant  := -1

Define Font oFnt3 Name "Ms Sans Serif" Bold

while nQuant < 0
	nQuant := 0
	DEFINE MSDIALOG oDialog TITLE "Quantidade" FROM 190,110 TO 300,370 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
	@ 005,004 SAY "Quantidade :" SIZE 220,10 OF oDialog PIXEL Font oFnt3
	@ 005,050 GET nQuant         SIZE 50,10  PICTURE "@E 999,999.99" //Pixel of oSenhas
	
	@ 035,042 BMPBUTTON TYPE 1 ACTION( nRet := IIF(nQuant >= 0,oDialog:End(), NIL) )
	
	ACTIVATE DIALOG oDialog CENTERED
Enddo

Return nQuant

//***************************************************************************************

Static Function fCriaVar(cAlias, aCols)
  aAdd(aCols,Array(Len(aHeader)+1))                	

  For nx:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[nx,2])
		If IsHeadRec(cCampo)
			aCols[Len(aCols)][nx] := 0
		ElseIf IsHeadAliasa(cCampo)
			aCols[Len(aCols)][nx] := cAlias			
		Else
			aCols[Len(aCols)][nx] := CriaVar(cCampo,.T.)
		EndIf
  Next nx                         
  
  aCols[Len(aCols)][len(aHeader)+1] := .F.
Return nil