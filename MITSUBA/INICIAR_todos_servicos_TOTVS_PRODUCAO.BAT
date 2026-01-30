echo script para INICIAR todos os servicos TOTVS da Mitsuba
echo Tazoe 26/092025
timeout 30
echo Deseja continuar???
pause

net start "licenseVirtual"
timeout 30
net start ".01.TOTVS | DBAccess64 P12"

net start ".02.TOTVS_P12_Broker_LoadBalance"
net start ".03.TOTVS P12 - Broker_Remote_Server_01"
net start ".03.TOTVS P12 - Broker_Remote_Server_02"
net start ".03.TOTVS P12 - Broker_Remote_Server_03"
REM net start ".03.TOTVS P12 - Broker_Remote_Server_04"

net start ".04.TOTVS P12 - AppServer_Schedule"
REM net start ".05.TOTVS P12 - CUSTO"
REM net start ".06.TOTVS | TAF P12"
net start ".07.TOTVS P12 - TSS"
net start ".08.TOTVS P12 - TSS TAF"
net start ".09.TOTVS P12 - SmartView REST"
REM net start ".10.TOTVS P12 - COMPILACAO"
net start "TReports.Agent"


pause
