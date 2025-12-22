#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"
#include "RwMake.ch"
/*

ROTINA    :  AAFATE04
DESCRICAO :	 
           -> Percentual de Credito de Restituicao
             -> Criar campo na SF2 e SF3 e salva nesses campos  respectivos
           -> Notas Geradas por Faturamento Manual .And. apenas as filiais 06200 e 06300 .And. Possuir Valor ICMS
           -> NF MANUAL de SAida
DATA      : 25/01/2011
*/

User Function AAFATE04(cAlias, nRecno, nOpc)
    Local nPerc   := 0
    Local cFilRes := SuperGetMv("MV_FILRES",.F.,"")
    
    
    If cAlias == "SD2"
       SF3->(dbSetORder(5))
       SF3->(dbSeek(xFilial('SF3')+SD2->(D2_SERIE + D2_DOC)))
       
       SF2->(dbSetORder(1))
       SF2->(dbSeek(xFilial('SF2')+SD2->(D2_DOC + D2_SERIE)))
    elseif cAlias == "SF2"
       SF3->(dbSetORder(5))
       SF3->(dbSeek(xFilial('SF2')+SF2->(F2_SERIE + F2_DOC)))
    EndIf
    
    If SF3->F3_VALICM != 0 .And. SF3->F3_FILIAL $ cFilRes .And. SF2->F2_TIPO = 'N'  
      IF !( SF2->F2_CLIENTE $ '049293,058252')
         If IsBlind()
            nPerc  := GetPerc() 
         Else
            nPerc := AAGETQTD()       
         EndIf
      
       If SF2->(FieldPos("F2_XPERRES")) > 0
           SF2->(RecLock('SF2',.F.))
              SF2->F2_XPERRES := nPerc
           SF2->(MsUnlock())
       EndIf
      ENDIF 
       If SF3->(FieldPos("F3_XPERRES")) > 0
          SF3->(RecLock('SF3',.F.))
             SF3->F3_XPERRES := nPerc
          SF3->(MsUnlock())
       EndIf
    elseif SF3->F3_VALICM = 0
        Aviso('Atencao','Nota fiscal não possui debito de ICMS ',{'Ok'},2)
    elseif SF2->F2_TIPO  != 'N'
        Aviso('Atencao','Nota fiscal tem que ser do Tipo Normal',{'Ok'},2)
    elseif ! SF3->F3_FILIAL $ cFilRes
        Aviso('Atencao','Nota fiscal de Filial Invalida        ',{'Ok'},2)
    EndIf
    
Return Nil


Static Function AAGETQTD()

Private nQuant  := 0 //
Private cPerVld := SuperGetMv("MV_PERVLD",.F.,"")

Private cdNota  := SF3->F3_NFISCAL + '/' + SF3->F3_SERIE
Private _cdCli  := SF3->F3_CLIEFOR 
Private _cdLoj  := SF3->F3_LOJA
Private _cdNOme := Posicione('SA1',1,xFilial('SA1') + _cdCli + _cdLoj ,"A1_NOME")

Define Font oFnt3 Name "Ms Sans Serif" Bold

while !(Alltrim(Str(nQuant)) $ cPerVld ) .Or. nQuant <= 0
   
    nQuant := Iif( SF3->(FieldPos("F3_XPERRES")) > 0,SF3->F3_XPERRES,0)
    nQuant  := GetPerc() 
	Define Msdialog oDialog Title "Percentual" From 190,110 to 300,450 Pixel STYLE nOR(WS_VISIBLE,WS_POPUP)
   
   @ 001     ,010 SAY "Documento : " + cdNota of oDialog Pixel
   @ 011     ,010 SAY "Cliente : " + _cdCli + '/' + _cdLoj + ' - ' + _cdNome of oDialog Pixel
   
	@ 025,004 Say "Percentual de Restituição:" Size 220,10 Of oDialog Pixel Font oFnt3
	@ 035,004 Get nQuant         Size 100,10  WHEN .F.  Picture "@E 999,999.99"    //Pixel of oSenhas
	
	@ 050,100 BmpButton Type 1 Action ( setAction() )	
	Activate Dialog oDialog Centered
	
Enddo

Return nQuant

Static Function setAction()
If nQuant == 0
   Aviso('Atencao','Percentual Não Pode ser zerado, Permitido os Seguintes Valores: ' + SuperGetMv("MV_PERVLD",.F.,""),{"Ok"},1)
   Return
EndIf
If !Alltrim(Str(nQuant)) $ cPerVld
   Aviso('Atencao','Percentual Invalido somente e Permitido os Seguintes Valores: ' + SuperGetMv("MV_PERVLD",.F.,""),{"Ok"},1)
   Return
EndIf
oDialog:End()
Return 


Static Function GetPerc()

Local nPerc := 0
Local aAreaSF2 := SF2->(GetArea())
Local aAreaSD2 := SD2->(GetArea())
Local cParm := "MV_XLVR"
//D2_FILIAL+D2_DOC+D2_SERIE
SD2->(dbSetOrder(3))

//Verifica se o item existe no documento de saÃ­da
If SD2->(dbSeek(SF2->(xFilial("SD2")+F2_DOC+F2_SERIE)))
   //Percorre os itens do documento de saÃ­da
	While SD2->(!EOF()) .And. SF2->F2_FILIAL == SD2->D2_FILIAL .AND. SF2->F2_DOC == SD2->D2_DOC .AND. SF2->F2_SERIE == SD2->D2_SERIE
		
	  SF4->(dbSetOrder(1))
	  SF4->(dbSeek(XFILIAL("SF4")+SD2->D2_TES))
	  //Modificado Por Diego para pegar de um parametro a ser criado  seguindo
	  //MV_XLVR+NRLIVRO, Exempl MV_XVLR1 ira pegar o valor colocado nesse parametro
	  
	  nPerc := SuperGetMv("MV_XLVR"+Alltrim(SF4->F4_NRLIVRO),.F.,0)
	  /*
      If SF4->F4_NRLIVRO =="1"   
         nPerc := 90.25
      ElseIf SF4->F4_NRLIVRO =="2"
         nPerc := 75
      EndIf
	  */
	  SD2->(dbSkip())
	EndDo
EndIf

RestArea(aAreaSF2)
RestArea(aAreaSD2)


Return(nPerc) 


/*powered by DXRCOVRB*/
