
use "$rawdata/Countries/Germany/merged.dta", clear 
 
 keep if agecode <3
*drop if female ==.
*drop if female == male

drop if agecode ==.  
keep if tsum >0  

 fcollapse    (mean)   x_* , by( year)
 
renvars   x_*, prefix(t_)
 reshape long t_   , i(year) j(topic) string
rename t_ mean_ 
  reshape wide mean_*, j(year) i(topic) 

save "$rawdata/Countries/Germany/overallsharesMERGED.dta", replace 

use "$rawdata/Countries/Germany/merged.dta", clear
*drop if female ==.
*drop if female == male
drop if agecode ==.  
keep if tsum >0  
 
 fcollapse    (mean)    x_* , by(agecode year)
 
renvars  x_*, prefix(t_)

 egen xid = group(year agecode)
reshape long t_   , i(xid) j(topic) string
rename t_ mean_age_ 
drop xid
egen xxid = group(topic year)
reshape wide mean_age_, j(agecode) i(xxid) 
drop xxid
reshape wide mean_age*, j(year) i(topic) 

   merge 1:1 topic using "$rawdata/Countries/Germany/overallsharesMERGED.dta", nogen

save "$rawdata/Countries/Germany/overallsharesMERGED.dta", replace 

use "$rawdata/Countries/Germany/merged.dta", clear
drop if female ==.
drop if female == male
drop if agecode ==.  
keep if tsum >0  
 
 fcollapse    (mean) x_*   , by(agecode female year)
renvars x_*, prefix(t_)
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
     merge 1:1 topic using "$rawdata/Countries/Germany/overallsharesMERGED.dta", nogen

save "$rawdata/Countries/Germany/overallsharesMERGED.dta", replace



 frame reset
clear all
use "$rawdata/Countries/Germany/merged.dta", clear
 sort ddate
 tab wdate, gen(wdx)
 
 
 
keep if ddate < mdy(5,31,2022)


*drop if female == male
*drop if female ==.
drop if agecode ==.  
keep if tsum >0  

global wdums "wdx53 wdx54 wdx55 wdx56 wdx57 wdx58 wdx59 wdx60 wdx61 wdx62 wdx63 wdx64 wdx65 wdx66 wdx67 wdx68 wdx69 wdx70 wdx71 wdx72 wdx73 wdx74 wdx75 wdx76 wdx77 wdx78 wdx79 wdx80 wdx81 wdx82 wdx83 wdx84 wdx85 wdx86 wdx87 wdx88 wdx89 wdx90 wdx91 wdx92 wdx93 wdx94 wdx95 wdx96 wdx97 wdx98 wdx99 wdx100 wdx101 wdx102 wdx103 wdx104 wdx105 wdx106 wdx107 wdx108 wdx109 wdx110 wdx111 wdx112 wdx113 wdx114 wdx115 wdx116 wdx117 wdx118 wdx119 wdx120 wdx121 wdx122 wdx123 wdx124 wdx125 wdx126 wdx127 wdx128 wdx129 wdx130 wdx131 wdx132 wdx133 wdx134 wdx135 wdx136 wdx137 wdx138 wdx139 wdx140 wdx141 wdx142 wdx143 wdx144 wdx145 wdx146 wdx147 wdx148 wdx149 wdx150 wdx151 wdx152 wdx153 wdx154 wdx155 wdx156 wdx157 wdx158 wdx159 wdx160 wdx161 wdx162 wdx163 wdx164 wdx165 wdx166 wdx167 wdx168 wdx169 wdx170 wdx171 wdx172 wdx173 wdx174 wdx175 wdx176 wdx177 wdx178  "

global FE "month h1code " // weekday phone
global SE "cluster h1code#mdate"

reghdfe x_fear $wdums   if agecode == 1, absorb($FE) nocons vce($SE)
 frame create eresults
frame eresults: regsave using "$rawdata\F2.dta", ci level(95) addlabel(depvartitel, x_fear , agecode, 1) detail(all) replace
frame change default


foreach J in 2 3  {
reghdfe x_fear $wdums   if agecode == `J', absorb($FE) nocons vce($SE)
frame eresults: regsave using "$rawdata\F2.dta", ci level(95) addlabel(depvartitel, x_fear , agecode, `J') detail(all) append
}


foreach J in 1 2 3  {
foreach T of varlist   x_lonely   x_addiction x_suicide x_family x_grief x_sex x_school x_economic x_pregnancy x_culture x_phealth x_parship x_love x_peers x_mhlight x_mhsevere x_leisure x_other x_violence { 
reghdfe `T' $wdums    if agecode == `J', absorb($FE) nocons vce($SE)
frame eresults: regsave using "$rawdata\F2.dta", ci level(95) addlabel(depvartitel, `T', agecode, `J') detail(all) append
}
}
// by gender:

drop if female ==.
drop if female == male


reghdfe x_fear $wdums   if agecode == 1 & female ==1, absorb($FE) nocons vce($SE)
frame eresults: regsave using "$rawdata\F2_fm.dta", ci level(95) addlabel(depvartitel, x_fear, agecode, 1, sex, "female") detail(all) replace

reghdfe x_fear $wdums   if agecode == 1 & female ==0, absorb($FE) nocons vce($SE)
 frame eresults: regsave using "$rawdata\F2_fm.dta", ci level(95) addlabel(depvartitel, x_fear, agecode, 1, sex, "male") detail(all) append
 
foreach J in 2 3 {
reghdfe x_fear $wdums   if agecode == `J' & female ==1, absorb($FE) nocons vce($SE)
frame eresults: regsave using "$rawdata\F2_fm.dta", ci level(95) addlabel(depvartitel, x_fear, agecode, `J', sex, "female") detail(all) append

reghdfe x_fear $wdums   if agecode == `J' & female ==0, absorb($FE) nocons vce($SE)
frame eresults: regsave using "$rawdata\F2_fm.dta", ci level(95) addlabel(depvartitel, x_fear, agecode, `J', sex, "male") detail(all) append
}

foreach J in 1 2 3 {
foreach T of varlist  x_lonely   x_addiction x_suicide x_family x_grief x_sex x_school x_economic x_pregnancy x_culture x_phealth x_parship x_love x_peers x_mhlight x_mhsevere x_leisure x_other x_violence  {	
reghdfe `T' $wdums    if agecode == `J'& female ==1, absorb($FE) nocons vce($SE)
frame eresults: regsave using "$rawdata\F2_fm.dta", ci level(95) addlabel(depvartitel, `T', agecode, `J', sex, "female") detail(all) append

reghdfe `T' $wdums    if agecode == `J'& female ==0, absorb($FE) nocons vce($SE)
est store e1_`T'
frame eresults: regsave using "$rawdata\F2_fm.dta", ci level(95) addlabel(depvartitel, `T', agecode, `J', sex, "male") detail(all) append
}
*/
}












  * Plot heatmaps 
use "$rawdata\F2.dta", clear
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
 
gen topic = depvar
gen topictitle = ""	
replace  topictitle = "Physical health" if topic == "x_phealth"
 replace  topictitle = "Loneliness" if topic == "x_lonely" 
   replace  topictitle = "Grief/loss" if topic == "x_grief" 
 replace  topictitle = "Fears/anxiety" if topic == "x_fear"  
 replace  topictitle = "Addiction" if topic == "x_addiction" 
 replace  topictitle = "Suicidality" if topic == "x_suicide" 
 replace  topictitle = "Family relations" if topic == "x_family" 
 replace  topictitle = "Sexuality" if topic == "x_sex" 
 replace  topictitle = "School/education" if topic == "x_school" 
 replace  topictitle = "Money/Work" if topic == "x_economic" 
 replace  topictitle = "Pregnancy" if topic == "x_pregnancy" 
 replace  topictitle = "Society/religion" if topic == "x_culture" 
 replace  topictitle = "Life with partner" if topic == "x_parship" 
 replace  topictitle = "Love/romance" if topic == "x_love" 
 replace  topictitle = "Peers/friends" if topic == "x_peers" 
 replace  topictitle = "Mental h. (moderate)" if topic == "x_mhlight" 
 replace  topictitle = "Mental health (severe)" if topic == "x_mhsevere" 
 replace  topictitle = "Leisure/hobbies" if topic == "x_leisure" 
 replace  topictitle = "Violence" if topic == "x_violence" 
 replace  topictitle = "Other topics" if topic == "x_other"  

 merge m:1  topic  using "$rawdata/Countries/Germany/overallsharesMERGED.dta" 

 sencode depvar, gen(tcode) gsort(mean_2019)
labmask tcode, val(topictitle)



 foreach J in 1 2 3  {
  gen tm`J' = 100*mean_age_`J'2019  if agecode == `J'
   gen meang`J' = round(tm`J',0.1)  
  format meang`J' %9.2fc 
  gen tmecn`J' =string(meang`J')  
 gen topictitle_Nage`J' = topictitle + " [" + tmecn`J' + "]" if agecode == `J'
 gen tcodeGage`J' = tcode if  agecode == `J'
 labmask tcodeGage`J', values(topictitle_Nage`J')
  } 
  
  foreach V of varlist coef ci* {
replace `V' = `V' * 100
}
   
 egen xid = group(tcode agecode)
xtset xid wdate
tsfill
mvsumm coef, gen(MAcoef) stat(mean) window(3) force
 	  
foreach T of numlist 1 2 3   {
 gen N_`T' =  N if agecode == `T' 
sort N_`T'
replace N_`T' = N_`T'[1]
tostring N_`T' , gen(N_`T'_string) format(%12.0fc) force
 
} 
						
gen abscoef = abs(coef)
bysort agecode: egen macoef = mean(abscoef)
tab macoef
bysort agecode: sum abscoef,d

 bysort agecode: egen smcalls = sd(abscoef)
bysort agecode: egen nmcalls = count(abscoef)
gen semcalls = smcalls/sqrt(nmcalls)

gen ci_lowerm = macoef - 1.96*semcalls
gen ci_upperm = macoef + 1.96*semcalls
						
ttest abscoef==0 if agecode ==1
ttest abscoef==0 if agecode ==2
ttest abscoef==0 if agecode ==3
 
						
 gen scoef = coef
 replace scoef = MAcoef if var == "wdx141"
 replace scoef = 0 if ci_lower < 0 & ci_upper >0
 replace scoef = 0 if scoef == .
 
 
foreach T of numlist 1 2 3   {
 local N_`T'= N_`T'_string[1]
display "`N_`T''"
}
 global DVAR "scoef"  // MA3Tresshare-mean19x  MAcoef
 
 gen one = 0.5
 gen xval = wdate-3131
 gen twen = 20.5
 
foreach T of numlist 1 2 3   {
 local N_`T'= N_`T'_string[1]
display "`N_`T''"
}
 # delimit ;
	heatplot $DVAR  i.tcodeGage1 i.wdate   if   agecode == 1, 
	graphregion(color(white) margin(vsmall)) aspectratio(.35) 
	ylabel(,  nogrid labsize(vsmall)  noticks) title("{bf:A}" , size(small) pos(11) ring(1) justification(left) span margin(vsmall))
	yscale(noline )  
	xtitle("") ytitle("")  
	ramp(labels(-10 -5 0 "0/n.s."  5 "+5" 10 "+10", labsize(vsmall)noticks) yscale(noline)  right length(12) subtitle("") space(4.5))
plotregion(margin(vsmall)) 
	cuts(-10(0.3)10) colors( matplotlib, coolwarm)  
		xsize(18cm) ysize(10cm)  subtitle("Age 0-14 ({it:n=}`N_1')", size( small) pos(12) ring(1))
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1)  )  
addplot(rbar one twen  xval if xval ==12 | xval == 113,  fcolor(gs0)  barwidth(.02) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) )  	xscale(range(1 126) lcolor(gs0) lwidth(vthin))	name(grc1, replace) fast;
 # delimit cr
 
 global colorlegend "  midblue*0.2  midblue*0.4    midblue*0.6   midblue*0.8  midblue   gs15    cranberry*0.2 cranberry*0.4   cranberry*0.6  cranberry*0.8  cranberry "
 
 
  # delimit ;
	heatplot $DVAR  i.tcodeGage2 i.wdate   if   agecode ==2, 
	graphregion(color(white) margin(vsmall)) aspectratio(.35) 
	ylabel(,  nogrid labsize(vsmall) noticks) 		title("{bf:B}" , size(small) pos(11) ring(1) justification(left) span margin(vsmall))
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1) ) 
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 	xscale(range(1 126) lcolor(gs0) lwidth(vthin))
 	yscale(noline)
   xtitle("") ytitle("")  subtitle("Age 15-19 ({it:n=}`N_2')", size( small) pos(12) ring(1))
	plotregion(margin(vsmall))   
	cuts(-10(0.3)10) colors( matplotlib, coolwarm)  
	ramp(labels(-10 -5 0  "0/n.s."  5 "+5" 10 "+10", labsize(vsmall) noticks) yscale(noline) right length(12) subtitle("") space(4.5 ))
		xsize(18cm) ysize(13cm)  
addplot(rbar one twen  xval if xval ==12 | xval == 113,  fcolor(gs0)  barwidth(.02) lwidth(none) lpattern(solid))
	name(grc2, replace) fast;
 # delimit cr	

 # delimit ;
	heatplot $DVAR  i.tcodeGage3 i.wdate   if   agecode == 3, 
	graphregion(color(white) margin(vsmall)) aspectratio(.35) 
	ylabel(,  nogrid labsize(vsmall) noticks) title("{bf:C}" , size(small) pos(11) ring(1) justification(left) span margin(vsmall))
	yscale(noline) 
	xtitle("") ytitle("")  
	ramp(labels(-10 -5 0 "0/n.s."   5 "+5" 10 "+10", labsize(vsmall)noticks) yscale(noline)  right length(12) subtitle("") space(4.5 ))
	cuts(-10(.3)10) colors( matplotlib, coolwarm)  
	plotregion(margin(vsmall))  subtitle("Age>19 ({it:n=}`N_3')", size( small) pos(12) ring(1))
		xsize(18cm) ysize(13cm)    
addplot(rbar one twen  xval if xval ==12 | xval == 113,  fcolor(gs0)  barwidth(.02) lwidth(none) lpattern(solid))
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1) ) 
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126)lcolor(gs0) lwidth(vthin))	name(grc3, replace) fast;
 # delimit cr	
 
  graph combine grc1  grc2 grc3 , cols(1) xsize(18cm) ysize(19cm)  imargin(small) graphregion(margin(zero))   iscale(.6)
 graph export "./TeX/Figures/F2x.pdf", replace
 graph export "C:\Users\VK\Sync\PhD Freiburg\Dis\Figures/F2x.pdf", replace
		
		
			
drop if var == ""
keep coef stderr ci_lower ci_upper N r2 vce clustvar wdate topictitle* mean_* macoef smcalls nmcalls semcalls ci_lowerm ci_upperm scoef agecode

gen topic = topictitle_Nage1 
replace topic = topictitle_Nage2  if agecode == 2
replace topic = topictitle_Nage3 if agecode == 3
sort agecode topic wdate
drop topictitl* agecode vce clustvar  
drop   mean_* macoef smcalls nmcalls semcalls ci_lowerm ci_upperm
order  topic wdate coef stderr ci_lower ci_upper N r2  scoef

export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig 2")  sheetreplace

  




 
 
 
 
  * Plot heatmaps by gender
use "$rawdata\F2_fm.dta", clear
drop if depvartitel == "x_*"
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
 
gen topic = depvar
gen topictitle = ""	
replace  topictitle = "Physical health" if topic == "x_phealth"
 replace  topictitle = "Loneliness" if topic == "x_lonely" 
   replace  topictitle = "Grief/loss" if topic == "x_grief" 
 replace  topictitle = "Fears/anxiety" if topic == "x_fear"  
 replace  topictitle = "Addiction" if topic == "x_addiction" 
 replace  topictitle = "Suicidality" if topic == "x_suicide" 
 replace  topictitle = "Family relations" if topic == "x_family" 
 replace  topictitle = "Sexuality" if topic == "x_sex" 
 replace  topictitle = "School/education" if topic == "x_school" 
 replace  topictitle = "Money/Work" if topic == "x_economic" 
 replace  topictitle = "Pregnancy" if topic == "x_pregnancy" 
 replace  topictitle = "Society/religion" if topic == "x_culture" 
 replace  topictitle = "Life with partner" if topic == "x_parship" 
 replace  topictitle = "Love/romance" if topic == "x_love" 
 replace  topictitle = "Peers/friends" if topic == "x_peers" 
 replace  topictitle = "Mental h. (light)" if topic == "x_mhlight" 
 replace  topictitle = "Mental h. (severe)" if topic == "x_mhsevere" 
 replace  topictitle = "Leisure/hobbies" if topic == "x_leisure" 
 replace  topictitle = "Violence" if topic == "x_violence" 
 replace  topictitle = "Other" if topic == "x_other"  

 merge m:1  topic  using "$rawdata/Countries/Germany/overallsharesMERGED.dta" 
drop if depvartitel == "x_currenttopic"

 sencode depvar, gen(tcode) gsort(mean_2019)
labmask tcode, val(topictitle)


  
  foreach V of varlist coef ci* {
replace `V' = `V' * 100
}
 gen abscoef = abs(coef)
bysort agecode sex: egen macoef = mean(abscoef)
tab macoef
bysort agecode sex: sum abscoef,d

 bysort agecode sex: egen smcalls = sd(abscoef)
bysort agecode sex: egen nmcalls = count(abscoef)
gen semcalls = smcalls/sqrt(nmcalls)

gen ci_lowerm = macoef - 1.96*semcalls
gen ci_upperm = macoef + 1.96*semcalls
						
ttest abscoef==0 if agecode ==1 & sex=="female"
ttest abscoef==0 if agecode ==1 & sex=="male"
						

 bysort tcode sex agecode wdate: keep if _n == 1
 egen xid = group(tcode sex agecode)
xtset xid wdate
tsfill
mvsumm coef, gen(MAcoef) stat(mean) window(3) force




 foreach J in 1 2 3  { 
 
   gen tm`J' = 100*mean_f_age_`J'2019  if agecode == `J' & sex == "female"
   replace tm`J' = 100*mean_m_age_`J'2019  if agecode == `J' & sex == "male"
   gen meang`J' = round(tm`J',0.1)  
  format meang`J' %9.1f 
  gen tmecn`J' =string(meang`J')  
 gen topictitle_Nage`J' = topictitle + " [" + tmecn`J' + "%]" if agecode == `J'
 gen tcodeGFage`J' = tcode if  agecode == `J' & sex == "female"
 gen tcodeGMage`J' = tcode if  agecode == `J' & sex == "male"
 labmask tcodeGFage`J', values(topictitle_Nage`J')
 labmask tcodeGMage`J', values(topictitle_Nage`J')
  } 
    encode sex, gen(sexcode)
foreach T of numlist 1 2 3  {
foreach G in  1 2 {
gen N_`G'_`T' =  N if agecode == `T' & sexcode == `G'
sort N_`G'_`T'
replace N_`G'_`T' = N_`G'_`T'[1]
tostring N_`G'_`T' , gen(N_`G'_`T'_string) format(%12.0fc) force
}
}


 gen scoef = coef
 replace scoef = MAcoef if var == "wdx141"
 replace scoef = 0 if ci_lower < 0 & ci_upper >0
 replace scoef = 0 if scoef == .
 
 
 global DVAR "scoef"  // MA3Tresshare-mean19x  MAcoef

 

 gen one = 0.5
 gen xval = wdate-3131
 gen twen = 20.5
 
  
 
 
foreach T of numlist 1 2 3   {
foreach G in   1 2{
local N_`G'_`T'= N_`G'_`T'_string[1]
display "`N_`G'_`T''"
}
}
 
 # delimit ;
	heatplot $DVAR  i.tcodeGFage1 i.wdate   if   agecode == 1 & sex == "female", 
	graphregion(color(white) margin(vsmall)) aspectratio(.35) 
	ylabel(,  nogrid labsize(vsmall) noticks)  title("{bf:A}" , size(small) pos(11) ring(1) justification(left) span)
	yscale(noline) 
	xtitle("") ytitle("")  
	ramp(labels(-10 -5 0 "0/n.s."  5 "+5" 10 "+10", labsize(vsmall) noticks)  yscale(noline)  right length(10) subtitle("") space(7 ))
	plotregion(margin(tiny))   
	cuts(-10(0.5)10) colors( matplotlib, coolwarm)  
		xsize(18cm) ysize(13cm)  subtitle("Female, age 0-14 ({it:n=}`N_1_1')", pos(12) ring(1) size(small))
addplot(rbar one twen  xval if xval ==12 | xval == 113,  fcolor(gs0)  barwidth(.05) lwidth(none) lpattern(solid))
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1) ) 
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	
name(grc1, replace) fast;
 # delimit cr	
 
 # delimit ;
	heatplot $DVAR  i.tcodeGFage2 i.wdate   if   agecode ==2 & sex == "female", 
	graphregion(color(white) margin(vsmall)) aspectratio(.35) 
	ylabel(,  nogrid labsize(vsmall) noticks) 	title("{bf:A}" , size(small) pos(11) ring(1) justification(left) span)
	ramp(labels(-10 -5 0 "0/n.s."  5 "+5" 10 "+10", labsize(vsmall) noticks) yscale(noline)  right length(10) subtitle("") space(7 ))
   xtitle("") ytitle("")  subtitle("Female, age 15-19 ({it:n=}`N_1_2')", pos(12) ring(1) size(small))
	plotregion(margin(tiny))  
	cuts(-10(0.4)10) colors( matplotlib, coolwarm)  
addplot(rbar one twen  xval if xval ==12 | xval == 113,  fcolor(gs0)  barwidth(.05) lwidth(none) lpattern(solid))
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1) ) 
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	
	name(grc2, replace) fast;
 # delimit cr	

 # delimit ;
	heatplot $DVAR  i.tcodeGFage3 i.wdate   if   agecode == 3 & sex == "female", 
	graphregion(color(white) margin(vsmall)) aspectratio(.35) 
	ylabel(,  nogrid labsize(vsmall) noticks) title("{bf:A}" , size(small) pos(11) ring(1) justification(left) span)
	yscale(noline) 
	xtitle("") ytitle("")  
	ramp(labels(-10 -5 0 "0/n.s."  5 "+5" 10 "+10", labsize(vsmall) notick) yscale(noline)  right length(10) subtitle("") space(7 ))
	plotregion(margin(tiny))  subtitle("Female, age 20 and older ({it:n=}`N_1_3')", pos(12) ring(1) size(small))
	cuts(-10(0.4)10) colors( matplotlib, coolwarm)  
addplot(rbar one twen  xval if xval ==12 | xval == 113,  fcolor(gs0)  barwidth(.03) lwidth(none) lpattern(solid))
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1) ) 
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	 name(grc3, replace) fast;
 # delimit cr	 
 
 # delimit ;
	heatplot $DVAR  i.tcodeGMage1 i.wdate   if   agecode == 1 & sex == "male", 
	graphregion(color(white) margin(vsmall)) aspectratio(.35) 
	ylabel(,  nogrid labsize(vsmall) noticks)  title("{bf:B}" , size(small) pos(11) ring(1) justification(left) span)
	yscale(noline) 
	xtitle("") ytitle("")  
	ramp(labels(-10 -5 0 "0/n.s."  5 "+5" 10 "+10", labsize(vsmall) noticks) yscale(noline)  right length(10) subtitle("") space(7 ))
	plotregion(margin(tiny))   
	cuts(-10(0.4)10) colors( matplotlib, coolwarm)  
		xsize(18cm) ysize(13cm)  subtitle("Male, age 0-14 ({it:n=}`N_2_1')", pos(12) ring(1) size(small))
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1) ) addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	
	name(grc1m, replace) fast;
 # delimit cr	
 
foreach T of numlist 1 2 3   {
foreach G in   1 2{
local N_`G'_`T'= N_`G'_`T'_string[1]
display "`N_`G'_`T''"
}
}

 # delimit ;
	heatplot $DVAR  i.tcodeGMage2 i.wdate   if   agecode ==2 & sex == "male", 
	graphregion(color(white) margin(vsmall)) aspectratio(.35)
	ylabel(,  nogrid labsize(vsmall) noticks)  		title("{bf:B}" , size(small) pos(11) ring(1) justification(left) span)
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1) )  
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	
 	yscale(noline) 
   xtitle("") ytitle("")  subtitle("Male, age 15-19 ({it:n=}`N_2_2')", pos(12) ring(1) size(small))
	plotregion(margin(tiny))  
	cuts(-10(0.4)10) colors( matplotlib, coolwarm)  
	ramp(labels(-10 -5 0 "0/n.s."  5 "+5" 10 "+10", labsize(vsmall) noticks) yscale(noline)  right length(10) subtitle("") space(7 ))
		xsize(18cm) ysize(13cm)  addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
	name(grc2m, replace) fast;
 # delimit cr		 
   

 # delimit ;
	heatplot $DVAR  i.tcodeGMage3 i.wdate   if   agecode == 3 & sex == "male", 
	graphregion(color(white) margin(vsmall)) aspectratio(.35) 
	ylabel(,  nogrid labsize(vsmall) noticks)  title("{bf:B}" , size(small) pos(11) ring(1) justification(left) span)
	yscale(noline) 
	xtitle("") ytitle("")  
	ramp(labels(-10 -5 0 "0/n.s."  5 "+5" 10 "+10", labsize(vsmall) noticks) yscale(noline)  right length(10) subtitle("") space(7 ))
	plotregion(margin(tiny))  subtitle("Male, age 20 and older ({it:n=}`N_2_3')", pos(12) ring(1) size(small))
	cuts(-10(0.4)10) colors( matplotlib, coolwarm)  
		xsize(18cm) ysize(13cm)  
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid tlength(1) ) 
addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))		name(grc3m, replace) fast;
 # delimit cr	 
 
 
 graph combine grc1 grc1m   , cols(1)    xsize(18cm) ysize(13cm)  imargin(small) graphregion(margin(zero))   iscale(.9)
 						graph export "./TeX/Figures/F2_1fm.pdf", replace
 
 graph combine grc2 grc2m   , cols(1)    xsize(18cm) ysize(13cm)  imargin(small) graphregion(margin(zero))   iscale(.9)
 						graph export "./TeX/Figures/F2_2fm.pdf", replace
 
 graph combine grc3 grc3m   , cols(1)    xsize(18cm) ysize(13cm)  imargin(small) graphregion(margin(zero))   iscale(.9)
 						graph export "./TeX/Figures/F2_3fm.pdf", replace
 
 
  
drop if var == ""
   sort sex  agecode topictitle wdate
gen agegroup = "Age < 15" if agecode == 1
replace agegroup = "Age 15-19 " if agecode == 2
replace agegroup = "Age > 19 " if agecode == 3
 keep sex agegroup  topictitle wdate coef stderr ci_lower ci_upper  N
order sex  agegroup  topictitle wdate coef stderr ci_lower ci_upper  

export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig S6-S8")  sheetreplace







