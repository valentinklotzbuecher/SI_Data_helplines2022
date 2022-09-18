frame reset
use "$rawdata/Countries/Germany/merged.dta", clear

keep if ddate < mdy(5,31,2022) 
drop if agecode ==.  
keep if tsum >0  
 keep if year < 2021
drop if ddate > mdy(4,13,2019) & year == 2019
drop if ddate > mdy(4,13,2020) & year == 2020
 
gen post  = 0 
 replace post  = 1 if ddate>mdy(3,13,2019) & year(ddate)== 2019
replace post  = 1 if ddate>mdy(3,13,2020) 

gen postoutbreak= 0 
replace postoutbreak = 1 if ddate>mdy(3,13,2020) 



gen etime = week 
tab etime year
 
foreach J in 1 2 3 { 
gen postoutbreakXage`J' = 0
replace postoutbreakXage`J' = postoutbreak if agecode == `J' 
}

global FE "year week post h1code agecode"
global SE "cluster h1code#wdate"

 reghdfe x_fear  postoutbreakXage*   , absorb($FE) nocons vce($SE)
 frame create eresults
  frame eresults: regsave using "$rawdata\F3x.dta", ci level(95) addlabel( model, postcov) detail(all) replace
  frame change default
   
foreach V of varlist x_lonely   x_addiction x_suicide x_family x_grief x_sex x_school x_economic x_pregnancy x_culture x_phealth x_parship x_love x_peers x_mhlight x_mhsevere x_leisure x_other x_violence x_currenttopic {
	 reghdfe `V'  postoutbreakXage*   , absorb($FE) nocons vce($SE)
 frame eresults: regsave using "$rawdata\F3x.dta", ci level(95) addlabel( model, postcov) detail(all) append
}


// WAR
 use "$rawdata/Countries/Germany/merged.dta", clear

global FE "year week post h1code agecode"
global SE "cluster h1code#wdate"
keep if ddate < mdy(5,31,2022) 
drop if agecode ==.  
keep if tsum >0  

gen etime = week
keep if year < 2020 | year >2021
 drop if ddate > mdy(3,24,2019) & year == 2019
 drop if ddate > mdy(3,24,2022) & year == 2022 

tab etime year

gen post  = 0  
replace post  = 1 if ddate>mdy(2,24,2019) & year(ddate)== 2019
replace post  = 1 if ddate>mdy(2,24,2022) 

gen postinvasion= 0 
replace postinvasion = 1 if ddate>mdy(2,24,2022) 

 
foreach J in 1 2 3 { 
gen postinvasionXage`J' = 0
replace postinvasionXage`J' = postinvasion if agecode == `J' 
}

 reghdfe x_fear  postinvasionXage*   , absorb($FE) nocons vce($SE)
  frame eresults: regsave using "$rawdata\F3x.dta", ci level(95) addlabel( model, postcov) detail(all) append
  
 *
foreach V of varlist x_lonely   x_addiction x_suicide x_family x_grief x_sex x_school x_economic x_pregnancy x_culture x_phealth x_parship x_love x_peers x_mhlight x_mhsevere x_leisure x_other x_violence x_currenttopic {
	 reghdfe `V'  postinvasionXage*   , absorb($FE) nocons vce($SE)
 frame eresults: regsave using "$rawdata\F3x.dta", ci level(95) addlabel( model, postcov) detail(all) append
}


 
use "$rawdata\F3x.dta", clear
gen acode = substr(var,-1,1)
destring acode, replace
gen agegroup = "0_14" if acode == 1
replace agegroup = "15_19" if  acode == 2
replace agegroup = "20+" if    acode == 3
replace agegroup = subinstr(agegroup,"_","-",1)
encode agegroup, gen(agecode)
gen vcode = substr(var,5,3) 

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
 drop if topic == "x_currenttopic"
sencode topic, gsort(mean_2019) gen(tcode)
 labmask tcode, values(topictitle)
 
replace coef = coef * 100
replace ci_lower = ci_lower * 100
replace ci_upper = ci_upper * 100



 foreach J in 1 2 3  {
  gen tm`J' = 100*mean_age_`J'2019  if agecode == `J'
   gen meang`J' = round(tm`J',0.1)  
  format meang`J' %9.1f 
  gen tmecn`J' =string(meang`J')  
 gen topictitle_Nage`J' = topictitle + " (" + tmecn`J' + ")" if agecode == `J'
 gen tcodeGage`J' = tcode if  agecode == `J'
 labmask tcodeGage`J', values(topictitle_Nage`J')
  } 
 
 
  gen N_inv =  N if vcode == "inv"
sort N_inv
replace N_inv = N_inv[1]
tostring N_inv , gen(N_inv_string) format(%12.0fc) force
  
  gen N_out =  N if vcode == "out"
sort N_out
replace N_out = N_out[1]
tostring N_out , gen(N_out_string) format(%12.0fc) force
  
  
 
replace tcode = tcode-0.1 if vcode == "inv"
replace tcode = tcode+0.1 if vcode == "out"

replace tcodeGage1 = tcodeGage1 if vcode == "inv"
replace tcodeGage1 = tcodeGage1 if vcode == "out"

 local N_out= N_out_string[1]
display "`N_out'" 
  
 local N_inv= N_inv_string[1]
display "`N_inv'" 
# delimit ;
graph twoway  rcap ci_upper ci_lower  tcode   if vcode == "inv"  &acode==2 , horizontal msize(zero)  color(gs0) lwidth(medium)
  		  || scatter   tcode coef if vcode == "inv"  &acode==2, mc(gs0)  m(o) msize(small)  
		  || rcap ci_upper ci_lower tcode   if vcode == "out"&acode==2  , horizontal msize(zero)  color(red) lwidth(medium)
  		  || scatter   tcode coef  if vcode == "out" &acode==2, mc(red)  m(o) msize(small) 
		  legend(off)	  plotregion( margin(small)) 
		  plotregion( margin(small)) 
		ytitle("") xtitle("") subtitle("Age 15-19", pos(12) ring(1) size(small)) 
		ylabel(3(1)22  ,     labsize(zero) labcolor(white)  glwidth(vthin)   glcolor(ebg) glpattern(shortdash))
		xlabel(-10(5)10, labsize(small) labcolor(gs0) nogrid   ) 
		xtick(-12.5(2.5)12.5)
	name(grc2, replace) 
  		xline(0)  ;
# delimit cr

# delimit ;
graph twoway  rcap ci_upper ci_lower  tcode  if vcode == "inv"  &acode==3 , horizontal msize(zero)  color(gs0) lwidth(medium)
  		  || scatter   tcode coef if vcode == "inv"  &acode==3, mc(gs0)  m(o) msize(small)  
		  || rcap ci_upper ci_lower tcode   if vcode == "out"&acode==3  , horizontal msize(zero)  color(red) lwidth(medium)
  		  || scatter   tcode coef  if vcode == "out" &acode==3, mc(red)  m(o) msize(small) legend(label(1 "24 Feb 2022" "({it:n=} `N_inv')") label(3 "13 Mar 2020 " "({it:n=} `N_out')") order(3 1) region(lcolor(edkbg)) pos(4) ring(0) size(vsmall) cols(1))	  plotregion( margin(small)) 
		ytitle("") xtitle("") subtitle("Age 20 and older", pos(12) ring(1) size(small)) 
		ylabel(3(1)22  ,     labsize(zero) labcolor(white)  glwidth(vthin)   glcolor(ebg) glpattern(shortdash) )
		xlabel(-10(5)10, labsize(small) labcolor(gs0) nogrid   ) 
		xtick(-12.5(2.5)12.5)
 	name(grc3, replace) 
 		xline(0)  ;
# delimit cr

# delimit ;
graph twoway  rcap ci_upper ci_lower  tcode   if vcode == "inv"  &acode==1 , horizontal msize(zero)  color(gs0) lwidth(medium)
  		  || scatter   tcode coef if vcode == "inv"  &acode==1, mc(gs0)  m(o) msize(small)  
		  || rcap ci_upper ci_lower tcode   if vcode == "out"&acode==1  , horizontal msize(zero)  color(red) lwidth(medium)
  		  || scatter   tcode coef  if vcode == "out" &acode==1, mc(red)  m(o) msize(small) 
		  legend(off)	  plotregion( margin(small)) 
		  plotregion( margin(small)) 
		ytitle("") xtitle("")  
		ylabel(3(1)22   ,   valuelabel  labsize(small) labcolor(gs0)  glwidth(vthin)   glcolor(ebg) glpattern(shortdash)) 
		xlabel(-10(5)10, labsize(small) labcolor(gs0) nogrid   ) 
 		xtick(-12.5(2.5)12.5)
		subtitle("Age 0-14", pos(12) ring(1) size(small))   	name(grc1, replace)  fxsize(80) 
 		xline(0)  ;
# delimit cr 
 
 graph combine      grc1 grc2 grc3, cols(3) xsize(18cm) ysize(9cm)  iscale(1) imargin(zero) 
 						graph export "./TeX/Figures/F3.pdf", replace
						
	
	sort vcode agecode topictitle
	br vcode agegroup topictitle    coef  ci_lower  ci_upper
gen ddate = dofw(wdate)
format ddate %td

keep  vcode agegroup topictitle ddate   coef  ci_lower  ci_upper
replace vcode = "Pandemic outbreak (13 Mar 2020)" if vcode == "out"
replace vcode = "Russian invasion of Ukraine (24 Feb 2022)" if vcode == "inv"
drop if vcode == ""
export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig 4")  sheetreplace

		
		
		
		
			