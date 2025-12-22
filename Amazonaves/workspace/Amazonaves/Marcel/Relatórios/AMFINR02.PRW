#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#Include "Protheus.ch" 
#include "rwmake.ch" 
/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ AMFINR02    ¶ Autor ¶ MARCEL R. GROSSELLI ¶ Data ¶ 19/04/2024 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Monta recibos conforme a Marcação do usuários                 ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/ 
                                         
User Function AMFINR02() 	

LOCAL	aPergs := {} 
PRIVATE lExec    := .F.                                            
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''           

//Default cPrefixo   := ""
//Default cNumero    := ""

Tamanho  := "M"
titulo   := "Monta recibos conforme a Marcação do usuários"
cDesc1   := "Monta recibos conforme a Marcação do usuários"
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "AMFINR02"
lEnd     := .F.
cPerg    := PADR("AMFINR02",Len(SX1->X1_GRUPO))
nTam     := TamSX3("E1_NUM")[1]
nTam2    := TamSX3("E1_PARCELA")[1]
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

Aadd(aPergs,{"De Prefixo"      ,"","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo"     ,"","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero"       ,"","","mv_ch3","C",nTam,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero"      ,"","","mv_ch4","C",nTam,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela"      ,"","","mv_ch5","C",nTam2,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela"     ,"","","mv_ch6","C",nTam2,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Cliente"      ,"","","mv_ch7","C", 6,0,0,"G","","MV_PAR07","","",""," ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Cliente"     ,"","","mv_ch8","C", 6,0,0,"G","","MV_PAR08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Da Emissao"      ,"","","mv_ch9","D", 8,0,0,"G","","MV_PAR09","","",""," ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate a Emissao"   ,"","","mv_cha","D", 8,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Observação"      ,"","","mv_chb","C", 99,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


//AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.T.)

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PARCELA+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+SE1->(xFilial())+"'.And.DTOS(E1_BAIXA)<>''.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And." 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter   += "E1_CLIENTE>='" + MV_PAR07 + "' .and. E1_CLIENTE<='" + MV_PAR08 +"' .and. "
cFilter   += "DTOS(E1_EMISSAO)>='"+DTOS(mv_par09)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par10)+"'"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

cMarca	:= GetMark()

DbSelectArea("SE1")
dbGoTop()

/*
@ 175,010 CHECKBOX oMark VAR cMarca PROMPT "Marca/Desmarca" SIZE 60,10 OF oDlg PIXEL; 
ON CLICK ({ || ( Marcar( cMarca ), oMark:oBrowse:Refresh() ) }) 
*/


DEFINE MSDIALOG oDlg TITLE "Seleção de Titulos" FROM 00,00 TO 400,700 PIXEL

oMark := MsSelect():New( "SE1", "E1_OK",,  ,, cMarca, { 001, 001, 170, 350 } ,,, )

oMark:oBrowse:Refresh()
oMark:bAval               := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh() ) }
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .T.
oMark:oBrowse:bAllMark := { || MarcaTudo(cMarca), oMark:oBrowse:Refresh() }

DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTERED
	
dbGoTop()
If lExec
	Processa({|lEnd|RST06IMP()})
Endif

DbSelectArea("SE1")
Set Filter to

RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

Static Function Marcar(cMarca)
	RecLock("SE1",.F.)
	SE1->E1_OK := If( E1_OK <> cMarca , cMarca, Space(Len(E1_OK)))
	MsUnLock()
Return

Static Function MarcaTudo(cMarca)
	Local nRecno := SE1->(Recno())
	
	SE1->(dbGoTop())
	While !SE1->(Eof())
		Marcar(cMarca)
		SE1->(dbSkip())
	Enddo
	SE1->(dbGoTo(nRecno))
	
Return



*****************************************
Static Function RST06IMP()
*****************************************
  LOCAL oPrint, cMaxPar, cQuery, cDocumen, dDataIni	
  PRIVATE oDlg
  PRIVATE cPerg := PADR("O_RECI",Len(SX1->X1_GRUPO))
  PRIVATE TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTOTUS,ARETURN
  PRIVATE NLASTKEY,M_PAG,WNREL,CTES,LI,NVLRUS
  PRIVATE DULTDAT,NTOTGERUS,NRECNO,CNODI,CCOR,NNIVEL
  PRIVATE NREGSG1,VIMPEST,VESTRU,X,CCODPRD,NTOTAL,CCOMP
  PRIVATE NREGSB1,CDESCRI,LSOMA,NVLRREA,CCODCOM,VDAD
  Private aDados :={}
  Private NTOTGER := 0 
  //Private cNumLote := IIF((AllTrim(cLoten)=="SE1" .Or. Empty(cLoten)) ,SE1->E1_LOTE,cLoten)

  

dbGoTop()
ProcRegua(RecCount())
While SE1->(!EOF())
   
   cDocumen := SE1->(E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA)
   NTOTGER := 0 
   While SE1->(!EOF()) .And. cDocumen == SE1->(E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA)
      IncProc()
      If E1_OK <> cMarca //Marked("E1_OK")
         SE1->(dbSkip())
         Loop
      Endif 
   		aRet:=PesqBanco(SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_PREFIXO,SE1->E1_CLIENTE,SE1->E1_LOJA) 
			AADD(aDados,{SE1->E1_LOTE,;
      SE1->E1_CLIENTE,;
      SE1->E1_LOJA,;
      Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_NOME"),;
			SE1->E1_NFELETR,;
			SE1->E1_PREFIXO,;
			SE1->E1_NUM,;
			SE1->E1_PARCELA,;
			SE1->E1_EMISSAO,;
			(SE1->E1_VALOR ),;
			SE1->E1_BAIXA,;//DATA DA BAIXA
			Iif(Len(aRet) > 0,aRet[1][1],""),;//Banco - 12
			Iif(Len(aRet) > 0,aRet[1][2],""),;//Agencia - 13
			Iif(Len(aRet) > 0,aRet[1][3],""),;//Conta - 14 
			Iif(Len(aRet) > 0,aRet[1][4],""),;//Nome do Banco - 15
      SE1->E1_XOBSREC})
      SE1->(dbSkip())
   Enddo
EndDo
 
If Len(aDados) > 0
	OkEstru()
EndIf

Return nil



Static Function OkEstru()
                 
cNumrec := Soma1(getmv("MV_XNUMREC"))
PutMv("MV_XNUMREC",cNumrec)

AVPRINT oPrn NAME "IMPRESSAO DE RECIBO"
 
   DEFINE FONT oFont1  NAME "Arial"			  SIZE 0,10 Bold OF oPrn
   DEFINE FONT oFont2  NAME "Courier New"     SIZE 0,11 Bold OF oPrn//"Times New Roman"
   DEFINE FONT oFont3  NAME "Arial"           SIZE 0,12 Bold OF oPrn
   DEFINE FONT oFont3n NAME "Arial"           SIZE 0,11 Bold OF oPrn
   DEFINE FONT oFont4  NAME "Arial"           SIZE 0,16 Bold OF oPrn
   DEFINE FONT oFont5  NAME "Arial"           SIZE 0,22 Bold OF oPrn
   DEFINE FONT oFontT  NAME "Arial"           SIZE 0,16 Bold OF oPrn
   DEFINE FONT oFont6  NAME "Trebuchet MS"    SIZE 0,10 Bold OF oPrn
   DEFINE FONT oFont7  NAME "Trebuchet MS"    SIZE 0,12 Bold OF oPrn
   DEFINE FONT oFont8  NAME "Arial"           SIZE 0,20 Bold OF oPrn
   
   
   DEFINE FONT oFontX  NAME "Courier New"     SIZE 0,12 Bold Italic Underline OF oPrn//"Times New Roman"

   oPrn:SETPORTRAIT()
   
   AVPAGE
      Processa({|X| lEnd := X, RPrint() })
   AVENDPAGE
   
AVENDPRINT  
oPrn:SETPORTRAIT()
oFont1:End()
oFont2:End()
oFont3:End()
oFont4:End()                                   
oFont5:End()
oFontT:End()                                   
oFont6:End()
Return .T.
      
*****************************************
Static Function RPrint()
*****************************************
Private xCor, cReserv
Private nLarg:=300,nAlt:=200
Private nPage:=1,nLine,nLinVert := 150,nColIni:=110,nColFim:=2300

nCol1:=nColIni       //Produto
nCol2:=nCol1+400    //Desconto
nCol3:=nCol2+230     //Preço unitário
nCol4:=nCol3+250     //Quantidade
nCol5:=nCol4+180     //Total
nLinFim:=3000

For y := 1 to Len(aDados)
     NTOTGER +=aDados[y][10] 
Next
  
  F_Cabec()

  SA1->(DBSETORDER(1))
  SA1->(DBSEEK(XFILIAL("SA1")+aDados[1][2]+aDados[1][3]))

  oPrn:Say(nLine       ,nColIni,"Recebemos do cliente :   "+ ALLTRIM(SA1->A1_NOME)+" CNPJ: "+Transform( SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont3n,,,,3)
  oPrn:Say(nLine += 70 ,nColIni,"Endereço: "+ALLTRIM(SA1->A1_END)+", "+ALLTRIM(SA1->A1_BAIRRO) +" "+IIF(!Empty(SA1->A1_COMPLEM),ALLTRIM(", "+SA1->A1_COMPLEM),"")+" Cidade: "+ALLTRIM(SA1->A1_MUN)+" Estado: "+SA1->A1_EST ,oFont3n,,,,3)
  oPrn:Say(nLine += 70 ,nColIni,"O Valor de: ("+Extenso(NTOTGER)+")",oFont3n,,,,3)
  oPrn:Say(nLine += 70 ,nColIni,"Referente aos títulos abaixo relacionados: " ,oFont3n,,,,3)
  
  F_Itens()
  F_Rod()
  
  
Return                                            
// Localiza a Filial na Tablea SM0 - Cadastro de Empresas

SM0->(DbSeek("01"+"0101"))

Static Function F_Cabec()
  
  nLine := 080
  
  oPrn:Say(nLine  ,0510,SM0->M0_NOMECOM,oFont4,,,,3)
  oPrn:SayBitmap(nLine+20,nColIni,"lgrl"+Substr(xFilial("SE1"),1,2)+".bmp",nLarg,nAlt)

  oPrn:Say(nLine += 80   ,0510,"FRETAMENTO - VENDA DE PEÇAS - MANUTENÇÃO DE AERONAVES",oFont1,,,,3)
  oPrn:Say(nLine += 60   ,0510,"COA: 2002-12-7CKU-02-04  |  COM: 200808-71/ANAC",oFont1,,,,3)
  oPrn:Say(nLine += 60   ,0510,"E-mail: amazonaves@amazonaves.com.br  |  Site: www.amazonaves.com.br",oFont1,,,,3)
  oPrn:Say(nLine += 10   ,0510,"_________________________________________________________________________________________________",oFont1,,,,3)
  oPrn:Say(nLine += 60   ,nColIni,"Matriz: "+SM0->(Alltrim(M0_ENDENT)+" - "+Alltrim(M0_BAIRENT)+" - CEP: "+Transform(M0_CEPENT,"@R 99.999-999")),oFont1,,,,3)
  oPrn:Say(nLine += 50   ,nColIni,SM0->("CNPJ. "+Transform(M0_CGC,"@R 99.999.999/9999-99")+" - Insc. Est. "+Transform(M0_INSC,"@R 99.999.999-9")),oFont1,,,,3)
  oPrn:Say(nLine += 50   ,nColIni,SM0->("Fone: (0xx)92 "+M0_TEL),oFont1,,,,3)
  oPrn:Say(nLine += 10  ,nColIni,"___________________________________________________________________________________________________________________",oFont1,,,,3)

  SM0->(DbSeek("01"+"0102"))

  oPrn:Say(nLine += 60  ,nColIni,"Filial (BASE OPERACIONAL):"+SM0->(Alltrim(M0_ENDENT)+" - "+Alltrim(M0_BAIRENT)+" - CEP: "+Transform(M0_CEPENT,"@R 99.999-999")),oFont1,,,,3)
  oPrn:Say(nLine += 50  ,nColIni,SM0->("CNPJ. "+Transform(M0_CGC,"@R 99.999.999/9999-99")+" - Insc. Est. "+Transform(M0_INSC,"@R 99.999.999-9")),oFont1,,,,3)
  oPrn:Say(nLine += 50  ,nColIni,SM0->("Fone: (0xx)92 "+M0_TEL),oFont1,,,,3)
  oPrn:Say(nLine += 50  ,nColIni,"Manaus                                                                                                         Amazonas",oFont1,,,,3)
  oPrn:Say(nLine += 10  ,nColIni,"___________________________________________________________________________________________________________________",oFont1,,,,3)

   oPrn:Say(nLine+70 ,nColIni, "RECIBO Nº "+cNumrec ,oFont8,,,,3)
   oPrn:Say(nLine+70 ,1800, PADL("R$ "+ALLTRIM(Transform(NTOTGER,"@E 999,999,999.99")),20) ,oFont8,,,,3)

   nLine +=200
Return
                          
Static Function F_Itens
nLine += 150
    oPrn:Say(nLine, nColIni   ,"Serie"                     ,oFont7,,,,3)//Prefixo    
    oPrn:Say(nLine,nCol1+200  ,"Número"                    ,oFont7,,,,3)//Nro Titulo + Parcela    
    oPrn:Say(nLine,nCol2+50   ,"Valor"                     ,oFont7,,,,3)//Valor
    oPrn:Say(nLine,nCol3+50   ,"Observação"                ,oFont7,,,,3)//Valor
nLine += 100

For x := 1 to Len(aDados)

    oPrn:Say(nLine, nColIni   ,aDados[x][6]                        ,oFont6,,,,3)//Prefixo    
    oPrn:Say(nLine,nCol1+200  ,aDados[x][7]+IIF(!Empty(aDados[x][8]),"-"+aDados[x][8],"")       ,oFont6,,,,3)//Nro Titulo + Parcela    
    oPrn:Say(nLine,nCol2+50 ,PadR(Transform((aDados[x][10]),"@E 99,999,999.99"),15),oFont6,,,,3)//Valor
    oPrn:Say(nLine,nCol3+50 ,aDados[x][16],oFont6,,,,3)//Valor
    nLine+=60
    
    if nLine > 2700 .And. x < Len(aDados)
      oPrn:Say(3000,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)
      //F_Rod()
      nPage += 1 
      AVNEWPAGE      
      F_Cabec()
    Endif 
 Next
   
Return  


Static Function F_Rod

/*
  If !Empty(aDados[1][12])
  	oPrn:Say(2900 ,nColIni,"Informações Bancárias - Banco : "+ aDados[1][12]+"-"+Alltrim(aDados[1][15]) +"   Agência: "+aDados[1][13]+"   Conta: "+aDados[1][14],oFont3,,,,3)
  	//oPrn:Say(2580 ,nColIni,"Usuário responsável pela Baixa: " + Alltrim(aDados[1][15]),oFont3,,,,3)
  	//oPrn:Say(2900 ,nColIni,"                                        "+SM0->M0_NOMECOM,oFont3,,,,3)
  	oPrn:Say(3000,nCol5,Padr("Pág. "+strzero(nPage,3),15),oFont2,,,,3)
  Else
  	oPrn:Say(2900 ,nColIni,"TITULOS BAIXADOS POR COMPENSAÇÃO DE CREDITO.",oFont3,,,,3)
  	oPrn:Say(3000,nCol5,Padr("Pág. "+strzero(nPage,3),15),oFont2,,,,3)
  EndIf
*/
oPrn:Say(nLine += 10  ,nColIni,"___________________________________________________________________________________________________________________",oFont1,,,,3)
oPrn:Say(nLine += 50  ,nColIni,"Observações:",oFont1,,,,3)
oPrn:Say(nLine += 50   ,nColIni,mv_par11,oFont1,,,,3)
oPrn:Say(nLine += 10  ,nColIni,"___________________________________________________________________________________________________________________",oFont1,,,,3)
oPrn:Say(nLine += 100  ,nColIni,"Para maior clareza, firmamos o presente.     Manaus - AM, "+cValToChar(Day(ddatabase)) +"  de  "+MesExtenso(dDatabase)+"  de  "+cValToChar(Year(dDatabase)),oFont1,,,,3)
oPrn:Say(nLine += 300  ,0510,"________________________________________________________________________________",oFont1,,,,3)
oPrn:Say(nLine += 50   ,0810,"AMAZONAVES TÁXI AÉREO LTDA",oFont1,,,,3)

Return     



/*_______________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ FunÁ?o    ¶ VerSeq     ¶ Autor ¶ WILLIAMS MESSA       ¶ Data ¶ 19/07/2014 ¶¶¶
¶¶+-----------+------------+-------+----------------------+------+------------+¶¶
¶¶¶ DescriÁ?o ¶ Pega a sequencia do SE5 para efetuar a baixa.                 ¶¶¶
¶¶+-----------+---------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*/
Static Function PesqBanco(cNumero,cParcela,cPrefixo,cCliente,cLoja)
	Local ARetorno  := {}
	Local cAlias    := "QRYSE5"
	Local cCarteira := "R"
	
	BeginSql alias 'QRYSE5'
		%noParser%
		SELECT E5_BANCO,E5_AGENCIA,E5_CONTA,A6_NOME,MAX(E5_SEQ) AS E5_SEQ
		FROM %table:SE5% SE5
		INNER JOIN %table:SA6% SA6 ON A6_COD=E5_BANCO AND A6_AGENCIA = E5_AGENCIA AND A6_NUMCON = E5_CONTA AND SA6.%notDel%
		WHERE E5_NUMERO= %Exp:cNumero%
		AND E5_PARCELA = %Exp:cParcela%
		AND E5_PREFIXO = %Exp:cPrefixo%
		AND E5_RECPAG  = %Exp:cCarteira%
		AND E5_CLIENTE = %Exp:cCliente%
		AND E5_LOJA    = %Exp:cLoja%
		AND SE5.%notDel%
		GROUP BY E5_BANCO,E5_AGENCIA,E5_CONTA,A6_NOME
		
	EndSql
	
	AADD(ARetorno,{E5_BANCO,E5_AGENCIA,E5_CONTA,A6_NOME})
			
	
	QRYSE5->(dbCloseArea())
	
Return(ARetorno)
