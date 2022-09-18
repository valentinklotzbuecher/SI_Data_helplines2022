 
use "$rawdata\Countries\Germany\merged.dta", clear

 
keep if agecode<3
gen calls = 1 

fcollapse  (sum) calls  , by(ddate)

 merge 1:1  ddate using "$rawdata\otherdata.dta", keep(master match using) nogen


gen zero = 0

display mdy(3,10,2020)
display mdy(1,1,2021)
display mdy(2,24,2022)

 keep if year(ddate) >2019 

 tsset  ddate
 
 
mvsumm calls, gen(MAcalls) stat(mean) window(21) 
 
replace MAcalls =. if ddate >=  22793
replace calls =. if ddate >=  22809

replace newdeaths = 0 if newdeaths <0
gen newdeathsPOP = newdeaths/83

mvsumm newdeathsPOP, gen(MA7newdeathsPOP) stat(mean) window(7)  
mvsumm newdeaths, gen(MA7newdeaths) stat(mean) window(7)  
  
 keep if ddate<mdy(6,1,2022)

 sum MA7newdeaths,d
 gen newdeathsratexx = 100*(MA7newdeaths/r(max))
 gen schoolclosingindex = c1_schoolclosing*33
  
gen mdate = mofd(ddate)
format mdate %tm
gen wdate = wofd(ddate)

gen month = month(ddate)

bysort wdate: egen mcalls = sum(calls)
bysort wdate: egen smcalls = sd(calls)
bysort wdate: egen nmcalls = count(calls)
gen semcalls = smcalls/sqrt(nmcalls)

gen ci_lowerm = mcalls - 1.96*semcalls
gen ci_upperm = mcalls + 1.96*semcalls

 

  gen llim = 0
  gen ulim = 140
replace mcalls=. if ddate>mdy(5,27,2022)
replace mcalls=. if ddate<mdy(1,8,2020)
gen weekday = dow(ddate)
replace mcalls=. if weekday != 6
  


# delimit ;
twoway   rarea  llim ulim  ddate  if  bl_mn_idx_t_m02a >50 & bl_mn_idx_t_m02a !=. &   ddate>mdy(8,1,2020),  color(ebg*.3) fintensity(100)   yaxis(1) 
	|| rarea  llim ulim  ddate  if  bl_mn_idx_t_m02a >50 & bl_mn_idx_t_m02a !=. &   ddate<mdy(8,1,2020),  color(ebg*.3) fintensity(100)   yaxis(1) 
	|| rarea  llim ulim  ddate  if  ddate>mdy(3,13,2020) &   ddate<mdy(5,1,2020),  color(ebg*.6) fintensity(100)   yaxis(1) 
	|| rarea  llim ulim  ddate  if  ddate>mdy(4,20,2020) &   ddate<mdy(6,15,2020),  color(ebg*.3) fintensity(100)   yaxis(1) 
 	|| rarea  llim ulim  ddate  if  ddate>mdy(12,15,2020) &   ddate<mdy(2,15,2021),  color(ebg*.6) fintensity(100)   yaxis(1) 
		|| line  MAcalls   ddate, connect(ascending) lcolor(gs0)  yaxis(2),
	||  line stringencyindex  ddate, connect(ascending) lcolor(ebblue)  lpattern(dash)  yaxis(1) 
 	||  line newdeathsratexx ddate, connect(ascending) lpattern(shortdash) lcolor(cranberry)  yaxis(1) 
  	legend(label(3 "School closure") label(2 "Partial re-opening") label(7 "Reported COVID-19 deaths")    label(8 "Helpline calls, age<20")  label(6 "Stringency index")    pos(11) order(8 6 7 3 2  ) holes(2) cols(3) ring(1) colfirst size(large) region(lcolor(white)))	 title("{bf:A}" , size(large) pos(11) ring(1) justification(left) span)
	ytitle("Index score" , size(large) axis(1))	
	ytitle("Daily calls" , size(large) axis(2))
	graphregion(color(white)) plotregion(color(white)  margin(tiny)) bgcolor(white) 
		ylabel(0(20)100  , labcolor(gs0) angle(horizontal) labsize(large) axis(1) nogrid)
		ylabel( , labcolor(gs0) angle(horizontal) labsize(large) axis(2) nogrid)
		xtitle("") yscale(range(0 100) axis(2))  
		yscale(range(0 140) axis(1)) xscale(range(21915 22810)) 
 		xlabel(21915 22097 22281 22462 22646 22796, labsize(large) labcolor(gs0) format(%tddd_Mon_YY) nogrid) 
		xsize(6) ysize(3) name(grc1, replace)
	;
# delimit cr	

keep ddate calls MAcalls stringencyindex  newdeathsratexx
export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig 1A")  replace
  
		  

	 frame reset
	 
use "$rawdata/Countries/Germany/merged.dta", clear

gen calls = 1
*drop if female == .
drop if agecode == .

fcollapse    (sum) calls        , by(agecode ddate )

*append using "./TeX/Figures/ETseries.dta"

gen month = month(ddate)
gen year = year(ddate)
gen weekday = dow(ddate)
gen week =  week(ddate)

gen mdate = mofd(ddate)
format mdate %tm
gen wdate = wofd(ddate)
format wdate %tw 

	
	tab mdate, gen(nmdate)	
	tab wdate, gen(nwdate)
 	
	tab week, gen(nweek)
	 
	 
	
foreach J in 1 2 3{
foreach Y of numlist 1/41 {
gen age`J'Xnmdate`Y' = 0 
replace age`J'Xnmdate`Y' = 1 if nmdate`Y' == 1 & agecode == `J'
}
}
	
	
foreach J in 1 2 3 {
foreach Y of numlist 1/178 {
gen age`J'Xnwdate`Y' = 0 
replace age`J'Xnwdate`Y' = 1 if nwdate`Y' == 1 & agecode == `J'
}
}
 
 gen lcalls = log(calls)
	
	
save	"$rawdata/Countries/Germany/Merged_daily.dta", replace 
 
 frame reset
 
use "$rawdata/Countries/Germany/Merged_daily.dta", clear
   gen post19 = (year>2019)
gen pre20 = 1-post19
  
foreach J in 1 2 3 4 {
	gen age`J'Xprepan12 = 0
	replace age`J'Xprepan12 = pre20 if agecode ==`J'
	gen age`J'Xtrend = 0
	replace age`J'Xtrend = mdate if agecode ==`J'
}

  keep if post19
  
	reghdfe lcalls  age1Xnmdate13	age1Xnmdate15 age1Xnmdate16 age1Xnmdate17 age1Xnmdate18 age1Xnmdate19 age1Xnmdate20 age1Xnmdate21 age1Xnmdate22 age1Xnmdate23 age1Xnmdate24 age1Xnmdate25 age1Xnmdate26 age1Xnmdate27 age1Xnmdate28 age1Xnmdate29 age1Xnmdate30 age1Xnmdate31 age1Xnmdate32 age1Xnmdate33 age1Xnmdate34 age1Xnmdate35 age1Xnmdate36 age1Xnmdate37 age1Xnmdate38 age1Xnmdate39 age1Xnmdate40 age1Xnmdate41 age2Xnmdate13		age2Xnmdate15 age2Xnmdate16 age2Xnmdate17 age2Xnmdate18 age2Xnmdate19 age2Xnmdate20 age2Xnmdate21 age2Xnmdate22 age2Xnmdate23 age2Xnmdate24 age2Xnmdate25 age2Xnmdate26 age2Xnmdate27 age2Xnmdate28 age2Xnmdate29 age2Xnmdate30 age2Xnmdate31 age2Xnmdate32 age2Xnmdate33 age2Xnmdate34 age2Xnmdate35 age2Xnmdate36 age2Xnmdate37 age2Xnmdate38 age2Xnmdate39 age2Xnmdate40 age2Xnmdate41   age3Xnmdate13 	 age3Xnmdate15 age3Xnmdate16 age3Xnmdate17 age3Xnmdate18 age3Xnmdate19 age3Xnmdate20 age3Xnmdate21 age3Xnmdate22 age3Xnmdate23 age3Xnmdate24 age3Xnmdate25 age3Xnmdate26 age3Xnmdate27 age3Xnmdate28 age3Xnmdate29 age3Xnmdate30 age3Xnmdate31 age3Xnmdate32 age3Xnmdate33 age3Xnmdate34 age3Xnmdate35 age3Xnmdate36 age3Xnmdate37 age3Xnmdate38 age3Xnmdate39 age3Xnmdate40 age3Xnmdate41  , absorb(agecode   ) 
  
  * pre20wdateage1Xtrend age2Xtrend age3Xtrend age4Xtrend  age1Xprepan12 age2Xprepan12 age3Xprepan12 age4Xprepan12
  
 frame create eresults
 frame eresults: regsave using "$rawdata\cplot_evstudyVV.dta", ci level(95)  detail(all) addlabel(emodel,"joint") replace
frame change default
	 

  foreach J in 1 2 3 {
	 	reghdfe lcalls  nmdate13  	nmdate15 nmdate16 nmdate17 nmdate18 nmdate19 nmdate20 nmdate21 nmdate22 nmdate23 nmdate24 nmdate25 nmdate26 nmdate27 nmdate28 nmdate29 nmdate30 nmdate31 nmdate32 nmdate33 nmdate34 nmdate35 nmdate36 nmdate37 nmdate38 nmdate39 nmdate40 nmdate41  if agecode == `J', absorb(weekday) nocons
 frame eresults: regsave using "$rawdata\cplot_evstudyVV.dta", ci level(95)  detail(all) addlabel(agecode,`J', emodel, "separate") append
  }

		

frame change eresults
use "$rawdata\cplot_evstudyVV.dta", clear
keep if emodel == "separate"
 drop if var == "mdate"
drop if var  == "_cons"
  gen vcode = substr(var,7,.)
 destring vcode, replace
gen mdate = vcode +707
 format mdate %tm  

gen zero = 0 
gen evdate = ym(2020,2) 

 
replace ci_upper = ci_upper *100
replace ci_lower = ci_lower *100
replace coef = coef *100

xtset agecode mdate
tsfill
mvsumm coef, gen(MA3coef) stat(mean) window(3) force

 replace mdate = mdate-0.3 if agecode == 1
 replace mdate = mdate-0.1 if agecode == 2
 replace mdate = mdate+0.1 if agecode == 3
 

 
 
# delimit ;
graph twoway   rcap ci_upper ci_lower mdate  if agecode == 1  ,  msize(zero)  color(dkorange*0.5) lwidth(thin)
 		  || rcap ci_upper ci_lower mdate  if agecode == 2   ,  msize(zero)  color(midblue*0.5) lwidth(thin)
 		  || rcap ci_upper ci_lower mdate  if agecode == 3   ,  msize(zero)  color(gs0*0.5) lwidth(thin)
  		  || line  coef mdate if   agecode == 3 & mdate>evdate , lc(gs0)  lpattern(solid) lwidth(thin)
		  || line  coef mdate if   agecode == 2 & mdate>evdate , lc(midblue)  lpattern(dash)  lwidth(thin)
		  || line  coef mdate if   agecode == 1 &  mdate>evdate, lc(dkorange)  lpattern(solid)  lwidth(thin)
  		  || scatter  coef mdate if  agecode == 3 , mc(gs0)  m(o) msize(tiny) 
 		  || scatter  coef mdate if  agecode == 2 , mc(midblue)  m(o) msize(tiny) 
 		  || scatter  coef mdate if   agecode == 1  , mc(dkorange)  m(o) msize(tiny) 
		  || scatter zero evdate, mc(gs0)  m(d) msize(small) 
  		  legend(label(6 "Age<15") label(5 "Age 15-19")  label(4 "Age>19") ring(0) pos(11) rows(3) order(4 5 6) size(medlarge)) 	  plotregion( margin(small)) 
		ytitle("Percent deviation",size(large)) xtitle("") 
 title("{bf:B}" , size(large) pos(11) ring(1) justification(left) span)
 ylabel(  -50(25)50  ,   nogrid labsize(large) labcolor(gs0) )
		xlabel(720(6)744 748 , labsize(large) labcolor(gs0) nogrid  format(%tmMon_YY)) 
 		yline(0) 
		name(grc2, replace) ;
# delimit cr
		
		keep mdate coef ci_lower ci_upper
export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig 1B")  sheetreplace


use "$rawdata\Countries\Germany\merged.dta", clear

drop if agecode == .
gen age2 = 1 if agecode==3
replace age2 = 2 if agecode<3
gen calls = 1 

display mdy(1,1,2019)
display mdy(1,1,2020)
display mdy(1,1,2021)
display mdy(1,1,2022) 
fcollapse  (sum) calls (first)  year week , by(age2 ddate)
 
gen dayofyear =.
replace dayofyear = ddate - mdy(1,1,2019) if year == 2019
replace dayofyear = ddate - mdy(1,1,2020) if year == 2020 
replace dayofyear = ddate - mdy(1,1,2021) if year == 2021 
replace dayofyear = ddate - mdy(1,1,2022) if year == 2022 
 gen zero = 0
 gen weekday = dow(ddate)
gen weekdaycalls = calls if weekday != 0 & weekday != 6

gen satdaycalls = calls if weekday == 6
gen  sundaycalls= calls if weekday == 0
 
 drop if week == 1
 drop if week == 52 
 egen xid = group(age2 year)
 xtset xid ddate 

 drop if week> 21& year == 2022 
 xtset xid dayofyear 
 
mvsumm  calls, gen(MAcalls) stat(mean) window(21)  
 mvsumm  sundaycalls, gen(MAsundaycalls) stat(mean) window(21) force
*
 replace dayofyear = dayofyear + mdy(1,1,2020)
 
 gen xddate = ddate if year == 2019
 bysort dayofyear (year): carryforward xddate, replace
 
local DVAR "MAcalls"
# delimit ;
twoway   line `DVAR' xddate if year == 2019 & age2 == 2,connect(ascending) lcolor(gs6) lpattern(shortdash)    yaxis(2)
   	|| line   `DVAR' xddate if year == 2020 & age2 ==2, connect(ascending) lcolor(gs0)   lpattern(solid)      yaxis(2)  
   	|| line   `DVAR' xddate if year == 2021 & age2 ==2, connect(ascending) lcolor(plb1)  lpattern(solid)      yaxis(2) 
   	|| line   `DVAR' xddate if year == 2022 & age2 ==2, connect(ascending) lcolor(pll1)  lpattern(dash)       yaxis(2)
   	legend(title("Age<20") label(1 "2019")    label(2 "2020")  label(3 "2021")  label(4 "2022")     pos(4)  cols(1) ring(0) size(large) region(lcolor(white)))	 title("{bf:C}" , size(large) pos(11) ring(1) justification(left) span)
 	ytitle("Daily calls" , size(large) axis(2))
	graphregion(color(white)) plotregion(color(white)  margin(tiny)) bgcolor(white) 
 		ylabel(0(100)400 , labcolor(gs0) angle(horizontal) labsize(large) axis(2) nogrid)
		xtitle("") 
		xscale(range(21560 21910)) 
		xlabel(  21560(31)21900, format(%td_Mon) labsize(large) labcolor(gs0) notick nogrid) 
		xsize(6) ysize(3) name(grc4, replace)
	;
# delimit cr	// 21609 21731
local DVAR "MAcalls"
# delimit ;
twoway   line `DVAR' xddate if year == 2019 & age2 == 1,connect(ascending) lcolor(gs6) lpattern(shortdash)    yaxis(2)
   	|| line   `DVAR' xddate if year == 2020 & age2 ==1, connect(ascending) lcolor(gs0)   lpattern(solid)      yaxis(2)  
   	|| line   `DVAR' xddate if year == 2021 & age2 ==1, connect(ascending) lcolor(plb1)  lpattern(solid)      yaxis(2) 
   	|| line   `DVAR' xddate if year == 2022 & age2 ==1, connect(ascending) lcolor(pll1)  lpattern(dash)       yaxis(2)
   	legend(title("Age>19") label(1 "2019")    label(2 "2020")  label(3 "2021")  label(4 "2022")     pos(4)  cols(1) ring(0) size(large) region(lcolor(white)))	 title("{bf:D}" , size(large) pos(11) ring(1) justification(left) span)
 	ytitle("Daily calls" , size(large) axis(2))
	graphregion(color(white)) plotregion(color(white)  margin(tiny)) bgcolor(white) 
 		ylabel(0(500)2500 , labcolor(gs0) angle(horizontal) labsize(large) axis(2) nogrid)
		xtitle("") 
		xscale(range(21560 21910)) 
		xlabel(  21560(31)21900, format(%td_Mon) labsize(large) labcolor(gs0) notick nogrid) 
		xsize(6) ysize(3) name(grc3, replace)
	;
# delimit cr	

		  
		
 gen mdate = mofd(ddate)
 format mdate %tm
 bysort age2 mdate: egen meancalls= mean(calls)
br mdate age2 meancalls calls
 
gen agegroup = "Age>19" if age2 == 1
replace agegroup = "Age<20" if age2 == 2
 keep agegroup ddate  calls dayofyear MAcalls  
export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig 1CD")  sheetreplace

 
 
 	graph combine grc1  grc2 grc4 grc3  , cols(2)  	 	 xsize(20cm) ysize(12cm) altshrink iscale(0.9) imargin(medsmall) graphregion(margin(small)) name(grcc, replace)

	graph export "./TeX/Figures/overviewGermanyMONTHLY.pdf", replace


  

  