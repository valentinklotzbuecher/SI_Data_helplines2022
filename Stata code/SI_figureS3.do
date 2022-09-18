* Pre-pandemic shares for display:
  
use "$rawdata\Countries\Germany\Nummer gegen Kummer\KJT_beratungen.dta", clear
 append using "$rawdata\Countries\Germany\Nummer gegen Kummer\OB.dta"
drop if ddate< mdy(1,1,2019)
drop if ddate> mdy(5,31,2022)

gen year = year(ddate)
gen agex = subinstr(agegroup," (estimated)","",.)  
replace age = 7 if agex =="<8"
replace age = 26 if agex ==">25" 
gen  ageclass = "0- 19" if age <20 
replace  ageclass = "20+" if age >19 & age !=.
sencode ageclass, gen(agexcode) gsort(age)
drop if age ==.
*drop if female ==.
*drop if female ==  male 

fcollapse    (mean) t_psysoc*  t_viol* t_add* t_school* t_livsit* t_fam* t_love* t_peer*  t_sex* , by(year agexcode)
egen xid = group(year agexcode)
reshape long t_   , i(xid) j(topic) string
rename t_ mean_age_ 
drop xid
egen xxid = group(topic year)
reshape wide mean_age_, j(agexcode) i(xxid) 
drop xxid
reshape wide mean_age*, j(year) i(topic) 


 save "$rawdata/Countries/Germany/overallsharesKJT.dta", replace 
  
 
 
* Estimation  

frame reset
use "$rawdata\Countries\Germany\Nummer gegen Kummer\KJT_beratungen.dta", clear
gen phone = 1
 append using "$rawdata\Countries\Germany\Nummer gegen Kummer\OB.dta"
 
drop if ddate< mdy(1,1,2019)
drop if ddate> mdy(5,31,2022)
gen month = month(ddate)
gen year = year(ddate)
gen weekday = dow(ddate)
gen week =  week(ddate)
gen mdate = mofd(ddate)
format mdate %tm
gen wdate = wofd(ddate)
format wdate %tw

gen agex = subinstr(agegroup," (estimated)","",.)  
  replace age = 7 if agex =="<8"
  replace age = 26 if agex ==">25" 
gen  ageclass = "0-14" if age <15
replace  ageclass = "15-19" if age <20 & age >14
replace  ageclass = "20+" if age >19 & age !=.
  sencode ageclass, gen(agexcode) gsort(age)

*drop if female ==.
drop if age ==.  
   
tab wdate, gen(wdx)
        global wdums "wdx53 wdx54 wdx55 wdx56 wdx57 wdx58 wdx59 wdx60 wdx61 wdx62 wdx63 wdx64 wdx65 wdx66 wdx67 wdx68 wdx69 wdx70 wdx71 wdx72 wdx73 wdx74 wdx75 wdx76 wdx77 wdx78 wdx79 wdx80 wdx81 wdx82 wdx83 wdx84 wdx85 wdx86 wdx87 wdx88 wdx89 wdx90 wdx91 wdx92 wdx93 wdx94 wdx95 wdx96 wdx97 wdx98 wdx99 wdx100 wdx101 wdx102 wdx103 wdx104 wdx105 wdx106 wdx107 wdx108 wdx109 wdx110 wdx111 wdx112 wdx113 wdx114 wdx115 wdx116 wdx117 wdx118 wdx119 wdx120 wdx121 wdx122 wdx123 wdx124 wdx125 wdx126 wdx127 wdx128 wdx129 wdx130 wdx131 wdx132 wdx133 wdx134 wdx135 wdx136 wdx137 wdx138 wdx139 wdx140 wdx141 wdx142 wdx143 wdx144 wdx145 wdx146 wdx147 wdx148 wdx149 wdx150 wdx151 wdx152 wdx153 wdx154 wdx155 wdx156 wdx157 wdx158 wdx159 wdx160 wdx161 wdx162 wdx163 wdx164 wdx165 wdx166 wdx167 wdx168 wdx169 wdx170 wdx171 wdx172 wdx173 wdx174 wdx175 wdx176 wdx177 wdx178   " 
  


reghdfe t_psysoc  $wdums if age<20 , absorb(month  ) nocons vce(cluster mdate) 

frame create eresults
frame eresults: regsave using "$rawdata\cplot_evstudyNgK_X.dta", ci level(95) addlabel(depvartitel, t_psysoc , age, "young") detail(all) replace
frame change default

foreach T of varlist  t_psysoc_*  t_viol* t_add* t_school* t_livsit* t_fam* t_love* t_peer*  t_sex*    {
reghdfe `T'  $wdums if age<20 , absorb(month  ) nocons vce(cluster mdate) 

frame eresults: regsave using "$rawdata\cplot_evstudyNgK_X.dta", ci level(95) addlabel(depvartitel, `T', age, "young") detail(all) append
}

foreach T of varlist  t_psysoc*  t_viol* t_add* t_school* t_livsit* t_fam* t_love* t_peer*  t_sex*    {
reghdfe `T'  $wdums if age>19 , absorb(month  ) nocons vce(cluster mdate) 

frame eresults: regsave using "$rawdata\cplot_evstudyNgK_X.dta", ci level(95) addlabel(depvartitel, `T', age, "old") detail(all) append
}

 
 
 
 
 
 
						
						
use "$rawdata\cplot_evstudyNgK_X.dta", clear
 
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

encode age, gen(acode)

split depvar, p("_")
rename depvar2  category
gen topic = category + "_" + depvar3 if depvar3 !=""
replace topic = category if depvar3 ==""

 
gen topictitle = ""	
replace  topictitle = "Drugs" if topic == "add_drugs"
replace  topictitle = "Alcohol" if topic == "add_alc"
replace  topictitle = "Tobacco" if topic == "add_tobac"
replace  topictitle = "Self-harm" if topic == "add_selfharm"
replace  topictitle = "Suicidality" if topic == "add_suic"
replace  topictitle = "Obesity" if topic == "add_obese"
replace  topictitle = "Anorexia" if topic == "add_anorex"
replace  topictitle = "Bad grades" if topic == "school_grades"
replace  topictitle = "Problems w. teachers" if topic == "school_teachr"
replace  topictitle = "Conflict w. classmates" if topic == "school_clssmts"
replace  topictitle = "Mobbing in school" if topic == "school_mobb"
replace  topictitle = "Overload in school" if topic == "school_overld"
replace  topictitle = "Learning difficulties" if topic == "school_learn"
replace  topictitle = "Apprenticeship" if topic == "school_work"
replace  topictitle = "Truancy" if topic == "school_skip"
replace  topictitle = "School switching" if topic == "school_swtch"
replace  topictitle = "Fears of failure" if topic == "school_fearfail"
replace  topictitle = "Other school prob." if topic == "school_other"
replace  topictitle = "Body/appearance" if topic == "psysoc_body"
replace  topictitle = "Disease, disability" if topic == "psysoc_diesease"
replace  topictitle = "Grief, loss" if topic == "psysoc_grief"
replace  topictitle = "Loneliness" if topic == "psysoc_lonely"
replace  topictitle = "Boredom" if topic == "psysoc_bored"
replace  topictitle = "Leisure, hobbies" if topic == "psysoc_leisure"
replace  topictitle = "Fear/anxiety" if topic == "psysoc_fear"
replace  topictitle = "Confidence" if topic == "psysoc_conf"
replace  topictitle = "Identity" if topic == "psysoc_ident"
replace  topictitle = "Mental health prob." if topic == "psysoc_psychprob"
replace  topictitle = "Psychological violence" if topic == "viol_psych"
replace  topictitle = "Physical violence" if topic == "viol_phys"
replace  topictitle = "Sexual violence" if topic == "viol_sex"
replace  topictitle = "Other violence" if topic == "viol_other"
replace  topictitle = "Runaway child" if topic == "livsit_runawy"
replace  topictitle = "Law enforcement" if topic == "livsit_law"
replace  topictitle = "Radicalization" if topic == "livsit_radicl"
replace  topictitle = "Living situation" if topic == "livsit_envir"
replace  topictitle = "Career opportunities" if topic == "livsit_opport"
replace  topictitle = "Fear of future" if topic == "livsit_fearfut"
replace  topictitle = "Religion" if topic == "livsit_relig"
replace  topictitle = "Racism" if topic == "livsit_racism"
replace  topictitle = "Asylum" if topic == "livsit_asylm"
replace  topictitle = "Internet safety" if topic == "livsit_safinet"
replace  topictitle = "Social environment" if topic == "livsit_other"
replace  topictitle = "Rules/restrictions" if topic == "fam_rules"
replace  topictitle = "Child-parent relations" if topic == "fam_childpar"
replace  topictitle = "Problems with siblings" if topic == "fam_siblgns"
replace  topictitle = "Missing support" if topic == "fam_supp"
replace  topictitle = "Conflict with parents" if topic == "fam_parconf"
replace  topictitle = "Loss of family member" if topic == "fam_loss"
replace  topictitle = "Health of family" if topic == "fam_health"
replace  topictitle = "Poverty of family" if topic == "fam_povrty"
replace  topictitle = "Foster care" if topic == "fam_exhousng"
replace  topictitle = "Care of family member" if topic == "fam_care"
replace  topictitle = "Other family prob." if topic == "fam_other"
replace  topictitle = "Crush/in love" if topic == "love_crush"
replace  topictitle = "Contact wish" if topic == "love_contwish"
replace  topictitle = "Heartache" if topic == "love_heart"
replace  topictitle = "Romantic relationship" if topic == "love_parship"
replace  topictitle = "Relationship conflict" if topic == "love_relconf"
replace  topictitle = "Jealousy" if topic == "love_jealous"
replace  topictitle = "Separation (wish)" if topic == "love_separat"
replace  topictitle = "Left by partner" if topic == "love_left"
replace  topictitle = "Distance relationship" if topic == "love_distrel"
replace  topictitle = "Affairs, infidelity" if topic == "love_infid"
replace  topictitle = "Other romantic prob." if topic == "love_other"
replace  topictitle = "Searching friends" if topic == "peer_frndsearch"
replace  topictitle = "Conflict with friends" if topic == "peer_conf"
replace  topictitle = "Competition with peers" if topic == "peer_comp"
replace  topictitle = "Loyalty of peers" if topic == "peer_loyal"
replace  topictitle = "Outsider, exclusion" if topic == "peer_outsdr"
replace  topictitle = "Mobbing by/of peers" if topic == "peer_mobb"
replace  topictitle = "Loss of friends" if topic == "peer_loss"
replace  topictitle = "Status symbols" if topic == "peer_statsym"
replace  topictitle = "Peer pressure" if topic == "peer_prssre"
replace  topictitle = "Test of courage" if topic == "peer_dare"
replace  topictitle = "Other peer prob." if topic == "peer_other"
replace  topictitle = "Information about sex" if topic == "sex_info"
replace  topictitle = "Contraception" if topic == "sex_contrcptn"
replace  topictitle = "First time sex" if topic == "sex_ftime"
replace  topictitle = "Pregnancy " if topic == "sex_preg"
replace  topictitle = "Sexual orientation" if topic == "sex_orient"
replace  topictitle = "Masturbation" if topic == "sex_mast"
replace  topictitle = "Sexual practices" if topic == "sex_pract"
replace  topictitle = "Risks/STD prevention" if topic == "sex_risk"
replace  topictitle = "Sexual phantasies" if topic == "sex_phant"
replace  topictitle = "Abortion" if topic == "sex_abort"
replace  topictitle = "Other sex problems" if topic == "sex_other"
replace  topictitle = "COVID: Loneliness" if topic == "corona_lonely"
replace  topictitle = "COVID: Domestic violence" if topic == "corona_domviol"
replace  topictitle = "COVID: Family conflict" if topic == "corona_famlyconfl"
replace  topictitle = "COVID: Boredom" if topic == "corona_bored"
replace  topictitle = "COVID: Psychological stability" if topic == "corona_psychstablty"
replace  topictitle = "COVID: School/education" if topic == "corona_school"
replace  topictitle = "COVID: Worried about others" if topic == "corona_worrdothers"
replace  topictitle = "COVID: Fear of infection" if topic == "corona_fearinfect"
replace  topictitle = "COVID: Fear of loss" if topic == "corona_fearloss"
replace  topictitle = "COVID: Uncertainty" if topic == "corona_insecurty"
replace  topictitle = "COVID: Anger, aggresion" if topic == "corona_anger"
replace  topictitle = "COVID: Fear of future" if topic == "corona_fearfuture"
replace  topictitle = "COVID" if topic == "coronacall"
replace  topictitle = "War" if topic == "warcall"

replace  topictitle = "{bf:Psycho-social/health}" if topic == "psysoc"
replace  topictitle = "{bf:Problems in family}" if topic == "fam"
replace  topictitle = "{bf:Living situation}" if topic == "livsit"
replace  topictitle = "{bf:Violence, abuse}" if topic == "viol"
replace  topictitle = "{bf:Addiction/self-harm}" if topic == "addiction"
replace  topictitle = "{bf:School/education}" if topic == "school"
replace  topictitle = "{bf:Friends/peer group}" if topic == "peer"
replace  topictitle = "{bf:Relationship/love}" if topic == "love"
replace  topictitle = "{bf:Sexuality}" if topic == "sex"

replace  topictitle = "War: Political engagement" if topic == "war_polengage"
replace  topictitle = "War: Afraid about relatives/friends" if topic == "war_fearrelsfrnds"
replace  topictitle = "War: Fear of future" if topic == "war_fearfuture"
replace  topictitle = "War: Fear of nuclear weapons" if topic == "war_fearnuclear"
replace  topictitle = "War: Fear of war" if topic == "war_fearwar"
replace  topictitle = "War: Opinion" if topic == "war_opinion"
replace  topictitle = "War: Empathy for Ukraine" if topic == "war_empathy"
replace  topictitle = "War: Aid" if topic == "war_help"

replace  category="add" if topic == "addiction"
gen catorder = 1 if category=="psysoc" 
replace catorder = 2 if category=="love" 
replace catorder = 3 if category=="peer" 
replace catorder = 4 if category=="fam" 
replace catorder = 5 if category=="sex" 
replace catorder = 6 if category=="viol" 
replace catorder = 7 if category=="livsit" 
replace catorder = 8 if category=="school" 
replace catorder = 9 if category=="add" 

gen broad = (topic=="psysoc" | topic == "viol" | topic == "addiction" | topic == "school" | topic == "livsit" | topic == "fam" | topic == "love" | topic == "peer" | topic == "sex" )


merge m:1 topic using "$rawdata/Countries/Germany/overallsharesKJT.dta" 
   
   

sencode topictitle, gen(tcode) gsort(-catorder mean_age_12019)  
 
 foreach J in 1 2   {
  gen tm`J' = 100*mean_age_`J'2019  if acode == `J'
   gen meang`J' = round(tm`J',0.1)  
  format meang`J' %9.1f 
  gen tmecn`J' =string(meang`J')  
 gen topictitle_Nage`J' = topictitle + " [" + tmecn`J' + "]" if acode == `J'
 gen tcodeGage`J' = tcode if  acode == `J'
 labmask tcodeGage`J', values(topictitle_Nage`J')
  } 
   
 * keep if mean_t_2019 > 0.02
*replace coef = 0 if ci95_lower < 0 & ci95_upper >0

gen ci90_lower = coef-invnormal(0.95)*(stderr)
gen ci95_lower = coef-invnormal(0.975)*(stderr)
gen ci99_lower = coef-invnormal(0.99)*(stderr)

gen ci90_upper = coef+invnormal(0.95)*(stderr)
gen ci95_upper = coef+invnormal(0.975)*(stderr)
gen ci99_upper = coef+invnormal(0.99)*(stderr)
foreach V of varlist coef ci* {
replace `V' = `V' * 100
}

egen xid = group(acode tcode)

 xtset xid wdate
tsfill
mvsumm coef, gen(MAcoef) stat(mean) window(3) force
 	 

 gen one = 0.5
 gen xval = wdate-3131
 gen twen = 96.5
	   
foreach T of numlist 1 2   {
 gen N_`T' =  N if acode == `T' 
sort N_`T'
replace N_`T' = N_`T'[1]
tostring N_`T' , gen(N_`T'_string) format(%12.0fc) force
 
}
foreach T of numlist 1 2    {
 local N_`T'= N_`T'_string[1]
display "`N_`T''"
}
 
*replace $DVAR = 0 if broad == 1
 gen scoef = coef
 replace scoef = 0 if ci_lower < 0 & ci_upper >0

 global DVAR "scoef"  // MA3Tresshare-mean19x& broad == 0
 # delimit ;
	heatplot $DVAR  i.tcodeGage1  i.wdate  if    catorder!=. & acode == 1, 
	graphregion(color(white) margin(small)) 
	ylabel(, labsize(tiny) nogrid noticks) aspectratio(3.2) 
	title("{bf:B}" , size(vsmall ) pos(11) ring(1) justification(left) span) subtitle("Age > 19  (`N_1' calls)", pos(12) ring(1) size(vsmall) margin(vsmall))
	yscale(noline) 	  		xlabel(,  labsize(tiny)     nogrid)  
	xtitle("") ytitle("")   
		xlabel(1(26)169, valuelabel) 
	plotregion(margin(tiny)) 
	cuts(-10(0.5)10) colors(matplotlib, coolwarm) 
		ramp(labels(-10 -5 0  "0/n.s." 5 "+5" 10 "+10", labsize(tiny) noticks ) xscale(noline) bottom length(15) subtitle("") space(4)   )
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(tiny)  nogrid tlength(1) angle(45)) 
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126)lcolor(gs0) lwidth(vthin))
addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
name(grc2, replace) fast;
 # delimit cr	
   
 # delimit ;
	heatplot $DVAR  i.tcodeGage2  i.wdate  if    catorder!=. & acode == 2, 
	graphregion(color(white) margin(small)) 
	ylabel(, labsize(tiny) nogrid noticks) aspectratio(3.2) 
	title("{bf:A}" , size(vsmall) pos(11) ring(1) justification(left) span) subtitle("Age < 20 (`N_2' calls)", pos(12) ring(1) size(vsmall) margin(vsmall))
	yscale(noline) 	  		xlabel(,  labsize(tiny)    nogrid)  
	xtitle("") ytitle("")   
		xlabel(1(26)169, valuelabel) 
	plotregion(margin(tiny)) 
	cuts(-10(0.5)10) colors(matplotlib, coolwarm) 	
	ramp(labels(-10 -5 0 "0/n.s."  5 "+5" 10 "+10", labsize(tiny) noticks ) xscale(noline) bottom length(15) subtitle("") space(4)   )
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(tiny) angle(45) nogrid tlength(1) ) 
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126)lcolor(gs0) lwidth(vthin))	addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
	name(grc3, replace) fast;
 # delimit cr	
   
   
   
    graph combine grc3  grc2     , cols(2) xsize(17cm) ysize(20cm)  iscale(.9) imargin(vsmall) graphregion(color(white) margin(zero)) 

  *graph combine  grc1 grc2 grc3 , cols(3) xsize(20cm) ysize(13cm)  iscale(0.8) imargin(small)
 						graph export "./TeX/Figures/Fig4x.pdf", replace

   
order   age category topictitle wdate coef  ci_lower ci_upper N  
   keep  age category topictitle wdate coef  ci_lower ci_upper N 
gen agegroup = "Age < 20" if age == "young" 
replace agegroup = "Age > 19 " if age == "old"
drop age 
sort agegroup category topictitle wdate coef 

export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig S3")  sheetreplace

   