
#INCLUDE "rwmake.ch"

/*/
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INATFR01     º Autor ³ Wendell Santana º Data ³  16/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de razão do ativo fixo..                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
/*/

User Function INATFR01()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "RAZÃO DO ATIVO FIXO"
Local cPict        := ""
Local titulo       := "RAZÃO DO ATIVO FIXO"
Local nLin         := 80
Local cGrupoPass := GetMv("MV_GRPASS")
Local lCtb       := CtbInUse()
Local nOrdem
Local lInverte
LOCAL cContab
//                                                                                                                        1         1         1
//                             1         2         3         4         5         6         7         8         9         0         1         2
//                     123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       := "DATA     NF        COD DO BEM      TIPO MOV.    PLAQUETA  HISTORICO                                      VALOR MOV.  CCUSTO"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {"ANALÍTICO","SINTÉTICO"}
Local cCons
Local cCons2

LOCAL lCHAVE := .T.
LOCAL cCONTA
LOCAL TESTE := 0
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "INATFR01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "INATFR01" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := Padr("ATFR01",Len(SX1->X1_GRUPO))  //NOME DAS PERGUNTAS NA VERSÃO 8 DO PROTHEUS SÓ PODEM TER 6 CARACTERES.
Private cString := "SN5"

/*dbSelectArea("SN5")
dbSetOrder(1)*/
             
ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  // titulo += " Periodo de "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)
//   titulo += " Filial : "+posicione("SM0",1,cNUMEMP,"M0_CIDCOB")
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
    titulo := alltrim(titulo)
	titulo += " Periodo de "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02)
   	titulo += " Filial : "+posicione("SM0",1,cNUMEMP,"M0_CIDCOB")

If nLastKey == 27
   Return
Endif
nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return 

//************************************************************************************************************************************
static function consulta()
	cCons := " SELECT N4_FILIAL, N4_CBASE, N4_CCUSTO, N4_ITEM, N4_TIPO, "
	cCons += " N4_OCORR, N4_CONTA, N4_VLROC1, N4_NOTA, N4_DATA "
   	cCons += " FROM " + RetsqlName("SN4")+" SN4"
   	cCons += " WHERE SN4.D_E_L_E_T_ <> '*'"  
   	cCons += " AND N4_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
   	cCons += " AND N4_CONTA BETWEEN '"+mv_par03+"' and '"+mv_par04+"'"
   	cCons += " AND N4_FILIAL = "+xFILIAL("SN4")
   	cCons += " AND N4_CCUSTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"                                                                
   	cCons += " ORDER BY N4_CONTA, N4_DATA"                                                                    
/*
SELECT N4_FILIAL, N4_CBASE, N4_CCUSTO, N4_ITEM, N4_TIPO, 
N4_OCORR, N4_CONTA, N4_VLROC1, N4_NOTA, N4_DATA                 
FROM SN4010 SN4
WHERE SN4.D_E_L_E_T_ <> '*'                                                                        
AND N4_DATA BETWEEN 20080101  AND 20080229                                       
AND N4_CONTA BETWEEN 1302010020 and 1302010020
ORDER BY N4_CONTA, N4_DATA"           
*/  
  
   	dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cCons)), "ATV", .T., .T.)             

return   
//*****************************************************************************************************************************************
static function consulta2()
	cCons2 := " SELECT CSN4.N4_FILIAL,  CSN4.N4_CCUSTO, CSN4.N4_TIPO, CSN4.N4_OCORR, CSN4.N4_CONTA, SUM(CSN4.N4_VLROC1) "
   	cCons2 += " N4_VLROC1 FROM ( SELECT N4_FILIAL, N4_CBASE, N4_CCUSTO, N4_ITEM, N4_TIPO, " 
   	cCons2 += " N4_OCORR, N4_CONTA, N4_VLROC1, N4_NOTA, N4_DATA"
   	cCons2 += " FROM " + RetsqlName("SN4")+" SN4"
   	cCons2 += " WHERE SN4.D_E_L_E_T_ <> '*'"  
   	cCons2 += " AND N4_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
   	cCons2 += " AND N4_CONTA BETWEEN '"+mv_par03+"' and '"+mv_par04+"'"
   	cCons2 += " AND N4_FILIAL = "+xFILIAL("SN4")
   	cCons2 += " AND N4_CCUSTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AS CSN4"
    cCons2 += " GROUP BY  CSN4.N4_FILIAL,  CSN4.N4_CCUSTO, CSN4.N4_TIPO, CSN4.N4_OCORR, CSN4.N4_CONTA"
    cCons2 += " ORDER BY CSN4.N4_CONTA, CSN4.N4_OCORR "
               
/*SELECT CSN4.N4_FILIAL,  CSN4.N4_CCUSTO, CSN4.N4_TIPO, CSN4.N4_OCORR, CSN4.N4_CONTA, SUM(CSN4.N4_VLROC1)               
FROM ( SELECT N4_FILIAL, N4_CBASE, N4_CCUSTO, N4_ITEM, N4_TIPO,
             N4_OCORR, N4_CONTA, N4_VLROC1, N4_NOTA, N4_DATA
             FROM SN4010 SN4
             WHERE SN4.D_E_L_E_T_ <> '*'
            AND N4_CONTA  BETWEEN '1302010017' AND '1302010021'
             AND N4_DATA BETWEEN '20080801' and '20080831'
             AND N4_FILIAL = 01
             AND N4_CCUSTO BETWEEN '         ' AND 'ZZZZZZZZZ') AS CSN4                       
GROUP BY  CSN4.N4_FILIAL,  CSN4.N4_CCUSTO, CSN4.N4_TIPO, CSN4.N4_OCORR, CSN4.N4_CONTA
ORDER BY CSN4.N4_CONTA, CSN4.N4_OCORR */
   
   	dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cCons2)), "WWW", .T., .T.)
return   

//**************************************************************************************************************************************
/*
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
&&&Fun‡„o    ³RUNREPORT º Autor ³ Wendell Santana    º Data ³  16/07/08   &&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&Descriçãoo³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS &&&
&&&          ³ monta a janela com a regua de processamento.               &&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&Uso       ³ Programa principal                                         &&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)



if aReturn[8] == 1 //analitico
	Cabec1       := "DATA     NF        COD DO BEM      TIPO MOV.    PLAQUETA  HISTORICO                                      VALOR MOV.  CCUSTO"
	Cabec2       := ""
	analitico(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)   
	ATV->(dbCloseArea())  
	else 
		Cabec1       := "    TIPO MOV.         CENTRO DE CUSTO       VALOR MOV.  " 
		sintetico(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)
		//WWW->(dbCloseArea())
endif
	
  
 
                                                      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN                                                              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()



Return
                                     

//**************************************************************************************************************************************
Static Function ValidPerg(cPerg)


Local _sAlias := Alias()
Local aRegs :={}
Local i
Local j

DbSelectArea("SX1")
DbSetOrder(1)


aAdd(aRegs,{cPerg,"01","DATA INICIAL    ?","","","mv_ch1","D",10,0,0,"G","","mv_par01","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","DATA FINAL      ?","","","mv_ch2","D",10,0,0,"G","","mv_par02","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","SALDO DE        ?","","","mv_ch3","N",01,0,0,"C","","mv_par03","Depreciação","","","","","Aquisição","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","CTA CONTÁBIL DE ?","","","mv_ch3","C",20,0,0,"G","","mv_par03","","","", "","","","","","","","","","","","","","","","","","","","","","CT1",""})
aAdd(aRegs,{cPerg,"04","CTA CONTÁBIL ATÉ?","","","mv_ch4","C",20,0,0,"G","","mv_par04","","","", "","","","","","","","","","","","","","","","","","","","","","CT1",""})
aAdd(aRegs,{cPerg,"05","C. CUSTO DE     ?","","","mv_ch5","C",10,0,0,"G","","mv_par05","","","", "","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"06","C. CUSTO ATÉ    ?","","","mv_ch6","C",10,0,0,"G","","mv_par06","","","", "","","","","","","","","","","","","","","","","","","","","","CTT",""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next	
	
	dbSelectArea(_sAlias)    	
Return 
//**************************************************************************************************************************************************************************

STATIC Function AtfSAldoAnt(cConta)
Local cAliasSn5 := "SN5"
Local cAliasCt		:= "CT1"
Local aRet := { 0,0,0,0,0 }
Local aAreaSN5 := SN5->(GetArea())
Local lInverte := .F.
Local cGrupoPass := GetMv("MV_GRPASS")
#IFDEF TOP
	Local cWhere
	Local cCampoCt		:= "%CT1_NORMAL%"
	Local nTamValor1 := TamSx3("N5_VALOR1")[1] 
	Local nDecValor1 := TamSx3("N5_VALOR1")[2] 
	Local nTamValor2 := TamSx3("N5_VALOR2")[1] 
	Local nDecValor2 := TamSx3("N5_VALOR2")[2] 
	Local nTamValor3 := TamSx3("N5_VALOR3")[1] 
	Local nDecValor3 := TamSx3("N5_VALOR3")[2] 
	Local nTamValor4 := TamSx3("N5_VALOR4")[1] 
	Local nDecValor4 := TamSx3("N5_VALOR4")[2] 
	Local nTamValor5 := TamSx3("N5_VALOR5")[1] 
	Local nDecValor5 := TamSx3("N5_VALOR5")[2] 
	Local cJoin
#ENDIF
Local lCtb := CtbInUse()


#IFDEF TOP
	cWhere 	 := "%N5_DATA < '" + DTOS(FirstDay(Ctod("01/" + SUBSTR(DTOS(mv_par01),5,2)+"/" + StrZero(Year(dDataBase),4))))  + "'%"
	cAliasSn5 := GetNextAlias()
	
	If lCtb
		cJoin := "LEFT JOIN " + RetSqlName("CT1") + " CT1 ON "
		cJoin += "CT1.CT1_FILIAL =  '" + xFilial("CT1") + "' "
		cJoin += "AND CT1.CT1_CONTA = SN5.N5_CONTA "
		cJoin += "AND CT1.D_E_L_E_T_ = ' ' "
	Else
		cAliasCt	:= "SI1"
		cCampoCt	:= "%I1_NORMAL%"
		cJoin := "LEFT JOIN " + RetSqlName("SI1") + " SI1 ON "
		cJoin += "SI1.I1_FILIAL =  '" + xFilial("SI1") + "' "
		cJoin += "AND SI1.I1_CODIGO = SN5.N5_CONTA "
		cJoin += "AND SI1.D_E_L_E_T_ = ' ' "
	Endif
	cJoin := "%" + cJoin + "%"	
	
	BeginSql Alias cAliasSn5
		COLUMN N5_DATA   AS DATE
		COLUMN N5_VALOR1 AS NUMERIC(nTamValor1,nDecValor1)
		COLUMN N5_VALOR2 AS NUMERIC(nTamValor2,nDecValor2)
		COLUMN N5_VALOR3 AS NUMERIC(nTamValor3,nDecValor3)
		COLUMN N5_VALOR4 AS NUMERIC(nTamValor4,nDecValor4)
		COLUMN N5_VALOR5 AS NUMERIC(nTamValor5,nDecValor5)
		SELECT 
			N5_FILIAL, N5_CONTA, N5_TIPO, N5_DATA, N5_VALOR1, N5_VALOR2, N5_VALOR3, N5_VALOR4, N5_VALOR5, %Exp:cCampoCt%
		FROM %table:SN5% SN5
		%Exp:cJoin%
		WHERE
			SN5.N5_FILIAL = %xfilial:SN5% AND
			SN5.N5_CONTA = %Exp:cConta% AND 
			(SN5.N5_TIPO = '0' OR
			%Exp:cWhere%) AND
			SN5.%notDel%
	EndSql
	
#ELSE
	SN5->(MsSeek(xFilial("SN5") + cConta))
	If lCtb
		CT1->(DbSetOrder(1))
		CT1->(MsSeek(xFilial("CT1") + cConta))
	Else
		SI1->(DbSetOrder(1))
		SI1->(MsSeek(xFilial("SI1") + cConta))
	Endif	
#ENDIF
While (cAliasSn5)->(!Eof()) .And. ;
		(cAliasSn5)->N5_FILIAL == xFilial("SN5") .And.;
		(cAliasSn5)->N5_CONTA == cConta 
	If (cAliasSn5)->N5_TIPO == "0" .Or.;
		VAL(SUBSTR(DTOS((cAliasSn5)->N5_DATA),5,2)) < VAL(SUBSTR(DTOS(mv_par01),5,2)) .Or.;
		VAL(SUBSTR(DTOS((cAliasSn5)->N5_DATA),1,4)) < Year(dDataBase)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ lInverte ‚ .T. se conta pertence ao grupo de contas Credoras (cGru-³
		//³ poPass),I1_NORMAL = "D", mas o saldo e devedor                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lInverte := If(lCtb,(cAliasCt)->CT1_NORMAL=="1", (cAliasCt)->I1_NORMAL=="D") .And. SUBS(cConta,1,1)$cGrupoPass
		
		aRet[1] += (cAliasSn5)->N5_VALOR1 * If(((cAliasSn5)->N5_TIPO $ "1234679BCFGJKPQSV" .And. lInverte) .Or.;
															! (cAliasSn5)->N5_TIPO $ "01234679BCFGJKPQTU", (-1), 1)
															
		aRet[2] += (cAliasSn5)->N5_VALOR2 * If(((cAliasSn5)->N5_TIPO $ "1234679BCFGJKPQSV" .And. lInverte) .Or.;
															! (cAliasSn5)->N5_TIPO $ "01234679BCFGJKPQTU", (-1), 1)
															
		aRet[3] += (cAliasSn5)->N5_VALOR3 * If(((cAliasSn5)->N5_TIPO $ "1234679BCFGJKPQSV" .And. lInverte) .Or.;
															! (cAliasSn5)->N5_TIPO $ "01234679BCFGJKPQTU", (-1), 1)
															
		aRet[4] += (cAliasSn5)->N5_VALOR4 * If(((cAliasSn5)->N5_TIPO $ "1234679BCFGJKPQSV" .And. lInverte) .Or.;
															! (cAliasSn5)->N5_TIPO $ "01234679BCFGJKPQTU", (-1), 1)
															
		aRet[5] += (cAliasSn5)->N5_VALOR5 * If(((cAliasSn5)->N5_TIPO $ "1234679BCFGJKPQSV" .And. lInverte) .Or.;
															! (cAliasSn5)->N5_TIPO $ "01234679BCFGJKPQTU", (-1), 1)
	Endif	
	(cAliasSn5)->(DbSkip())	
End		
#IFDEF TOP
	(cAliasSn5)->(DbCloseArea())
#ENDIF
SN5->(RestArea(aAreaSN5))

Return aRet  

//**********************************************************************************************************************************************
static function analitico(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)
LOCAL ntotIMP := 0
LOCAL ntotDEP := 0
LOCAL ntotTRF := 0 
LOCAL ntotBAI := 0      
LOCAL ntotLIQ := 0
LOCAL nSALDOANT := 0
lOCAL nContac
consulta()
nTotIMP := 0   
ATV->(dbGoTop())
SetRegua(ATV->(LastRec()))
//cContab := ATV->N4_CONTA 
cContab := mv_par03
nContac := val(cContab)
While nContac <= val(mv_par04)// .AND. !ATV->(EOF())
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif                                           
   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     	nLin := 8
	Endif 
                         
   @nLin,00 PSAY "Conta : "+ALLTRIM(cContab)+" - "+POSICIONE("CT1",1,xFILIAL("CT1")+cContab,"CT1_DESC01")//ALLTRIM(ATV->N4_CONTA)+" - "+POSICIONE("CT1",1,xFILIAL("CT1")+ATV->N4_CONTA,"CT1_DESC01")  
   	TESTE := AtfSAldoAnt(cContab)		    
   
//	lCHAVE := .F.
 //  	WWW->(dbGoTop())
   @nLin,65 PSAY "Saldo anterior : "+transform(TESTE[1],"@E 9,999,999,999.99")
   nLin++
   INCREGUA()
	IF ATV->N4_OCORR == "05"
  // 		cContab := ALLTRIM(ATV->N4_CONTA)
		WHILE ATV->N4_CONTA == cContab .AND. ALLTRIM(ATV->N4_OCORR) == "05" 
	  		IF ATV->N4_OCORR == "05"                                                                                                   
   				@nLin,00 PSAY SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),7,2)+;
   					"/"+SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),5,2)+;
   					"/"+SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),3,2)
   	   			@nLin,10 PSAY ATV->N4_NOTA
   				@nLin,20 PSAY ATV->N4_CBASE
   		
   				DO CASE   
   					CASE ATV->N4_OCORR == "03"
   			   			@nLin,35 PSAY "TRANSF. DE"
   		  			CASE ATV->N4_OCORR == "04"
   		  				@nLin,35 PSAY "TRANSF. PARA"
   		 			CASE ATV->N4_OCORR == "05"
   		  				@nLin,35 PSAY "IMPLANTAÇAO"
   		 			CASE ATV->N4_OCORR == "06"
   		 				@nLin,35 PSAY "DEPRECIAÇAO" 
   	  			ENDCASE
   				INCREGUA()
   	   			@nLin,49 PSAY Posicione("SN1",1,xFilial("SN1")+ATV->N4_CBASE+ATV->N4_ITEM,"N1_CHAPA") 				//ATV->N1_CHAPA
   	   			@nLin,59 PSAY Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_HISTOR") //ATV->N3_HISTOR
       		 	@nLin,99 PSAY TRANSFORM(ATV->N4_VLROC1,"@E 9,999,999,999.99")
       		 	nTotIMP += ATV->N4_VLROC1
       		 	@nLin,118 PSAY ATV->N4_CCUSTO 
	  		  //	cContab := ALLTRIM(ATV->N4_CONTA)
   	  			nLin := nLin + 1 // Avanca a linha de impressao  
   	 			If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
       				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	 			nLin := 8
	  			Endif
			ENDIF
   			ATV->(dbSkip())
   	 	ENDDO 
   	 	@nLin,91 PSAY "________________________"
   	 	nLin++
   	 	@nLin,91 PSAY "Total : "+TRANSFORM(nTotIMP,"@E 9,999,999,999.99") 
   	 	nLin++   
	ENDIF
//******************************************************************************************************************************   	 

	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
   		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   		nLin := 8
	Endif
 


//@nLin,03 PSAY "DEPRECIAÇÃO" 
	nLin++
//	While !ATV->(EOF())
		IF ATV->N4_OCORR == "06"
			WHILE ATV->N4_CONTA == cContab .AND. ATV->N4_OCORR == "06"
    			IF ATV->N4_OCORR == "06"                                                                                               
   	   				@nLin,00 PSAY SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),7,2)+;
   			  				"/"+SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),5,2)+;
   			  				"/"+SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),3,2)
   	   				@nLin,10 PSAY ATV->N4_NOTA
   	   				@nLin,20 PSAY ATV->N4_CBASE
   		
   	   				DO CASE   
   						CASE ATV->N4_OCORR == "01"
   			   				@nLin,35 PSAY "BAIXA"
   						CASE ATV->N4_OCORR == "03"
   				   	   		@nLin,35 PSAY "TRANSF. DE"
   						CASE ATV->N4_OCORR == "04"
   					   		@nLin,35 PSAY "TRANSF. PARA"
   						CASE ATV->N4_OCORR == "05"
   					   		@nLin,35 PSAY "IMPLANTAÇAO"
   				   		CASE ATV->N4_OCORR == "06"
   			   				@nLin,35 PSAY "DEPRECIAÇAO" 
   	   			   		ENDCASE
   					INCREGUA()
   			   		@nLin,49 PSAY Posicione("SN1",1,xFilial("SN1")+ATV->N4_CBASE+ATV->N4_ITEM,"N1_CHAPA") 				//ATV->N1_CHAPA
   	   				@nLin,59 PSAY Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_HISTOR") //ATV->N3_HISTOR
        			@nLin,99 PSAY TRANSFORM(ATV->N4_VLROC1,"@E 9,999,999,999.99")
        			ntotDEP += ATV->N4_VLROC1
        			@nLin,118 PSAY ATV->N4_CCUSTO 
	   			 //	cContab := ALLTRIM(ATV->N4_CONTA)
   	   				nLin := nLin + 1 // Avanca a linha de impressao  
   					If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
      					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      					nLin := 8
					Endif 
   				ENDIF	
   				ATV->(dbSkip())
   	 		ENDDO 
   	 		@nLin,91 PSAY "________________________"
   	 		nLin++
   	 		@nLin,91 PSAY "Total : "+TRANSFORM(ntotDEP,"@E 9,999,999,999.99")
   	 		nLin++
   		
		ENDIF   	
//   		ATV->(dbSkip()) // Avanca o ponteiro do registro no arquivo
//	EndDo


   	// nTotIMP := 0 
   	 //imprimeBAI(nLin)
//****************************************************************************************************************************************
	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
   		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   		nLin := 8
	Endif
 

	@nLin,03 PSAY "BAIXAS" 
	nLin++
//	While !ATV->(EOF())
		IF ATV->N4_OCORR == "01"
			WHILE ATV->N4_CONTA == cContab .AND. ATV->N4_OCORR == "01"
    			IF ATV->N4_OCORR == "01"                                                                                               
   					@nLin,00 PSAY SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),7,2)+;
   				   		"/"+SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),5,2)+;
   				   		"/"+SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),3,2)
   					@nLin,10 PSAY ATV->N4_NOTA
   					@nLin,20 PSAY ATV->N4_CBASE
   		
   					DO CASE   
   						CASE ATV->N4_OCORR == "01"
   							@nLin,35 PSAY "BAIXA"
   						CASE ATV->N4_OCORR == "03"
   							@nLin,35 PSAY "TRANSF. DE"
   		   				CASE ATV->N4_OCORR == "04"
   			   				@nLin,35 PSAY "TRANSF. PARA"
   						CASE ATV->N4_OCORR == "05"
   							@nLin,35 PSAY "IMPLANTAÇAO"
   						CASE ATV->N4_OCORR == "06"
   							@nLin,35 PSAY "DEPRECIAÇAO" 
   			  		ENDCASE
   					INCREGUA()
   					@nLin,49 PSAY Posicione("SN1",1,xFilial("SN1")+ATV->N4_CBASE+ATV->N4_ITEM,"N1_CHAPA") 				//ATV->N1_CHAPA
   					@nLin,59 PSAY Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_HISTOR") //ATV->N3_HISTOR
        			@nLin,99 PSAY TRANSFORM(ATV->N4_VLROC1,"@E 9,999,999,999.99")
        			ntotBAI += ATV->N4_VLROC1
        			@nLin,118 PSAY ATV->N4_CCUSTO 
				//	cContab := ALLTRIM(ATV->N4_CONTA)
   					nLin := nLin + 1 // Avanca a linha de impressao  
   					If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
      					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      					nLin := 8
					Endif 
				ENDIF	
   				ATV->(dbSkip())
 			ENDDO 
   	 		@nLin,91 PSAY "________________________"
   	 		nLin++
   	 		@nLin,91 PSAY "Total : "+TRANSFORM(ntotBAI,"@E 9,999,999,999.99")  
   	 	
   	 		nLin++
		ENDIF
//   		ATV->(dbSkip()) // Avanca o ponteiro do registro no arquivo
//	EndDo

//****************************************************************************************************************************************
//IMPRIMETRF(nLin)   
//**************************************************************************************************************************************** 
	If nLin > 70 // Salto de Página. Neste caso o formulario tem 70 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif


	@nLin,03 PSAY "TRANSFERENCIAS"
	nLin++
//	While !ATV->(EOF())
		IF ATV->N4_OCORR == "03" .OR. ATV->N4_OCORR == "04"
  			WHILE ATV->N4_CONTA == cContab .AND. (ATV->N4_OCORR == "03" .OR. ATV->N4_OCORR == "04")  
    			IF ATV->N4_OCORR == "03" .OR. ATV->N4_OCORR == "04"                                                                                                
   					@nLin,00 PSAY SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),7,2)+;
   						"/"+SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),5,2)+;
   						"/"+SUBSTR((DTOS(Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_AQUISIC"))),3,2)
   					@nLin,10 PSAY ATV->N4_NOTA
   					@nLin,20 PSAY ATV->N4_CBASE
   		
   					DO CASE   
   						CASE ATV->N4_OCORR == "01"
   			   				@nLin,35 PSAY "BAIXA"
   						CASE ATV->N4_OCORR == "03"
   			   		   		@nLin,35 PSAY "TRANSF. DE"
   				  		CASE ATV->N4_OCORR == "04"
   							@nLin,35 PSAY "TRANSF. PARA"
   						CASE ATV->N4_OCORR == "05"
   							@nLin,35 PSAY "IMPLANTAÇAO"
   		   				CASE ATV->N4_OCORR == "06"
   							@nLin,35 PSAY "DEPRECIAÇAO" 
   	   		  		ENDCASE
   					INCREGUA()
   			 		@nLin,49 PSAY Posicione("SN1",1,xFilial("SN1")+ATV->N4_CBASE+ATV->N4_ITEM,"N1_CHAPA") 				//ATV->N1_CHAPA
   	   		 		@nLin,59 PSAY Posicione("SN3",1,xFilial("SN3")+ATV->N4_CBASE+ATV->N4_ITEM+ATV->N4_TIPO,"N3_HISTOR") //ATV->N3_HISTOR
       				@nLin,99 PSAY TRANSFORM(ATV->N4_VLROC1,"@E 9,999,999,999.99")
        			IF ATV->N4_OCORR == "03"
           				ntotTRF += ATV->N4_VLROC1*(-1)
        	  				ELSE
        	  					ntotTRF += ATV->N4_VLROC1
        	   		ENDIF
        			@nLin,118 PSAY ATV->N4_CCUSTO 
		  		//	cContab := ALLTRIM(ATV->N4_CONTA)
   		  			nLin := nLin + 1 // Avanca a linha de impressao  
   		   			If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
      	  				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	   				nLin := 8
	   	  	 		Endif 
		  		ENDIF	
 		 		ATV->(dbSkip())
 	   		ENDDO 
   	   		@nLin,91 PSAY "________________________"
   	   		nLin++
   	   		@nLin,91 PSAY "Total : "+TRANSFORM(ntotTRF,"@E 9,999,999,999.99")
   	   		nLin++
   	   	ENDIF
//   		ATV->(dbSkip()) // Avanca o ponteiro do registro no arquivo
//	EndDo

//****************************************************************************************************************************************
	IF ntotDEP <> 0	
		ntotLIQ := ((TESTE[1] + ntotDEP)- ntotBAI) + ntotTRF	
		ELSE
			ntotLIQ := ((TESTE[1] + ntotIMP)- ntotBAI) + ntotTRF 	 
	ENDIF                                                       
   	@nLin,03 PSAY "SALDO ATUAL: "+TRANSFORM(ntotLIQ,"@E 9,999,999,999.99") 
 //	cContab := ALLTRIM(ATV->N4_CONTA)
 	nContac += 1 
 	cContab := ALLTRIM(str(nContac))+"          "
	nLin++ 
	nLin++
	ntotTRF := 0
	ntotBAI := 0
	ntotDEP := 0
	nTotIMP := 0
IF ATV->N4_OCORR <> "05" .AND. ATV->N4_OCORR <> "06".AND. ATV->N4_OCORR <> "01" .AND. ATV->N4_OCORR <> "03"  .AND. ATV->N4_OCORR <> "04" .AND. !EMPTY(ATV->N4_OCORR)
    ATV->(dbSkip()) // Avanca o ponteiro do registro no arquivo
    INCREGUA()
ENDIF
EndDo  
return
//**********************************************************************************************************************************
static function sintetico(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin)
LOCAL cContab2:=""
LOCAL nSaldoAtual := 0
Local nContab
CONSULTA2()
WWW->(DBGOTOP())
SetRegua(WWW->(LastRec()))
//cContab2 := WWW->N4_CONTA
cContab2 := MV_PAR03
nContab := val(cContab2)
while nContab <= val(mv_par04)//!WWW->(EOF())
  	If lAbortPrint
    	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      	Exit
  	Endif
  
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
  		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   		nLin := 8
	Endif 
                         
  	@nLin,00 PSAY "Conta : "+ALLTRIM(cContab2)+" - "+POSICIONE("CT1",1,xFILIAL("CT1")+cContab2,"CT1_DESC01")  
  	TESTE := AtfSAldoAnt(cContab2)		    
//  	ALERT("/"+WWW->N4_CONTA+"/"+cContab2+"/")
 // 	TESTE := AtfSAldoAnt(cContab2)
  	@nLin,65 PSAY "Saldo anterior : "+transform(TESTE[1],"@E 9,999,999,999.99")
   	nLin++
  	while cContab2 == WWW->N4_CONTA
  		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
  			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   			nLin := 8
		Endif 
  		DO CASE   
   			CASE WWW->N4_OCORR == "01"
   		   		@nLin,04 PSAY "BAIXA"
   		   		nSaldoAtual+= WWW->N4_VLROC1
   			CASE WWW->N4_OCORR == "03"
   		   		@nLin,04 PSAY "TRANSF. DE"
   		   		nSaldoAtual+= WWW->N4_VLROC1
   	   		CASE WWW->N4_OCORR == "04"
   		   		@nLin,04 PSAY "TRANSF. PARA"
   		   		nSaldoAtual-= WWW->N4_VLROC1
   			CASE WWW->N4_OCORR == "05"
   		  		@nLin,04 PSAY "IMPLANTAÇAO"
   		  		nSaldoAtual+= WWW->N4_VLROC1
   	   		CASE WWW->N4_OCORR == "06"
   		   		@nLin,04 PSAY "DEPRECIAÇAO"
   		   		nSaldoAtual-= WWW->N4_VLROC1 
   	 	ENDCASE
   	 	@nLin,22 PSAY WWW->N4_CCUSTO  
   	 	@nLin,33 PSAY TRANSFORM(WWW->N4_VLROC1,"@E 9,999,999,999.99")
    	nLin++
     //	cContab2 := WWW->N4_CONTA
    	INCREGUA()  
  		WWW->(DBSKIP())
  	enddo
  	nLin++ 
  	@nLin,35 PSAY "________________"
  	nLin++
  	IF nSaldoAtual>0
  		
  		ELSE
  		nSaldoAtual := nSaldoAtual * -1
  	ENDIF
  	@nLin,26 PSAY "Total : "+TRANSFORM(nSaldoAtual,"@E 9,999,999,999.99")
  	nLin++
  	@nLin,65 PSAY "Saldo Atual : "+TRANSFORM(TESTE[1]+nSaldoAtual,"@E 9,999,999,999.99")
  	nLin++
  	nLin++
  	nContab += 1 
 	cContab2 := ALLTRIM(str(nContab))+"          "
  	nSaldoAtual := 0
  //	cContab2 := WWW->N4_CONTA
ENDDO 
return

