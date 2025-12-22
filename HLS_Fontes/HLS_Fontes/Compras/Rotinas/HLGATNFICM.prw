#include "Protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"
/*/{protheus.doc}HLGATNFICM
Gatilho para Nota Complemento/Entrada Preço/Frete 		
onde conforme TES "035/053/220/221/222/229/267" faz a   
alteração do Almoxarifado=11 para o Almoxarifado=10               
@author Ricardo Borges
@since 05/07/2014*/

User Function HLGATNFICM()

//cVar := &(ReadVar()) //Pega Conteúdo
LOCAL cVar := READVAR()

LOCAL aArea := GetArea()

//LOCAL lRet := .T.

Local xPosPROD  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})                      

Local xPosTES  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"})  

Local xPosALMOX  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL"})                       

//Local xPosVLTOT  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"})                      
                    
cVar := READVAR()   
                                                                           
If !aCols[n,Len(aHeader)+1] //Se Linha Não estiver Excluída

	If cTipo = "C" //Nota Fiscal de Preço de Frete
	                                                                 
	    If Alltrim(cVar)= "M->D1_TOTAL" 
	                        
	    	If !aCols[n][xPosTES] $ "035/053/220/221/222/229/267/464"	  // alterado vfv 12/11/15 - criado TES 267	- Luciano 23/07/18 - tes 464				
				aCols[n][xPosTES]:="000"  
			Endif     
			
			If aCols[n][xPosALMOX] <> "10"
			   aCols[n][xPosALMOX]:=""     
			Endif
				
			If oGetDados <> Nil
			    oGetDados:oBrowse:Refresh()
			Endif							    

			ApMsgAlert("Utilize as TES = 035,053,220,221,222,229 ou 464 para NF Complemento Preço/Frete.")	    // alterado vfv 12/11/15 - criado TES 267 - Luciano 23/07/18 - tes 464	
	
		Else
	    
			If Alltrim(cVar)= "M->D1_COD" .Or. Alltrim(cVar)= "M->D1_TES"
				      			
					If !Empty(aCols[n][xPosPROD])
						
						If Alltrim(cVar)= "M->D1_TES"
						   aCols[n][xPosTES]:=M->D1_TES
						   M->D1_TES := aCols[n][xPosTES]
						Endif
	
						If Alltrim(cVar)= "M->D1_COD"
						   aCols[n][xPosTES]:="000"
						Endif

						If oGetDados <> Nil
						    oGetDados:oBrowse:Refresh()
						Endif	
											
						//M->D1_TES := aCols[n][xPosTES]
						
						If aCols[n][xPosTES] $ "035/053/220/221/222/229/267/464"	// alterado vfv 12/11/15 - criado TES 267 - Luciano 23/07/18 - tes 464						
							aCols[n][xPosALMOX]:="10"    					
						Else				
						   
							aCols[n][xPosTES]:="000"  
							aCols[n][xPosALMOX]:=""  
	
							M->D1_TES := aCols[n][xPosTES]
							
							If oGetDados <> Nil
							    oGetDados:oBrowse:Refresh()
							Endif							    
																					
							ApMsgAlert("Utilize as TES = 035,053,220,221,222,229,267 ou 464 para NF Complemento Preço/Frete.")	// alterado vfv 12/11/15 - criado TES 267 - Luciano 23/07/18 - tes 464						
	
						Endif	   
						
					Else //Se Produto Não Digitado				
						aCols[n][xPosTES]:="000"  
						aCols[n][xPosALMOX]:=""  					
					Endif	 
	
					If oGetDados <> Nil
					    oGetDados:oBrowse:Refresh()
					Endif							    
								
			Endif
			
		Endif	
		
	Endif
			
Endif

RestArea(aArea)          

Return .T. 
