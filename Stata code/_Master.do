//**************************************************
**	 Young people's mental and social distress in times of international crises: Evidence from helpline calls, 2019-2022
//**************************************************
clear all
version 17.0
set more off, permanently
set maxvar 32767
set varabbrev off
set excelxlsxlargefile on
global F5 "browse;"

cd ""
global rawdata ""

set scheme white_tableau
graph set window fontface "Arial Narrow"


//**************************************************

// Load, clean and combine data:
do "./Stata/prepare_KJT.do"
do "./Stata/prepare_ET.do"
do "./Stata/prepare_TS.do"
do "./Stata/prepare_otherdata.do"
do "./Stata/merge.do"

// Analysis and illustrations:
do "./Stata/mainfig1.do"
do "./Stata/mainfig2.do"
do "./Stata/mainfig3.do"
do "./Stata/mainfig4.do"
 
do "./Stata/SI_tables.do"
do "./Stata/SI_figureS1.do"
do "./Stata/SI_figureS2.do"
do "./Stata/SI_figureS3.do"
do "./Stata/SI_figureS4.do"


//**************************************************
exit, clear
//**************************************************
