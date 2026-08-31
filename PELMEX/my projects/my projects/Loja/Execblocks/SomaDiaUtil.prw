
User function SomaDiaUtil(dData,nDias)
Local vData := 0
Local nCont := 0 
Local nX :=0          

if(dData >= DDATABASE+nDias) //.AND. !(dow(dData) == 1) .AND. !(dow(dData) == 7)
		 If dow(dData)== 1 //domingo
		 	vData := dData+1
		 ElseIf dow(dData)== 7 //sabado  
		    vData := dData+2
		 Else
		    vData := dData
		 EndIf
else
	if dData >= DDATABASE	
		For nCont:=1 to nDias
		     dData += 1
		     If dow(dData)== 1 //domingo
		          nX += 1   
		          vData := dData+nX
		     ElseIf dow(dData)== 7 //sabado
		          nX += 1   
		          vData := dData+1+nX
		     Else
		     	  vData := dData + nX 
		     EndIf 
		 
		Next
	Else
		vData := DataValida(DDATABASE+15)
	EndIf  
	If dow(vData)== 1 //domingo
 		vdata += nX
 	elseif dow(vData) == 7		
	    vdata += 1 +nX
	else
		vData := vData
	endif     
EndIf 
Return vData