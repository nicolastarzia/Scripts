@echo off
REM ! CHANGE THIS TO  ! \
SET MyInterfaceWIFI=Wi-Fi
SET MyInterfaceLAN= Ethernet
REM ! MATCH YOUR NEED ! /

echo Active Routes:
echo Network Destination        Netmask          Gateway       Interface  Metric

route PRINT | findstr /C:" 0.0.0.0"

FOR /f "tokens=1" %%* IN (
   'netsh interface ipv4 show interfaces 
    ^| findstr /R /C:"%MyInterfaceWIFI%"'
   ) DO SET "MyInterfaceWIFI=%%*"

FOR /f "tokens=3" %%* IN (
   'netsh interface ipv4 show config "%MyInterfaceWIFI%"
    ^| findstr /R /C:"Default Gateway"'
   ) DO SET "TheGatewayWIFI=%%*"

FOR /f "tokens=1" %%* IN (
   'netsh interface ipv4 show interfaces 
    ^| findstr /R /C:"%MyInterfaceLAN%"'
   ) DO SET "MyInterfaceLAN=%%*"

FOR /f "tokens=3" %%* IN (
   'netsh interface ipv4 show config "%MyInterfaceLAN%"
    ^| findstr /R /C:"Default Gateway"'
   ) DO SET "TheGatewayLAN=%%*"


echo "InterfaceWifi: %MyInterfaceWIFI% GatewayWifi: %TheGatewayWIFI%"
echo "InterfaceLAN: %MyInterfaceLAN% GatewayLAN: %TheGatewayLAN%"
pause


route DELETE 0.0.0.0 MASK 0.0.0.0 %TheGatewayLAN%  ^
   METRIC 10 IF %MyInterfaceLAN%

route ADD 10.161.0.0 MASK 255.255.0.0 %TheGatewayLAN% ^
    METRIC 10 IF %MyInterfaceLAN%

route PRINT | findstr /C:"%TheGatewayWIFI%"
route PRINT | findstr /C:"%TheGatewayLAN%"
