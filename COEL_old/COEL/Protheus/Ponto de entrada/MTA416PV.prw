#include 'totvs.ch'

User Function MTA416PV() 

aAux			:= PARAMIXB
nCarray			:= len(_ACOLS[aAux])
nPos   := aScan( _aHeader, { |x|   ALLTRIM(x[2]) == "C6_X_PROD" } )  
nPoscf := aScan( _aHeader, { |x|   ALLTRIM(x[2]) == "C6_CF" } )      
nPosPCC := aScan( _aHeader, { |x|  ALLTRIM(x[2]) == "C6_PEDCLI" } )  
nPosIPCC:= aScan( _aHeader, { |x|  ALLTRIM(x[2]) == "C6_CITPCLI" } )
//nPosIPCC:= aScan( _aHeader, { |x|  ALLTRIM(x[2]) == "C6_ITECLI" } )
cCFOP:="" 

//B1_X_DESCC-->CAMPO A SER GRAVADO.



M->C5_LOJACLI  := SCJ->CJ_LOJA	
M->C5_CLPARC   := SCJ->CJ_CLPARC    
M->C5_CLANTE   := SCJ->CJ_CLANTE 
M->C5_TRANSP   := SCJ->CJ_CLTRANS 
M->C5_CLNOMCL  := M->CJ_NOMCLI   	
M->C5_CLPEDCL  := M->CJ_COTCLI  
M->C5_TIPOCLI  := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_TIPO")    
M->C5_TPFRETE  := SCJ->CJ_TPFRETE
M->C5_CLMSPED  := SCJ->CJ_CLMSPED
M->C5_MENNOTA  := SCJ->CJ_MENNOTA  
M->C5_VEND1	   := SCJ->CJ_CLVEND	   
M->C5_CODUSR   := SCJ->CJ_X_ID
_ACOLS[aAux][nPos]:= ALLTRIM(SCK->CK_X_PROD)    
_ACOLS[aAux][nPosPCC]:= ALLTRIM(SCK->CK_PEDCLI)                
_ACOLS[aAux][nPosIPCC]:= ALLTRIM(SCK->CK_ITECLI)   

If SA1->A1_TIPO =="X"
	cCFOP:=  "7"+SUBS(SF4->F4_CF,2,3)
	
Elseif SM0->M0_CODFIL =="01" .and. SA1->A1_TIPO <>"X"
	If SA1->A1_EST =="AM"
		cCFOP := "5"+SUBS(SF4->F4_CF,2,3)
	Else
		cCFOP:=  "6"+SUBS(SF4->F4_CF,2,3)	
	Endif
ElseIf SM0->M0_CODFIL =="02" .and. SA1->A1_TIPO <>"X"
	If SA1->A1_EST =="SP"
		cCFOP := "5"+SUBS(SF4->F4_CF,2,3)
	Else
		cCFOP:=  "6"+SUBS(SF4->F4_CF,2,3)	
	Endif
 	
Endif
_ACOLS[aAux][nPoscf]:= ALLTRIM(cCFOP)
 
Return ()