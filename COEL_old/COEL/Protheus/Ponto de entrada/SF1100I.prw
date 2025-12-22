#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF1100I        ºAutor ³Fabiano Pereiraº Data ³ 23/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executado apos gravacao do SF1 			  				  º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*********************************************************************
User Function SF1100I()
*********************************************************************

Local lRet 		:=	.T.
Local aAlias	:= GetArea()

If 	ExistBlock('PE_ImpXmlNFe')
	ExecBlock('PE_ImpXmlNFe',.F.,.F.,{'SF1100I'})
EndIf

if CEMPANT $"03/09" // Modificado por Andre em20/10/14 sm0->m0_codigo
	_cDoc  := space(10)
	
	//tela para entrada de dados referente a nfe de entrada de exportação
	@ 000,000 TO 250,350 DIALOG oDlg1 TITLE "Relacionar documento em PDF."
	@ 020,010 SAY "Documento Relacionado.: "
	@ 020,080 Get _cDoc SIZE 30,0
	
	@ 050,040 BUTTON "_OK" SIZE 35,15 ACTION GravaDoc() //chama função secundária
	//@ 240,138 BUTTON "Sai_r"  SIZE 35,15 ACTION Fim()
	ACTIVATE DIALOG oDlg1 CENTERED
	
	if  sf1->f1_formul == "S" .and. SA2->A2_EST == "EX" //.and. empty(sf1->f1_obsnfe4)       //se nota de importação
		
		_cobsmatic  := space(80) 
		_Di         := Space(20)
		_Frete      := Space(20)
		
		//tela para entrada de dados referente a nfe de entrada de exportação
		@ 000,000 TO 450,550 DIALOG oDlg1 TITLE "Entrada de dados auxiliares."
		@ 020,010 SAY "Obs nf import.: "
		@ 020,060 Get _cobsmatic
		@ 040,010 SAY "Numero da DI: "
		@ 040,060 Get _Di
		@ 060,010 SAY "Tipo de Frete: "
		@ 060,060 Get _Frete
		
		
		@ 200,060 BUTTON "_OK" SIZE 35,15 ACTION GravaDC() //chama função secundária
		//@ 240,138 BUTTON "Sai_r"  SIZE 35,15 ACTION Fim()
		ACTIVATE DIALOG oDlg1 CENTERED
		
	endif
EndIf


RestArea(aAlias)
Return(lRet)

Static function GravaDoc()   //Grava dados COELMATIC

RecLock("SF1",.F.)               

REPLACE SF1->F1_X_DOC WITH _cDoc

MsUnlock()

MSGBOX("Dados adicionais gravados")

Close(oDlg1)//fecha tela de entrada de dados


Return()

Static function GravaDC()   //Grava dados COELMATIC

RecLock("SF1",.F.)
REPLACE SF1->F1_OBSNFE4 WITH _cobsmatic
REPLACE SF1->F1_X_DI    WITH _Di
REPLACE SF1->F1_X_TPFR  WITH _Frete

MsUnlock()

MSGBOX("Dados adicionais gravados")

Close(oDlg1)//fecha tela de entrada de dados


Return()

