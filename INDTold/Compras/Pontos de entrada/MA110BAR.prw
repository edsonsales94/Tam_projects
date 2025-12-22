#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA120BUT  ºAutor  ³Ener Fredes         º Data ³  07.12.10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE usado para a inserção de botões na tela do Pedido de    º±± 
±±º          ³ compra será usado para:                                    º±± 
±±º          ³ * Executar a rotina INCOME01.prw para mostrar a tela para aº±± 
±±º          ³   digitação do Follow-up do pedido e gravaçao na tabela SZDº±± 
±±º          ³ * Executar a rotina INCOME03.prw para mostrar a tela para  º±± 
±±º          ³   a digitação e validação da data de Entrega do pedido de  º±± 
±±º          ³   Compra ja esteja preenchida                              º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRA - Pedido de Compra                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA110BAR
	Local aBotao :={}                                                
	Local cNumSC := CA110NUM        
	Local aTemp := {}      
	Local cJustific := ""
	Local cCCAprv := Space(TamSX3("C1_CCAPRV")[1])
	
	
	SZF->(DbSetOrder(1))     
	SZF->(DbSeek(xFilial("SZF")+"1"+CA110NUM))            
	While !SZF->(Eof()) .And. Alltrim(SZF->ZF_TIPO) == "1" .And. Alltrim(SZF->ZF_NUM) == CA110NUM
		Aadd(aTemp,{SZF->ZF_ARQ,SZF->ZF_CAMINHO})
		SZF->(DbSkip())
	End                      

	PutGlbVars("SC_ANEXO_"+CA110NUM,aTemp)           
	
	SZ6->(DbSetOrder(1))
	If SZ6->(DbSeek(xFilial("SZ6")+"2"+CA110NUM))
		cJustific := Alltrim(SZ6->Z6_JUSTIFI)
	EndIf
	PutGlbValue("SC_JUST_"+CA110NUM,cJustific)
	
	SC1->(DbSetOrder(1))
	If SC1->(DbSeek(xFilial("SZ6")+CA110NUM))
		cCCAprv := SC1->C1_CCAPRV
	EndIf
	PutGlbValue("SC_CCAPRV_"+CA110NUM,cCCAprv)


	AAdd(aBotao,{"NOTE",{||U_INCOME02("Justificativa da Compra","2","",CA110NUM,"","","",.T.,.F.,"SC_JUST_"+CA110NUM,cJustific,.T.,{.T.,'SC1','C1_CCAPRV',"SC_CCAPRV_"+CA110NUM,cCCAprv})},"Obj/Justif","Obj/Justif"})
	AAdd(aBotao,{"BPMSRECI",{||U_INCOME04("1",CA110NUM,.F.,.T.,"SC_ANEXO_"+CA110NUM,.F.,{})},"Anexos","Anexos"})
	AAdd(aBotao,{"S4WB009N",{||U_INCOME05("1",CA110NUM)},"Exporta Anexo","Exporta Anexo"})
Return aBotao  

