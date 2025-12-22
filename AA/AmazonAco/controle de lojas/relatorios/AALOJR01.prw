#INCLUDE "Font.ch"
#include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AALOJR01   ¦ Autor ¦ Adson Carlos         ¦ Data ¦ 06/08/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Impressão do Orçamento                                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦*/


User Function AALOJR01(cOrc)

If cOrc <> Nil
	SL1->(dbSetOrder(1))
	SL1->(dbSeek(XFILIAL("SL1")+cOrc))  // Posiciona no SL1
Endif

Processa({|| RReport(),"Processando Dados"})

Return

Static FUNCTION RReport()
Local cDescri, x, vAux, nPos
Local vParc    := {}
Local nValDesc := 0
Local nValdescTot := 0
Local nHojas   := 1

Private oPrn  := TMSPrinter():New( "Relatório Gráfico" )
Private nColI := 50
Private nLarg := 2380

// ALTERADO O TAMANHO DAS FONTES

DEFINE FONT oFont09 NAME "Times New" SIZE 0,06 Bold OF oPrn
DEFINE FONT oFont10 NAME "Times New" SIZE 0,07 Bold OF oPrn
DEFINE FONT oFont11 NAME "Times New" SIZE 0,08 Bold OF oPrn
DEFINE FONT oFont12 NAME "Times New" SIZE 0,09 Bold OF oPrn
DEFINE FONT oFont14 NAME "Times New" SIZE 0,11 Bold OF oPrn
DEFINE FONT oFont16 NAME "Times New" SIZE 0,13 Bold OF oPrn
DEFINE FONT oFont20 NAME "Times New" SIZE 0,16 Bold OF oPrn
DEFINE FONT oFont22 NAME "Times New" SIZE 0,18 Bold OF oPrn
DEFINE FONT oFont36 NAME "Times New" SIZE 0,28 Bold OF oPrn
DEFINE FONT oFont48 NAME "Times New" SIZE 0,38 Bold OF oPrn
DEFINE FONT oFontX  NAME "Times New" SIZE 0,07 Bold Italic Underline OF oPrn
DEFINE FONT oFontY  NAME "Times New" SIZE 0,07 Bold OF oPrn

DEFINE FONT oFont11c NAME "Courier New" SIZE 0,09 Bold OF oPrn

oPrn:SetPortrait() // Estilo retrato
oPrn:StartPage()   // Inicia uma nova página

ImpCabec()

nLin := 800

SL2->(dbSetOrder(1))
SL2->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))



While !SL2->(Eof()) .And. SL1->(L1_FILIAL+L1_NUM) == SL2->(L2_FILIAL+L2_NUM)
	
	oPrn:Line(nLin,nColI+10,nLin,nColI+nLarg)
	
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(XFILIAL("SB1")+SL2->L2_PRODUTO))
	
	cDescri := AllTrim(SB1->B1_COD) + " - " + Alltrim(SB1->B1_ESPECIF)
	
	nL      := MlCount(cDescri,46)
	For nY:=1 To nL
		nLin += 40
		oPrn:Say(nLin,nColI+0500,MemoLine(cDescri,46,nY),oFont11c /*cReserv*/,,/*xCor*/,,3)
		
		If nY == 1
			
			oPrn:Say(nLin,nColI+0020,SB1->B1_COD,oFont11c /*cReserv*/,,/*xCor*/,,3)
			oPrn:Say(nLin,nColI+0140,Transform(SL2->L2_QUANT,"@E 999999"),oFont11c /*cReserv*/,,/*xCor*/,,3)
			oPrn:Say(nLin,nColI+0360,SB1->B1_UM,oFont11c /*cReserv*/,,/*xCor*/,,3)
			oPrn:Say(nLin,nColI+1390,SB1->B1_NOMFAB,oFont11c /*cReserv*/,,/*xCor*/,,3)
			oPrn:Say(nLin,nColI+1740,Transform(SB1->B1_PESO,"@E 9999.99"),oFont11c /*cReserv*/,,/*xCor*/,,3)
			oPrn:Say(nLin,nColI+121ø0,Transform(SL2->L2_PRCTAB,PesqPict("SL2","L2_PRCTAB",18,2)),oFont11c /*cReserv*/,,/*xCor*/,,3)
			oPrn:Say(nLin,nColI+2180,Transform(SL2->(L2_QUANT*L2_PRCTAB),PesqPict("SL2","L2_VLRITEM",18,2)),oFont11c /*cReserv*/,,/*xCor*/,,3)
		Endif
	Next
	
	nLin += 40
	nValDesc += SL2->L2_VALDESC
	
	SL2->(dbSkip())
	
	IF(nLin >= 2800)// CONTROLE DE PAGINAS
		
		oPrn:EndPage()     // Finaliza a página
		oPrn:StartPage()   // Inicia uma nova página
		//nHojas++
		ImpCabec()
		nLin := 800
		
	ENDIF
	
Enddo

nLin += 50
oPrn:Line(nLin,nColI+10,nLin,nColI+nLarg)
nLin += 50
oPrn:Say(nLin,nColI+50,"OBS.: "+SL1->L1_OBSERV,OFONT12,,,,3)


SL4->(dbSetOrder(1))
SL4->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))
While !SL4->(Eof()) .And. SL1->(L1_FILIAL+L1_NUM) == SL4->(L4_FILIAL+L4_NUM)
	AAdd( vParc , { SL4->L4_FORMA, SL4->L4_VALOR, SL4->L4_ADMINIS, SL4->L4_NUMCART, 0, 0} )
	SL4->(dbSkip())
Enddo

// Caso tenha sido utilizado crédito na venda
If SL1->L1_CREDITO > 0
	AAdd( vParc , { "CREDITO R$ ", SL1->L1_CREDITO} )
Endif

vAux  := aClone(vParc)
vParc := {}

For x:=1 To Len(vAux)
	nPos := AScan( vParc , {|y| y[1]+y[3]+y[4] == vAux[x,1]+vAux[x,3]+vAux[x,4] })
	If nPos == 0
		AAdd( vParc , { vAux[x,1], 0, vAux[x,3], vAux[x,4], 0, 0} )
		nPos := Len(vParc)
	Endif
	vParc[nPos,5] += vAux[x,2]
	vParc[nPos,6]++
	vParc[nPos,2] := vParc[nPos,5] / vParc[nPos,6]
Next


nLin += 80
oPrn:Say(nLin,nColI+050,"Pagamento: ",OFONT12,,,,3)
oPrn:Say(nLin+20,nColI+1060,"Prz Entrega: ",OFONT12,,,,3)
oPrn:Say(nLin+90,nColI+1060,"Proposta Valida por 05 dias. ",OFONT12,,,,3)


If SL1->L1_CONDPG <> "001"   // Se não for venda a vista
	For x:=1 To Len(vParc)
		oPrn:Say(nLin+((x-1)*50),nColI+300,vParc[x,1],oFont12,,,,3)
		oPrn:Say(nLin+((x-1)*50),nColI+520,If( vParc[x,6] > 0, LTrim(Str(vParc[x,6],3))+"x de ", " ") +;
		LTrim(Transform(vParc[x,2],"@e 999,999,999.99")),oFont12,,,,3)
	Next
Else
	oPrn:Say(nLin,nColI+300,"DINHEIRO",OFONT12,,,,3)
Endif

oPrn:Say(nLin-80,nColI+nLarg-590,"Subtotal",OFONT12,,,,3)
oPrn:Say(nLin-80,nColI+nLarg-240,Transform(SL1->L1_VALMERC,"@E 99,999.99"),oFont11c /*cReserv*/,,/*xCor*/,,3)

nLin += 60
If SL1->L1_CONDPG == "001"   // Se for venda a vista
	oPrn:Say(nLin,nColI+300,"A VISTA",OFONT12,,,,3)
Endif
nValdescTot := SL1->L1_DESCONT

nLin += 40
oPrn:Say(nLin-100,nColI+nLarg-590,"Desconto ",OFONT12,,,,3)
oPrn:Say(nLin-100,nColI+nLarg-240,Transform(nValdescTot+nValDesc,"@E 99,999.99"),oFont11c /*cReserv*/,,/*xCor*/,,3)

nLin += 100
oPrn:Say(nLin-100,nColI+nLarg-590,"Total ",OFONT12,,,,3)
oPrn:Say(nLin-100,nColI+nLarg-240,Transform(SL1->L1_VLRLIQ,"@E 99,999.99"),oFont14 /*cReserv*/,,/*xCor*/,,3)


nLin += 100


oPrn:EndPage()     // Finaliza a página
oPrn:Preview()     // Visualiza antes de imprimir
Return

Static Function ImpCabec()

Private cCepPict:=PesqPict("SA2","A2_CEP")
Private cCGCPict:=PesqPict("SA2","A2_CGC")
Private cTel    :=PesqPict("SA3","A3_TEL")

// Posiciona no cadastro de clientes
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+SL1->(L1_CLIENTE+L1_LOJA)))

// Posiciona no cadastro de vendedores
SA3->(dbSetOrder(1))
SA3->(dbSeek(xFilial("SA3")+SL1->L1_VEND))

_cdCGC := If(SM0->M0_CODIGO == '01' .And. SM0->M0_CODFIL == '03' , '05477207000175' , SM0->M0_CGC )
_cdInsc := If(SM0->M0_CODIGO == '01' .And. SM0->M0_CODFIL == '03' , '063000016' , SM0->M0_INSC )

oPrn:Box(020,nColI+001,650,nColI+nLarg)
oPrn:SayBitmap(40,nColI+40,"\SYSTEM\LGMID1.BMP",300,280)
oPrn:Say(030,nColI+380,SM0->M0_NOMECOM,OFONT11,,,,3)
oPrn:Say(090,nColI+380,"CNPJ: " + AllTrim(Transform(_cdCGC,cCgcPict)),OFONT11,,,,3)
oPrn:Say(150,nColI+380,AllTrim(SM0->M0_ENDCOB)+" "+AllTrim("Pq. 10")+" CEP: "+Transform(SM0->M0_CEPCOB,cCepPict),OFONT11,,,,3)
oPrn:Say(210,nColI+380,"Fone: "+Transform(SM0->M0_TEL,"@R (99)9999-9999"),OFONT11,,,,3)
oPrn:Say(280,nColI+380,"Soluções em Aluminio ",OFONT12,,,,3)

oPrn:Line(380,nColI+0010,380,nColI+nLarg)
oPrn:Line(030,nColI+1220,650,nColI+1220)

oPrn:Say(040,nColI+1350-100,"Proposta de Fornecimento",OFONT14,,,,3)
oPrn:Say(040,nColI+2050,SL1->L1_NUM,OFONT14,,,,3)
oPrn:Say(120,nColI+1390-100,"Os materiais descriminados abaixo são relacionados de acordo com a ",OFONT10,,,,3)
oPrn:Say(180,nColI+1390-100,"solitação do cliente, qualquer alteração de produto será comunicada  ",OFONT10,,,,3)
oPrn:Say(240,nColI+1390-100,"no campo de observações gerais. ",OFONT10,,,,3)
oPrn:Say(330,nColI+1900-100,"Emissão: "+Dtoc(SL1->L1_EMISSAO)+" - "+Time(),OFONT11,,,,3)

oPrn:Say(450,nColI+0030,"Cliente: "+SA1->A1_COD+"-"+SA1->A1_NOME,OFONT12,,,,3)
oPrn:Say(520,nColI+0030,"Att.: "+If(Empty(SA1->A1_CONTATO),SA1->A1_NREDUZ,SA1->A1_CONTATO),OFONT12,,,,3)
oPrn:Say(590,nColI+0030,"Fone: "+SA1->A1_TEL,OFONT12,,,,3)
oPrn:Say(590,nColI+0700,"Fax: "+SA1->A1_FAX,OFONT12,,,,3)
oPrn:Line(400,nColI+1220,650,nColI+1220)
oPrn:Say(450,nColI+1300,"Vendedor: "+SA3->A3_NREDUZ,OFONT12,,,,3)
oPrn:Say(520,nColI+1300,"Departamento: ",OFONT12,,,,3)
oPrn:Say(520,nColI+1950,"Fone: "+Transform(SA3->A3_TEL,cTel),OFONT12,,,,3)
oPrn:Say(590,nColI+1300,"E-mail: "+SA3->A3_EMAIL,OFONT12,,,,3)

oPrn:Say(700,nColI+0050,"Codigo",OFONT12,,,,3)
oPrn:Say(700,nColI+0250,"Qtde",OFONT12,,,,3)
oPrn:Say(700,nColI+0390,"Und",OFONT12,,,,3)
oPrn:Say(700,nColI+0510,"Descrição",OFONT12,,,,3)
oPrn:Say(700,nColI+1400,"Fabricante",OFONT12,,,,3)
oPrn:Say(700,nColI+1790,"Peso ",OFONT12,,,,3)
oPrn:Say(700,nColI+1970,"Preço ",OFONT12,,,,3)
oPrn:Say(700,nColI+2190,"Total ",OFONT12,,,,3)

Return
