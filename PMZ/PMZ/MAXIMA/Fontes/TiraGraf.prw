
user function TiraGraf (_sOrig)
	local _sRet := _sOrig

	If Empty(_sOrig)
		_sRet := ""
		Return _sRet
	EndIf

	_sRet := strtran (_sRet, "á", "a")
	_sRet := strtran (_sRet, "é", "e")
	_sRet := strtran (_sRet, "í", "i")
	_sRet := strtran (_sRet, "ó", "o")
	_sRet := strtran (_sRet, "ú", "u")
	_SRET := STRTRAN (_SRET, "Á", "A")
	_SRET := STRTRAN (_SRET, "É", "E")
	_SRET := STRTRAN (_SRET, "Í", "I")
	_SRET := STRTRAN (_SRET, "Ó", "O")
	_SRET := STRTRAN (_SRET, "Ú", "U")
	_sRet := strtran (_sRet, "ã", "a")
	_sRet := strtran (_sRet, "õ", "o")
	_SRET := STRTRAN (_SRET, "Ã", "A")
	_SRET := STRTRAN (_SRET, "Õ", "O")
	_sRet := strtran (_sRet, "â", "a")
	_sRet := strtran (_sRet, "ê", "e")
	_sRet := strtran (_sRet, "î", "i")
	_sRet := strtran (_sRet, "ô", "o")
	_sRet := strtran (_sRet, "û", "u")
	_SRET := STRTRAN (_SRET, "Â", "A")
	_SRET := STRTRAN (_SRET, "Ê", "E")
	_SRET := STRTRAN (_SRET, "Î", "I")
	_SRET := STRTRAN (_SRET, "Ô", "O")
	_SRET := STRTRAN (_SRET, "Û", "U")
	_sRet := strtran (_sRet, "ç", "c")
	_sRet := strtran (_sRet, "Ç", "C")
	_sRet := strtran (_sRet, "à", "a")
	_sRet := strtran (_sRet, "À", "A")
	_sRet := strtran (_sRet, "º", ".")
	_sRet := strtran (_sRet, "ª", ".")
	_sRet := strtran (_sRet, chr (9), " ") // TAB
return _sRet
