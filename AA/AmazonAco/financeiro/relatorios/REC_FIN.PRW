#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#Include "Protheus.ch"
#include "rwmake.ch"

*****************************************
USER FUNCTION REC_FIN()
*****************************************

PRIVATE oDlg
PRIVATE cPerg := Padr("REC_FIN   ",Len(SX1->X1_GRUPO))
PRIVATE TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTOTUS,ARETURN
PRIVATE NLASTKEY,M_PAG,WNREL,CTES,LI,NVLRUS
PRIVATE DULTDAT,NTOTGER,NTOTGERUS,NRECNO,CNODI,CCOR,NNIVEL
PRIVATE NREGSG1,VIMPEST,VESTRU,X,CCODPRD,NTOTAL,CCOMP
PRIVATE NREGSB1,CDESCRI,LSOMA,NVLRREA,CCODCOM,VDAD

ValidPerg(cPerg)
@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Impressao de Recibo")
@ 02,10 TO 080,190
@ 10,018 Say " Esse programa tem finalidade imprimir um recibo       "
@ 18,018 Say " financeiro                                            "

@ 60,088 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 60,118 BMPBUTTON TYPE 01 ACTION OkEstru()
@ 60,148 BMPBUTTON TYPE 02 ACTION Close(oDlg)
Activate Dialog oDlg Centered

Return

Static Function OkEstru
Pergunte(cPerg,.F.)
Close(oDlg)
AVPRINT oPrn NAME "IMPRESSAO DE RECIBO"

DEFINE FONT oFont1  NAME "Arial"			  SIZE 0,10 Bold OF oPrn
DEFINE FONT oFont2  NAME "Courier New"     SIZE 0,11 Bold OF oPrn//"Times New Roman"
DEFINE FONT oFont3  NAME "Arial"           SIZE 0,16 Bold OF oPrn
DEFINE FONT oFont3n  NAME "Arial"           SIZE 0,16 OF oPrn
DEFINE FONT oFont4  NAME "Arial"           SIZE 0,20 Bold OF oPrn
DEFINE FONT oFont5  NAME "Arial"           SIZE 0,22 Bold OF oPrn
DEFINE FONT oFontT  NAME "Arial"           SIZE 0,16 Bold OF oPrn
DEFINE FONT oFont6  NAME "Trebuchet MS"    SIZE 0,13 Bold OF oPrn
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
Private nPage:=1,nLine,nLinVert := 150,nColIni:=160,nColFim:=2300

nCol1:=nColIni       //Produto
nCol2:=nCol1+1100    //Desconto
nCol3:=nCol2+230     //Preço unitário
nCol4:=nCol3+250     //Quantidade
nCol5:=nCol4+180     //Total
nLinFim:=3000

DbSelectArea("SE1")
DbSetOrder(1)

DbSelectArea("SE5")
DbSetOrder(7)       // Prefixo+Numero+parcela+tipo

IF SE1->(DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR02))
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
	
	If SA1->A1_COD == GETMV("MV_CLIPAD")   // Verifica se o cliente é PADRÃO
		cNome  := Iif( ! Empty(MV_PAR05),MV_PAR05,"")
	Else
		cNome  := SA1->A1_NOME
	EndIf
	
	If ! Empty(cNome)   // Se o nome não está vazio
		
		Do While !SE1->(Eof()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == xFilial("SE1")+MV_PAR01+MV_PAR02   // Contas a Receber
			
			If SE1->E1_PARCELA == MV_PAR03 .Or. Empty(MV_PAR03) // Verifica as parcelas escolhidas pelo usuário, em branco imprime TODAS as parcelas
				
				If SE5->(DBSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA))  // Pesquisa a mov. bancária para imprimir o valor da baixa
					
					Do While !SE5->(Eof()) .And. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA) == SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA)
						
						If SE5->E5_DATA == MV_PAR04 .And. Alltrim(SE5->E5_MOTBX) == "NOR"   // Verifica se a data da baixa, devido baixas parciais
							// e se a baixa é NORMAL
							F_Cabec()
							
							oPrn:Say(nLine ,0510,"                      RECIBO - FINANCEIRO",oFont4,,,,3)
							
							oPrn:Say(nLine += 200 ,0510,"                                            R$ "+ALLTRIM(Transform(SE5->E5_VALOR,"@E 999,999,999.99")),oFont4,,,,3)
							oPrn:Say(nLine += 150 ,nColIni,"Recebi de: "+ALLTRIM(cNome),oFont3n,,,,3)
							oPrn:Say(nLine += 80 ,nColIni,"O Valor de: ("+Extenso(SE5->E5_VALOR)+")",oFont3n,,,,3)
							oPrn:Say(nLine += 80 ,nColIni,"Referente ao pagamento conforme nr. "+SE5->E5_NUMERO+"/"+SE5->E5_PREFIXO+" - "+SE5->E5_PARCELA ,oFont3n,,,,3)
							
							If Alltrim(SE5->E5_TIPO) == "FT"  // Caso o título seja uma Fatura
								nRecSE1  := SE1->(Recno())
								cFatura  := Fatura()
								
								nTamFat  := 110
								cImpFat  := cFatura
								nLinha:= MLCount(Alltrim(cImpFat),nTamFat)
								
								oPrn:Say(nLine += 160 ,nColIni,"Relação de títulos da FATURA: ",oFont3n,,,,3)
								oPrn:Say(nLine += 80 ,nColIni, MemoLine(cImpFat,nTamFat,1) ,oFont3n,,,,3)

								For nBegin := 2 To nLinha
									nLine += 80
									oPrn:Say(nLine,nColIni, Memoline(cImpFat,nTamFat,nBegin),oFont3n,,,,3)
								Next
								
								SE1->(DbGoTo(nRecSE1))
								
							Endif
							
							F_Rod()
							
						EndIf
						
						SE5->(DbSkip())
						
					EndDo
					
				EndIf
				
			EndIf
			
			SE1->(DbSkip())
			
		EndDo
	Else
		MsgAlert("CLIENTE PADRÃO, informe um nome no parâmetro!!!","ATENÇÃO")
	EndIf
	
Endif

Return

Static Function F_Cabec()

nLine := 150

oPrn:SayBitmap(nLine+20,nColIni,"msmdilogo.bmp",nLarg,nAlt)
oPrn:Say(nLine  ,0510,"PILOTO Ltda",oFont4,,,,3)
oPrn:Say(nLine += 100 ,0510," Av. X, CEP 69000-000 - Manaus-AM",oFont1,,,,3)
oPrn:Say(nLine += 50  ,0510," CNPJ: 99.999.999/0001-99  - Insc. Est: 88.888888-8 / piloto@xxx.com.br",oFont1,,,,3)
oPrn:Say(nLine += 50  ,0510,"                      Fone: (0xx)92 3451-6780/2323 - Fax(0xx) 92 4341-5662              ",oFont1,,,,3)

oPrn:Say(nLine += 50  ,0510,"Manaus                                                                                                        Amazonas",oFont1,,,,3)
oPrn:Say(nLine += 10  ,0510,"_____________________________________________________________________",oFont1,,,,3)
nLine +=200
Return

Static Function F_Rod

oPrn:Say(2500 ,nColIni,"                                             Manaus, "+ALLTRIM(STR(DAY(DDATABASE)))+" de "+ALLTRIM(MESEXTENSO(MONTH(DDATABASE))) +" de "+ALLTRIM(STR(YEAR(DDATABASE))) ,oFont3,,,,3)
oPrn:Say(2820 ,nColIni,"                                       ________________________________________",oFont3,,,,3)
oPrn:Say(2900 ,nColIni,"                                                   PILOTO Ltda   ",oFont3,,,,3)
oPrn:Say(3000,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)
AVENDPAGE     // Finaliza a página e inicializa uma nova página
Return

Static Function ValidPerg(cPerg)
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
aRegs :={}
aAdd(aRegs,{cPerg,"01","Prefixo             ?", "" , "", "mv_ch1","C" ,  3, 0 , 0 ,"G", "" , "MV_PAR01", "", "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Numero              ?", "" , "", "mv_ch2","C" ,  9, 0 , 0 ,"G", "" , "MV_PAR02", "", "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Parcela             ?", "" , "", "mv_ch3","C" ,  2, 0 , 0 ,"G", "" , "MV_PAR03", "", "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data da Baixa       ?", "" , "", "mv_ch4","D" ,  8, 0 , 0 ,"G", "" , "MV_PAR04", "", "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Cliente(CLI. PADRÃO)?", "" , "", "mv_ch5","C" , 20, 0 , 0 ,"G", "" , "MV_PAR05", "", "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
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


Static Function Fatura()


cQry := "SELECT * "
cQry += "FROM "+RetSqlName("SE1")+" A "
cQry += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
cQry += "E1_FATPREF = '"+SE5->E5_PREFIXO+"' AND "
cQry += "E1_FATURA = '"+SE5->E5_NUMERO+"' AND "
cQry += "D_E_L_E_T_ <> '*'

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'FAT', .F., .T.)

DbSelectArea("FAT")

cFatura := ""

Do While !Eof()
	
	cFatura += E1_NUM+"/"+E1_PREFIXO+"-"+E1_PARCELA+", "
	
	DbSkip()
	
EndDo

DbCloseArea()

Return(cFatura)
