

frame reset
use "$rawdata/Countries/Germany/GERcontactsFULL.dta", clear
  
keep if ddate < mdy(5,31,2022)

gen warcall = 0  
replace warcall = 1 if coronacall == 1 & ddate>mdy(2,23,2022) & hour >15
replace coronacall = 0 if  ddate<mdy(3,10,2020) 
replace coronacall = 0 if coronacall == 1 & ddate>mdy(2,23,2022) & hour >15
 
 tab agegroup
drop if agegroup == ""
gen ageclass = "0_14" if agemin<15
replace ageclass = "15_19" if  agemin>14 & agemin<20
replace ageclass = "20+" if agemin>19 & agemin !=.
replace ageclass = subinstr(ageclass,"_","-",.)
encode ageclass, gen(agecode)
tab agecode 
keep if topicsum >0  
*drop if othergender
*drop if female == .
tab agecode 
tab week, gen(wdum)
tab wdate, gen(wdx)
tab mdate, gen(mdx)

gen post19 = (year>2019)

*tab ddate, gen(ddx)
gen day = doy(ddate)

 
 global mdums "wdx53 wdx54 wdx55 wdx56 wdx57 wdx58 wdx59 wdx60 wdx61 wdx62 wdx63 wdx64 wdx65 wdx66 wdx67 wdx68 wdx69 wdx70 wdx71 wdx72 wdx73 wdx74 wdx75 wdx76 wdx77 wdx78 wdx79 wdx80 wdx81 wdx82 wdx83 wdx84 wdx85 wdx86 wdx87 wdx88 wdx89 wdx90 wdx91 wdx92 wdx93 wdx94 wdx95 wdx96 wdx97 wdx98 wdx99 wdx100 wdx101 wdx102 wdx103 wdx104 wdx105 wdx106 wdx107 wdx108 wdx109 wdx110 wdx111 wdx112 wdx113 wdx114 wdx115 wdx116 wdx117 wdx118 wdx119 wdx120 wdx121 wdx122 wdx123 wdx124 wdx125 wdx126 wdx127 wdx128 wdx129 wdx130 wdx131 wdx132 wdx133 wdx134 wdx135 wdx136 wdx137 wdx138 wdx139 wdx140 wdx141 wdx142 wdx143 wdx144 wdx145 wdx146 wdx147 wdx148 wdx149 wdx150 wdx151 wdx152 wdx153 wdx154 wdx155 wdx156 wdx157 wdx158 wdx159 wdx160 wdx161 wdx162 wdx163 wdx164 wdx165 wdx166 wdx167 wdx168 wdx169 wdx170 wdx171 wdx172 wdx173 wdx174 wdx175 wdx176 wdx177 wdx178  "

 
 
save "$rawdata/Countries/Germany/TS_sample.dta", replace


* Pre-pandemic shares for display:
use "$rawdata/Countries/Germany/TS_sample.dta", clear 
 

 fcollapse    (mean)     physhealth depressed grief fears stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt , by(year)
renvars  physhealth depressed grief fears stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt, prefix(t_)

reshape long t_   , i(year) j(topic) string
rename t_ mean_t_
reshape wide mean_t_, j(year) i(topic) 


save "$rawdata/Countries/Germany/overallshares.dta", replace 

use "$rawdata/Countries/Germany/TS_sample.dta", clear 
 

 fcollapse    (mean)     physhealth depressed grief fears stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt , by(agecode year)
 
renvars  physhealth depressed grief fears stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt, prefix(t_)
 egen xid = group(year agecode)
reshape long t_   , i(xid) j(topic) string
rename t_ mean_age_ 
drop xid
egen xxid = group(topic year)
reshape wide mean_age_, j(agecode) i(xxid) 
drop xxid
reshape wide mean_age*, j(year) i(topic) 

   merge 1:1 topic using "$rawdata/Countries/Germany/overallshares.dta", nogen

save "$rawdata/Countries/Germany/overallshares.dta", replace 


use "$rawdata/Countries/Germany/TS_sample.dta", clear 
 
drop if othergender
drop if female == .

 fcollapse    (mean)     physhealth depressed grief fears stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt , by(agecode female year)

renvars  physhealth depressed grief fears stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt, prefix(t_)
 egen xid = group(year agecode female)
reshape long t_   , i(xid) j(topic) string

gen mean_f_age_ = t_ if female == 1 
gen mean_m_age_ = t_ if female == 0 
drop xid
egen xxid = group(topic year female)
drop t_
reshape wide mean_f_age_ mean_m_age_, j(agecode) i(xxid) 

drop xxid
encode topic, gen(txode)
fcollapse    (firstnm)  topic mean_f_age_* mean_m_age_* , by(year txode)
reshape wide mean_f_age_* mean_m_age_*, j(year) i(topic) 
drop txode
  
   merge 1:1 topic using "$rawdata/Countries/Germany/overallshares.dta", nogen

save "$rawdata/Countries/Germany/overallshares.dta", replace 

use "$rawdata/Countries/Germany/TS_sample.dta", clear 
 
gen young = (agecode<3)

 fcollapse    (mean)     physhealth depressed grief fears stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt , by(young year)
 
renvars  physhealth depressed grief fears stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt, prefix(t_)
 egen xid = group(year young)
reshape long t_   , i(xid) j(topic) string
rename t_ mean_young_ 
drop xid
egen xxid = group(topic year)
reshape wide mean_young_, j(young) i(xxid) 
drop xxid
reshape wide mean_young*, j(year) i(topic) 

   merge 1:1 topic using "$rawdata/Countries/Germany/overallshares.dta", nogen

save "$rawdata/Countries/Germany/overallshares.dta", replace 



 
 frame reset
clear all
use "$rawdata/Countries/Germany/TS_sample.dta", clear
 
 global wdums "wdx53 wdx54 wdx55 wdx56 wdx57 wdx58 wdx59 wdx60 wdx61 wdx62 wdx63 wdx64 wdx65 wdx66 wdx67 wdx68 wdx69 wdx70 wdx71 wdx72 wdx73 wdx74 wdx75 wdx76 wdx77 wdx78 wdx79 wdx80 wdx81 wdx82 wdx83 wdx84 wdx85 wdx86 wdx87 wdx88 wdx89 wdx90 wdx91 wdx92 wdx93 wdx94 wdx95 wdx96 wdx97 wdx98 wdx99 wdx100 wdx101 wdx102 wdx103 wdx104 wdx105 wdx106 wdx107 wdx108 wdx109 wdx110 wdx111 wdx112 wdx113 wdx114 wdx115 wdx116 wdx117 wdx118 wdx119 wdx120 wdx121 wdx122 wdx123 wdx124 wdx125 wdx126 wdx127 wdx128 wdx129 wdx130 wdx131 wdx132 wdx133 wdx134 wdx135 wdx136 wdx137 wdx138 wdx139 wdx140 wdx141 wdx142 wdx143 wdx144 wdx145 wdx146 wdx147 wdx148 wdx149 wdx150 wdx151 wdx152 wdx153 wdx154 wdx155 wdx156 wdx157 wdx158 wdx159 wdx160 wdx161 wdx162 wdx163 wdx164 wdx165 wdx166 wdx167 wdx168 wdx169 wdx170 wdx171 wdx172 wdx173 wdx174 wdx175 wdx176 wdx177 wdx178 wdx179 wdx180"

reghdfe fears $wdums   if agecode < 3, absorb(month ) nocons vce(cluster mdate)
frame create eresults
frame eresults: regsave using "$rawdata\cplot_evstudyTSx.dta", ci level(95) addlabel(depvartitel, fears, age, "young") detail(all) replace
frame change default

foreach T in  physhealth depressed grief  stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt  {

reghdfe `T' $wdums    if  agecode < 3, absorb(month ) nocons vce(cluster mdate)
frame eresults: regsave using "$rawdata\cplot_evstudyTSx.dta", ci level(95) addlabel(depvartitel, `T', age, "young") detail(all) append

}
 
 
foreach T in fears physhealth depressed grief  stressemot anger selfharm confused addiction confshame lonely  suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat sexviol virtualrel migration  schooleduc worksit unempl dailyrout  poverty fininher housing belief church soccult   mortality physviol posithank volunt  {

reghdfe `T' $wdums    if  agecode == 3, absorb(month ) nocons vce(cluster mdate)
frame eresults: regsave using "$rawdata\cplot_evstudyTSx.dta", ci level(95) addlabel(depvartitel, `T', age, "old") detail(all) append

}
 
 
 
  * Plot heatmaps 
use "$rawdata\cplot_evstudyTSx.dta", clear
 gen vcode = substr(var,4,.)
destring vcode, replace
gen week = vcode if vcode < 53
replace week = vcode-52 if vcode > 52 & vcode <105
replace week = vcode-104 if vcode > 104 & vcode <157
replace week = vcode-156 if vcode > 156
gen wdate = yw(2020,week) if vcode < 105
replace wdate = yw(2021,week) if vcode > 104& vcode <157
replace wdate = yw(2022,week) if vcode > 156
format wdate %tw 

gen ddate = dofw(wdate)
format ddate %td 


gen topic = depvar
gen topictitle = ""	
replace  topictitle = "Physical health" if topic == "physhealth"
 replace  topictitle = "Depressed mood" if topic == "depressed"
 replace  topictitle = "Grief" if topic == "grief" 
 replace  topictitle = "Fears" if topic == "fears" 
 replace  topictitle = "Stress/exhaustion" if topic == "stressemot" 
 replace  topictitle = "Anger/agression" if topic == "anger" 
 replace  topictitle = "Self-harming behavior" if topic == "selfharm" 
 replace  topictitle = "Confusion" if topic == "confused" 
 replace  topictitle = "Addiction" if topic == "addiction" 
 replace  topictitle = "Confidence/shame" if topic == "confshame" 
 replace  topictitle = "Loneliness/isolation" if topic == "lonely" 
 replace  topictitle = "Positive feelings" if topic == "posithank" 
 replace  topictitle = "Suicidality of caller" if topic == "suicself" 
 replace  topictitle = "Suicidality of others" if topic == "suicother" 
 replace  topictitle = "Sexuality" if topic == "sex" 
 replace  topictitle = "Other mental health" if topic == "othermental" 
 replace  topictitle = "Partner search" if topic == "partnersearch" 
 replace  topictitle = "Life with partner" if topic == "livepartner" 
 replace  topictitle = "Parenting" if topic == "parenting" 
 replace  topictitle = "Pregnancy" if topic == "pregnancy" 
 replace  topictitle = "Family relations" if topic == "famrel" 
 replace  topictitle = "Everyday relationships" if topic == "everydayrel" 
 replace  topictitle = "Public institutions" if topic == "pubinstcont" 
 replace  topictitle = "Therapy/care" if topic == "caretherap" 
 replace  topictitle = "Separation" if topic == "separat" 
 replace  topictitle = "Mortality/death" if topic == "mortality" 
 replace  topictitle = "Virtual relationships" if topic == "virtualrel" 
 replace  topictitle = "Migration/integration" if topic == "migration" 
 replace  topictitle = "Physical violence" if topic == "physviol" 
 replace  topictitle = "Sexual violence" if topic == "sexviol" 
 replace  topictitle = "School/education" if topic == "schooleduc" 
 replace  topictitle = "Work situation" if topic == "worksit" 
 replace  topictitle = "Unemployment" if topic == "unempl" 
 replace  topictitle = "Daily routines" if topic == "dailyrout" 
 replace  topictitle = "Volunteering" if topic == "volunt" 
 replace  topictitle = "Poverty" if topic == "poverty" 
 replace  topictitle = "Financials" if topic == "fininher" 
 replace  topictitle = "Housing situation" if topic == "housing" 
 replace  topictitle = "Belief/values" if topic == "belief" 
 replace  topictitle = "Church/religion" if topic == "church" 
 replace  topictitle = "Society/culture" if topic == "soccult" 
 replace  topictitle = "COVID-19 pandemic" if topic == "coronacall"	
 replace  topictitle = "Other" if topic == "other"	
gen category = ""
replace  category = "Health" if topic == "physhealth"
 replace  category = "Health" if topic == "depressed"
 replace  category = "Health" if topic == "grief" 
 replace  category = "Health" if topic == "fears" 
 replace  category = "Health" if topic == "stressemot" 
 replace  category = "Health" if topic == "anger" 
 replace  category = "Violence" if topic == "selfharm" 
 replace  category = "Health" if topic == "confused" 
 replace  category = "Health" if topic == "addiction" 
 replace  category = "Health" if topic == "confshame" 
 replace  category = "Health" if topic == "lonely"
 replace  category = "Violence" if topic == "suicself" 
 replace  category = "Violence" if topic == "suicother" 
 replace  category = "Health" if topic == "othermental"  
 replace  category = "Health" if topic == "posithank" 
 replace  category = "Social" if topic == "partnersearch" 
 replace  category = "Social" if topic == "sex" 
 replace  category = "Social" if topic == "livepartner" 
 replace  category = "Social" if topic == "parenting" 
 replace  category = "Social" if topic == "pregnancy" 
 replace  category = "Social" if topic == "famrel" 
 replace  category = "Social" if topic == "everydayrel" 
 replace  category = "Society" if topic == "pubinstcont" 
 replace  category = "Health" if topic == "caretherap" 
 replace  category = "Social" if topic == "separat" 
 replace  category = "Health" if topic == "mortality" 
 replace  category = "Social" if topic == "virtualrel" 
 replace  category = "Society" if topic == "migration" 
 replace  category = "Violence" if topic == "physviol" 
 replace  category = "Violence" if topic == "sexviol" 
 replace  category = "Social" if topic == "schooleduc" 
 replace  category = "Livelihood" if topic == "worksit" 
 replace  category = "Livelihood" if topic == "unempl" 
 replace  category = "Health" if topic == "dailyrout" 
 replace  category = "Society" if topic == "volunt" 
 replace  category = "Livelihood" if topic == "poverty" 
 replace  category = "Livelihood" if topic == "fininher" 
 replace  category = "Livelihood" if topic == "housing" 
 replace  category = "Society" if topic == "belief" 
 replace  category = "Society" if topic == "church" 
 replace  category = "Society" if topic == "soccult"  

   
 gen catorder = 1 if category == "Health"
 replace catorder = 2 if category == "Social"
 replace catorder = 3 if category == "Violence"
 replace catorder = 4 if category == "Society"
 replace catorder = 5 if category == "Livelihood"
  
 
 
 merge m:1  topic  using "$rawdata/Countries/Germany/overallshares.dta" 

 
 sencode depvartitel, gen(xcode) gsort(mean_young_12019)  
labmask xcode, val(topictitle)


 foreach J in 0 1 {
  gen tm`J' = 100*mean_young_`J'2019   
   gen meang`J' = round(tm`J',0.1)  
  format meang`J' %9.1f 
  gen tmecn`J' =string(meang`J')  
 gen topictitle_Nage`J' = topictitle + " [" + tmecn`J' + "]"  
 gen tcodeGage`J' = xcode  
 labmask tcodeGage`J', values(topictitle_Nage`J')
  } 
    
  
  foreach V of varlist coef ci* {
replace `V' = `V' * 100
}
  

drop if topic == "coronacall"
egen xid = group(xcode age)
xtset xid wdate
tsfill
mvsumm coef, gen(MAcoef) stat(mean) window(3) force

 replace coef = 0 if coef == .
 	  
 gen scoef = coef
 replace scoef = MAcoef if var == "wdx141"
 replace scoef = 0 if ci_lower < 0 & ci_upper >0
 replace scoef = 0 if scoef == .
 global DVAR "scoef"  // MA3Tresshare-mean19x  MAcoef
 
 gen one = 0.5
 gen xval = wdate-3131
 gen twen = 41.5
 
tostring N , gen(N_string) format(%12.0fc) force
 gen Ny = N_string if age == "young"
 gen No = N_string if age == "old"  
 gsort -Ny
replace Ny = Ny[1] 
 gsort -No
replace No = No[1]
 local N_young= Ny[1] 
  local N_old= No[1]  

 # delimit ;
	heatplot $DVAR  i.tcodeGage1 i.wdate   if   age == "young", 
	graphregion(color(white) margin(small)) aspectratio(2.2) 
	ylabel(,  nogrid labsize(vsmall) noticks) title("{bf:A}" , size(vsmall) pos(11) ring(1) justification(left) span)
	yscale(noline) 
	xtitle("") ytitle("")  
 	plotregion(margin(tiny))  
	cuts(-10(0.5)10) colors(matplotlib, coolwarm)  
	ramp(labels(-10 -5 0 "0/n.s."   5 "+5" 10 "+10", labsize(vsmall) noticks ) xscale(noline) bottom length(20) subtitle("") space(4.5) )
	xsize(18cm) ysize(13cm)  
	subtitle("Age<20 (`N_young' calls)", pos(12) ring(1) size(vsmall))
 xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall) angle(45) nogrid tlength(1) ) 
addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126)lcolor(gs0) lwidth(vthin))	
	name(grc1, replace) fast;
 # delimit cr	
  
 # delimit ;
	heatplot $DVAR  i.tcodeGage0 i.wdate   if   age =="old", 
	graphregion(color(white) margin(small)) aspectratio(2.2) 
	ylabel(,  nogrid labsize(vsmall) noticks) 		title("{bf:B}" , size(vsmall) pos(11) ring(1) justification(left) span)
xlabel(1 "Jan 20" 12 "16 Mar" 113 "24 Feb" 27 "Jul 20" 53 "Jan 21" 80 "Jul 21" 105 "Jan 22" 126 "Jun 22", angle(45) nogrid tlength(1)  labsize(vsmall))  
 	yscale(noline)
   xtitle("") ytitle("")  subtitle("Age>19 (`N_old' calls)", pos(12) ring(1) size(vsmall))
	plotregion(margin(tiny))  
	cuts(-10(0.5)10) colors(matplotlib, coolwarm)  
	ramp(labels(-10 -5 0  "0/n.s."   5 "+5" 10 "+10", labsize(vsmall) noticks ) xscale(noline) bottom length(20) subtitle("") space(4.5) )
		 addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126)lcolor(gs0) lwidth(vthin))	
	name(grc2, replace) fast xsize(18cm) ysize(13cm) ;
 # delimit cr	
 

 graph combine grc1  grc2  , cols(2) xsize(9cm) ysize(7cm)  iscale(.85) imargin(tiny) graphregion(color(white) margin(zero)) 
 
 						graph export "./TeX/Figures/Heat_TSNgK_young.pdf", replace
  
  
  
   
   keep  age   topictitle wdate coef  ci_lower ci_upper N 
gen agegroup = "Age < 20" if age == "young" 
replace agegroup = "Age > 19" if age == "old"
drop age 
sort agegroup   topictitle wdate coef 
order   agegroup   topictitle wdate coef  ci_lower ci_upper N  

export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig S4")  sheetreplace

   
  

