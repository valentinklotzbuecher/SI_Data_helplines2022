use "$rawdata\Countries\Germany\Nummer gegen Kummer\ET.dta", clear  
  

 fcollapse    (mean)    c_* cviol_*  e_* , by( year)
 
renvars  c_* cviol_*  e_*, prefix(t_)
 reshape long t_   , i(year) j(topic) string
rename t_ mean_ 
  reshape wide mean_*, j(year) i(topic) 

save "$rawdata/Countries/Germany/EToverallshares.dta", replace 




   
   frame reset
   
use "$rawdata\Countries\Germany\Nummer gegen Kummer\ET.dta", clear  
		 
		 
tab child_age0_14 child_age15_older, m cell 
tab child_age0_14 child_age15_older,  cell 

tab child_male child_female 
   
tab wdate, gen(wdx)
        global wdums "wdx53 wdx54 wdx55 wdx56 wdx57 wdx58 wdx59 wdx60 wdx61 wdx62 wdx63 wdx64 wdx65 wdx66 wdx67 wdx68 wdx69 wdx70 wdx71 wdx72 wdx73 wdx74 wdx75 wdx76 wdx77 wdx78 wdx79 wdx80 wdx81 wdx82 wdx83 wdx84 wdx85 wdx86 wdx87 wdx88 wdx89 wdx90 wdx91 wdx92 wdx93 wdx94 wdx95 wdx96 wdx97 wdx98 wdx99 wdx100 wdx101 wdx102 wdx103 wdx104 wdx105 wdx106 wdx107 wdx108 wdx109 wdx110 wdx111 wdx112 wdx113 wdx114 wdx115 wdx116 wdx117 wdx118 wdx119 wdx120 wdx121 wdx122 wdx123 wdx124 wdx125 wdx126 wdx127 wdx128 wdx129 wdx130 wdx131 wdx132 wdx133 wdx134 wdx135 wdx136 wdx137 wdx138 wdx139 wdx140 wdx141 wdx142 wdx143 wdx144 wdx145 wdx146 wdx147 wdx148 wdx149 wdx150 wdx151 wdx152 wdx153 wdx154 wdx155 wdx156 wdx157 wdx158 wdx159 wdx160 wdx161 wdx162 wdx163 wdx164 wdx165 wdx166 wdx167 wdx168 wdx169 wdx170 wdx171 wdx172 wdx173 wdx174 wdx175 wdx176 wdx177 wdx178" 
  
 
  
reghdfe e_burntout  $wdums   , absorb(month) nocons vce(robust) 
frame create eresults
frame eresults: regsave using "$rawdata\cplot_evstudyET.dta", ci level(95) addlabel(depvartitel, e_burntout) detail(all) replace
frame change default


foreach T of varlist   c_* cviol_*  e_childparrel e_overload   e_insecure e_lonely e_physical e_psycholog e_addiction e_supppartner e_sepdivorce e_domvial e_poverty e_unempl e_childcare e_childfoster e_lossrelats e_pregnancy e_household e_otherown   {
 
reghdfe `T'  $wdums   , absorb(month) nocons vce(robust) 
 local titletext: variable label `T'
display "`titletext'"
frame eresults: regsave using "$rawdata\cplot_evstudyET.dta", ci level(95) addlabel(depvartitel, `T') detail(all) append
}
   

   // By child age 
foreach T of varlist   c_* cviol_* e_burntout e_childparrel e_overload   e_insecure e_lonely e_physical e_psycholog e_addiction e_supppartner e_sepdivorce e_domvial e_poverty e_unempl e_childcare e_childfoster e_lossrelats e_pregnancy e_household e_otherown   {
 
reghdfe `T'  $wdums  if child_age0_14==1 , absorb(month) nocons vce(robust)  
frame eresults: regsave using "$rawdata\cplot_evstudyET.dta", ci level(95) addlabel(depvartitel, `T', cage, "0-14" ) detail(all) append
reghdfe `T'  $wdums  if child_age15_older ==1 , absorb(month) nocons vce(robust)  
frame eresults: regsave using "$rawdata\cplot_evstudyET.dta", ci level(95) addlabel(depvartitel, `T', cage, "15+" ) detail(all) append
}
   
   
   
   
   
   
    
   
 
* Plot heatmaps:
						
use "$rawdata\cplot_evstudyET.dta", clear
drop if cage != ""
 drop if depvartitel =="c_any"
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
 merge m:1 topic using "$rawdata/Countries/Germany/EToverallshares.dta", nogen
 drop topic
split depvar, p("_")
rename depvar2  topic
rename depvar1 category
  
gen catorder = 1 if category=="e" 
replace catorder = 2 if category=="c" 
replace catorder = 3 if category=="cviol" 
 
gen topictitle = ""	
 replace  topictitle = "Child-parent relations" if topic == "childparrel"	        // "Eltern-Kind-Bezieh"                
 replace  topictitle = "Overload, helplessness" if topic == "overload"                               // "Überforderung/Hilflosigkeit" 
 replace  topictitle = "Burnout" if topic == "burntout"                               // "ausgebrannt" 
 replace  topictitle = "Insecurity, confidence" if topic == "insecure"                               //  "Selbstvertrauen/Unsicherheit" 
 replace  topictitle = "Loneliness, isolation" if topic == "lonely"                               // "soz. Isolation/Einsamkeit" 
 replace  topictitle = "Physical health" if topic == "physical"                               // "körperl. Probleme" 
 replace  topictitle = " Mental health" if depvar == "c_psycholog"                               // "psych. Probleme" 
 replace  topictitle = "Addiction" if topic == "addiction"                               // "Suchtprobleme" 
 replace  topictitle = "Lack of partner support" if topic == "supppartner"                               //  "fehlende Unterstütung Partner/in" 
 replace  topictitle = "Separation, divorce" if topic == "sepdivorce"                             //  "Trennung/Scheidung" 
 replace  topictitle = "Domestic violence" if topic == "domvial"                              //  "häusliche Gewalt" 
 replace  topictitle = "Poverty" if topic == "poverty"                              //  "Armutsproblematik" 
 replace  topictitle = "Unemployment" if topic == "unempl"                             //  "Arbeitslosigkeit" 
 replace  topictitle = "Child care" if topic == "childcare"                              //   "Betreuung Kinder" 
 replace  topictitle = "Foster care" if topic == "childfoster"                              //  "Fremdunterbr. der Kinder" 
 replace  topictitle = "Loss of relatives" if topic == "lossrelats"                              //  "Verlust Angehörige" 
 replace  topictitle = "Pregnancy" if topic == "pregnancy"                              //  "Schwangerschaft" 
 replace  topictitle = "Household" if topic == "household"                              //  "Probleme Haushalt" 
 replace  topictitle = "Other own problems" if topic == "otherown"                              //  "Sonstige eigene P."
 
 replace  topictitle = "Anxiety/confidence" if topic == "confianxi"			   //  Selbstvertrau./Ängstlichkeit"
 replace  topictitle = "Lies" if topic == "lies"                //  "Lügen"
 replace  topictitle = "Hygiene" if topic == "hygiene"            //  "Hygiene/Sauberkeit"
 replace  topictitle = "Attention/Concentration" if topic == "adsconcentr"         //  "ADS/Konzentrationsschw."
 replace  topictitle = "Sleep disorder" if topic == "sleepdisord"         //  "Schlafstörung"
 replace  topictitle = "Parent mental health" if depvar == "e_psycholog"           //   "psych. Probleme"
 replace  topictitle = "Addiction, drugs" if topic == "drugs"              //  "Drogen(-sucht)"
 replace  topictitle = "Eating disorder" if topic == "eatdisord"          //  "Essstörung"
 replace  topictitle = "Self-harming behaviour" if topic == "selfharm"          //  "Selbstverletzung"
 replace  topictitle = "Disease/disability" if topic == "diseasedisab"      //"Krankheit, Behinderung"
 replace  topictitle ="Other health problems" if topic =="otherhealth"        //"Sonstige Gesundheit"
 
 replace  topictitle ="Aggression" if topic =="aggress"     //"Aggressionen"           
 replace  topictitle ="Anger (attacks)" if topic =="angerattack"     //"Wut (-anfälle)"
 replace  topictitle ="Physical violence" if topic =="phys"        //"phys. Gewalt"
 replace  topictitle ="Psychological violence" if topic =="psych"    //"psych.  Gewalt"
 replace  topictitle ="Domestic violence" if topic =="domestic"        //"häusliche Gewalt"
 replace  topictitle ="Neglect" if topic =="neglect"       //"Vernachlässigt"
 replace  topictitle ="Suicidality" if topic =="suicide"     //"Suizidgedank./-versuch"
 replace  topictitle ="Sexual harrassment" if topic =="sexharrass"    //"sexuelle Übergriffe"
 replace  topictitle ="Sexual abuse" if topic =="sexabuse"     //"sexueller Missbrauch"
 replace  topictitle ="Other violence" if topic =="other"    //  "Sonstige Gewalt" 
 replace  topictitle ="Baby violence" if   topic =="babyshake"       //   "Baby schütteln"
    drop if topic =="babyshake"
   
sencode topictitle, gen(tcode) gsort(-catorder mean_2019 )  
  
    

gen ci90_lower = coef-invnormal(0.95)*(stderr)
gen ci95_lower = coef-invnormal(0.975)*(stderr)
gen ci99_lower = coef-invnormal(0.99)*(stderr)

gen ci90_upper = coef+invnormal(0.95)*(stderr)
gen ci95_upper = coef+invnormal(0.975)*(stderr)
gen ci99_upper = coef+invnormal(0.99)*(stderr)
foreach V of varlist coef ci* {
replace `V' = `V' * 100
}
egen xxid = group(depvar)
xtset xxid wdate
 mvsumm coef, gen(MAcoef) stat(mean) window(3) force
 	 
   gen tm = 100*mean_2019   
   gen meang  = round(tm,0.1)  
  format meang %9.1f 
  gen tmecn  =string(meang)  
 gen topictitle_Nage = topictitle + " [" + tmecn + "]" 
 
   
sencode topictitle_Nage, gen(tcodeX) gsort(-catorder  mean_2019) 
	 
tostring N , gen(N_string) format(%12.0fc) force
 
 local N= N_string[1]
display "`N'"
 gen  scoef = coef
replace scoef = 0 if ci_lower < 0 & ci_upper >0

  
 gen xval = wdate-3131
 gen one = 0.5
  gen twen =19.5  
  gen twen2 = 21.5
   
   
  
  
  
 local N= N_string[1]
 global DVAR "scoef"  
 # delimit ;
	heatplot $DVAR  i.tcodeX   i.wdate  if category == "e", 
	graphregion(color(white) margin(small)) 
	ylabel(, labsize(vsmall) nogrid noticks) aspectratio(0.38) 
	title("{bf:B}" , size(vsmall) pos(11) ring(1) justification(left) span) subtitle("Parent problems ({it:n=}`N')", pos(12) ring(1) size(vsmall) margin(top))
	yscale(noline) xtitle("") ytitle("")   xscale(noline)
		xlabel(1(26)169, valuelabel nogrid labsize(small)) 
	plotregion(margin(tiny)) 
	cuts(-10(0.4)10) colors( matplotlib, coolwarm) 
	ramp(labels(-10 -5 0  "0/n.s." 5 "+5"  10 "+10", labsize(vsmall) noticks) yscale(noline) right   length(15) subtitle("") space(6.5) ) 
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid) addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.02) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	 	name(grcET, replace) fast;
 # delimit cr	
 # delimit ;
	heatplot $DVAR  i.tcodeX   i.wdate  if category !="e", 
	graphregion(color(white) margin(small)) 
	ylabel(, labsize(vsmall) nogrid noticks) aspectratio(0.38) 
	title("{bf:A}" , size(vsmall) pos(11) ring(1) justification(left) span) subtitle("Child problems ({it:n=}`N')", pos(12) ring(1) size(vsmall) margin(top))
	yscale(noline) 	  		 
	xtitle("") ytitle("")   xscale(noline)
		xlabel(1(26)169, valuelabel nogrid labsize(small)) 
	plotregion(margin(tiny))
		ramp(labels(-10 -5 0  "0/n.s." 5 "+5"  10 "+10", labsize(vsmall) noticks) yscale(noline) right   length(15) subtitle("") space(6.5) ) 
	cuts(-10(0.4)10) colors( matplotlib, coolwarm)  
xlabel(1 "Jan 2020" 12 "16 Mar" 27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022" 113 "24 Feb", labsize(vsmall)  nogrid) addplot(rbar one twen2  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.02) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	  	name(grcET2, replace) fast;
 # delimit cr	
  
  
  
  graph combine   grcET2  grcET  , cols(1) xsize(18cm) ysize(14cm)  iscale(.9) imargin(tiny) graphregion(margin(zero))   name(grcETc, replace)      
  
  
   						graph export "./TeX/Figures/F4parents.pdf", replace
 graph export "C:\Users\VK\Sync\PhD Freiburg\Dis\Figures/F4parents.pdf", replace

						
	sort category tcode	wdate				
br 	category tcodeX wdate coef ci_lower ci_upper		
replace category = "Child problems" if category != "e"
replace category = "Parent problems" if category == "e"
rename tcodeX tcode
keep category tcode  wdate coef ci_lower ci_upper	
		export excel using ".\Data\FigSourceData.xlsx", firstrow(varlabels) sheet("Fig 3")  sheetreplace
				
						
   
 
* Plot heatmaps:
						
use "$rawdata\cplot_evstudyET.dta", clear
drop if cage == ""
 drop if depvartitel =="c_any"
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
 merge m:1 topic using "$rawdata/Countries/Germany/EToverallshares.dta", nogen
 drop topic
split depvar, p("_")
rename depvar2  topic
rename depvar1 category
  
gen catorder = 1 if category=="e" 
replace catorder = 2 if category=="c" 
replace catorder = 3 if category=="cviol" 
 
gen topictitle = ""	
 replace  topictitle = "Child-parent relations" if topic == "childparrel"	        // "Eltern-Kind-Bezieh"                
 replace  topictitle = "Overload, helplessness" if topic == "overload"                               // "Überforderung/Hilflosigkeit" 
 replace  topictitle = "Burnout" if topic == "burntout"                               // "ausgebrannt" 
 replace  topictitle = "Insecurity, confidence" if topic == "insecure"                               //  "Selbstvertrauen/Unsicherheit" 
 replace  topictitle = "Loneliness, isolation" if topic == "lonely"                               // "soz. Isolation/Einsamkeit" 
 replace  topictitle = "Physical health" if topic == "physical"                               // "körperl. Probleme" 
 replace  topictitle = " Mental health" if depvar == "c_psycholog"                               // "psych. Probleme" 
 replace  topictitle = "Addiction" if topic == "addiction"                               // "Suchtprobleme" 
 replace  topictitle = "Lack of partner support" if topic == "supppartner"                               //  "fehlende Unterstütung Partner/in" 
 replace  topictitle = "Separation, divorce" if topic == "sepdivorce"                             //  "Trennung/Scheidung" 
 replace  topictitle = "Domestic violence" if topic == "domvial"                              //  "häusliche Gewalt" 
 replace  topictitle = "Poverty" if topic == "poverty"                              //  "Armutsproblematik" 
 replace  topictitle = "Unemployment" if topic == "unempl"                             //  "Arbeitslosigkeit" 
 replace  topictitle = "Child care" if topic == "childcare"                              //   "Betreuung Kinder" 
 replace  topictitle = "Foster care" if topic == "childfoster"                              //  "Fremdunterbr. der Kinder" 
 replace  topictitle = "Loss of relatives" if topic == "lossrelats"                              //  "Verlust Angehörige" 
 replace  topictitle = "Pregnancy" if topic == "pregnancy"                              //  "Schwangerschaft" 
 replace  topictitle = "Household" if topic == "household"                              //  "Probleme Haushalt" 
 replace  topictitle = "Other own problems" if topic == "otherown"                              //  "Sonstige eigene P."
 
 replace  topictitle = "Anxiety/confidence" if topic == "confianxi"			   //  Selbstvertrau./Ängstlichkeit"
 replace  topictitle = "Lies" if topic == "lies"                //  "Lügen"
 replace  topictitle = "Hygiene" if topic == "hygiene"            //  "Hygiene/Sauberkeit"
 replace  topictitle = "Attention/Concentration" if topic == "adsconcentr"         //  "ADS/Konzentrationsschw."
 replace  topictitle = "Sleep disorder" if topic == "sleepdisord"         //  "Schlafstörung"
 replace  topictitle = "Parent mental health" if depvar == "e_psycholog"           //   "psych. Probleme"
 replace  topictitle = "Addiction, drugs" if topic == "drugs"              //  "Drogen(-sucht)"
 replace  topictitle = "Eating disorder" if topic == "eatdisord"          //  "Essstörung"
 replace  topictitle = "Self-harming behaviour" if topic == "selfharm"          //  "Selbstverletzung"
 replace  topictitle = "Disease/disability" if topic == "diseasedisab"      //"Krankheit, Behinderung"
 replace  topictitle ="Other health problems" if topic =="otherhealth"        //"Sonstige Gesundheit"
 
 replace  topictitle ="Aggression" if topic =="aggress"     //"Aggressionen"           
 replace  topictitle ="Anger (attacks)" if topic =="angerattack"     //"Wut (-anfälle)"
 replace  topictitle ="Physical violence" if topic =="phys"        //"phys. Gewalt"
 replace  topictitle ="Psychological violence" if topic =="psych"    //"psych.  Gewalt"
 replace  topictitle ="Domestic violence" if topic =="domestic"        //"häusliche Gewalt"
 replace  topictitle ="Neglect" if topic =="neglect"       //"Vernachlässigt"
 replace  topictitle ="Suicidality" if topic =="suicide"     //"Suizidgedank./-versuch"
 replace  topictitle ="Sexual harrassment" if topic =="sexharrass"    //"sexuelle Übergriffe"
 replace  topictitle ="Sexual abuse" if topic =="sexabuse"     //"sexueller Missbrauch"
 replace  topictitle ="Other violence" if topic =="other"    //  "Sonstige Gewalt" 
 replace  topictitle ="Baby violence" if   topic =="babyshake"       //   "Baby schütteln"
* drop if topictitle == "" 
   drop if topic =="babyshake"
   
sencode topictitle, gen(tcode) gsort(-catorder mean_2019 )  
  
   
 * keep if mean_t_2019 > 0.02
*

gen ci90_lower = coef-invnormal(0.95)*(stderr)
gen ci95_lower = coef-invnormal(0.975)*(stderr)
gen ci99_lower = coef-invnormal(0.99)*(stderr)

gen ci90_upper = coef+invnormal(0.95)*(stderr)
gen ci95_upper = coef+invnormal(0.975)*(stderr)
gen ci99_upper = coef+invnormal(0.99)*(stderr)
foreach V of varlist coef ci* {
replace `V' = `V' * 100
}
egen xxid = group(depvar cage)
xtset xxid wdate
 mvsumm coef, gen(MAcoef) stat(mean) window(3) force
 	 
   gen tm = 100*mean_2019   
   gen meang  = round(tm,0.1)  
  format meang %9.1f 
  gen tmecn  =string(meang)  
 gen topictitle_Nage = topictitle + " [" + tmecn + "]" 
 
   
sencode topictitle_Nage, gen(tcodeX) gsort(-catorder  mean_2019) 
	 
tostring N , gen(N_string) format(%12.0fc) force
  
*replace MAcoef = 0 if ci95_lower < 0 & ci95_upper >0
replace coef = 0 if ci95_lower < 0 & ci95_upper >0

 gen xval = wdate-3131
 gen one = 0.5
  gen twen =19.5  
  gen twen2 = 21.5
   
 gen N_1 = N if category != "e" & cage == "15+" 
 gen N_2 = N if category != "e" & cage == "0-14" 
 gen N_3 = N if category == "e" & cage == "15+" 
 gen N_4 = N if category == "e" & cage == "0-14" 
  foreach J in 1 2 3 4 {
  	sort N_`J'
  	carryforward N_`J', replace
	tostring N_`J' , gen(N_string_`J') format(%12.0fc) force
  }  
 
   foreach J in 1 2 3 4 {
 local N_`J'= N_string_`J'[1]
  } 
  global DVAR "coef"  // MA3Tresshare-mean19x
 # delimit ;
	heatplot $DVAR  i.tcodeX   i.wdate  if category != "e" & cage == "15+", 
	graphregion(color(white) margin(small)) 
	ylabel(, labsize(vsmall)  noticks nogrid) aspectratio(0.8) 
	title("{bf:B}" , size(vsmall) pos(11) ring(1) justification(left) span) subtitle("Child problems, child age > 14 ({it:n=}`N_1')", pos(12) ring(1) size(vsmall) margin(top))	yscale(noline) xtitle("") ytitle("")   
		xlabel(1(26)169, valuelabel nogrid labsize(small) noticks) yscale(noline) 
	plotregion(margin(tiny)) addplot(rbar one twen2  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
	cuts(-10(0.5)10) colors( matplotlib, coolwarm) 
	ramp(labels(-10 -5 0   5 "+5"  10 "+10", labsize(vsmall) noticks ) right yscale(noline)  length(18) subtitle("") space(5.5) ) 
xlabel(1 "Jan 2020"   27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022"  , labsize(vsmall)  nogrid)  
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	 	name(grcET, replace) fast;
 # delimit cr	
 # delimit ;
	heatplot $DVAR  i.tcodeX   i.wdate  if category != "e" & cage == "0-14", 
	graphregion(color(white) margin(small)) 
	ylabel(, labsize(vsmall) noticks nogrid) aspectratio(0.8) 
	title("{bf:A}" , size(vsmall) pos(11) ring(1) justification(left) span) subtitle("Child problems, child age<15 ({it:n=}`N_2')", pos(12) ring(1) size(vsmall) margin(top))
	yscale(noline) 	  		 
	xtitle("") ytitle("")   
		xlabel(1(26)169, valuelabel nogrid labsize(small)) 
	plotregion(margin(tiny))
		ramp(labels(-10 -5 0   5 "+5"  10 "+10", labsize(vsmall) noticks) yscale(noline) right   length(18) subtitle("") space(5.5) ) 
	cuts(-10(0.5)10) colors( matplotlib, coolwarm)  
xlabel(1 "Jan 2020"   27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022"  , labsize(vsmall)  nogrid) addplot(rbar one twen2  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	  	name(grcET2, replace) fast;
 # delimit cr	
  
  global DVAR "coef"  // MA3Tresshare-mean19x
 # delimit ;
	heatplot $DVAR  i.tcodeX   i.wdate  if category == "e" & cage == "15+", 
	graphregion(color(white) margin(small)) 
	ylabel(, labsize(vsmall) noticks nogrid) aspectratio(0.8) 
	title("{bf:D}" , size(vsmall) pos(11) ring(1) justification(left) span) subtitle("Parent problems, child age>14 ({it:n=}`N_3')", pos(12) ring(1) size(vsmall) margin(top))
	yscale(noline) xtitle("") ytitle("")   
		xlabel(1(26)169, valuelabel nogrid labsize(small)) 
	plotregion(margin(tiny)) 
	cuts(-10(0.5)10) colors( matplotlib, coolwarm) 
	ramp(labels(-10 -5 0   5 "+5"  10 "+10", labsize(vsmall) noticks) right yscale(noline)  length(18) subtitle("") space(5.5) ) 
xlabel(1 "Jan 2020"   27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022"  , labsize(vsmall)  nogrid) addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))		
 	name(grcET4, replace) fast;
 # delimit cr	
 # delimit ;
	heatplot $DVAR  i.tcodeX   i.wdate  if category == "e" & cage == "0-14", 
	graphregion(color(white) margin(small)) 
	ylabel(, labsize(vsmall) noticks nogrid) aspectratio(0.8) 
	title("{bf:C}" , size(vsmall) pos(11) ring(1) justification(left) span) subtitle("Parent problems, child age<15 ({it:n=}`N_4')", pos(12) ring(1) size(vsmall) margin(top))
	yscale(noline) 	  		 
	xtitle("") ytitle("")  
		xlabel(1(26)169, valuelabel nogrid labsize(small)) 
	plotregion(margin(tiny))
		ramp(labels(-10 -5 0   5 "+5"  10 "+10", labsize(vsmall) noticks) yscale(noline) right   length(18) subtitle("") space(5.5) ) 
	cuts(-10(0.5)10) colors( matplotlib, coolwarm)  
xlabel(1 "Jan 2020"   27 "Jul 2020" 53 "Jan 2021" 80 "Jul 2021" 105 "Jan 2022"  , labsize(vsmall)  nogrid) addplot(rbar one twen  xval if xval ==12 | xval == 113,  color(gs2) fintensity(100) barwidth(.05) lwidth(none) lpattern(solid))
xtick (1 12 27 53 105 113  126,  tlength(.01) ) 
xscale(range(1 126) lcolor(gs0) lwidth(vthin))	  	name(grcET3, replace) fast;
 # delimit cr	
  

					graph combine   grcET2  grcET grcET3 grcET4 , cols(2) xsize(20cm) ysize(13cm)  iscale(.9) imargin(tiny) graphregion(margin(zero))   
	   						graph export "./TeX/Figures/F4parents_cage.pdf", replace

							