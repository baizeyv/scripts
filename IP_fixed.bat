@echo off

echo ~自动获取IP……
setlocal enabledelayedexpansion
for /f "tokens=2 delims=:" %%i in ('netsh int ip sh addr "以太网"^|findstr "IP"') do (
echo.
echo ~设置静态IP，并修改网关参数……
for /f "tokens=* delims= " %%j in ("%%i") do (
netsh int ip set addr "以太网" static %%j 255.255.255.0 192.168.1.254 1
)
)
echo ~设置DNS……
netsh interface ip set dns name="以太网" source=static addr=8.8.8.8 register=PRIMARY validate=no
netsh interface ip add dns name="以太网" addr=211.101.58.78 index=2 validate=no

echo ~设置完毕！按任意键退出……&pause>nul