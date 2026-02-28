@echo off

netsh interface ip set address "以太网" dhcp
echo ~自动获取IP……

netsh interface ip set dns  "以太网"  dhcp
echo ~自动获取DNS……
echo.
echo ~设置完毕！按任意键退出……&pause>nul