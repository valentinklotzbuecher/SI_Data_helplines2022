
import delimited using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2019.csv", clear delimiter(";")
gen ddate = date(date_insert, "DMY")
format ddate %td


save "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2019.dta", replace



import delimited using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_03-12-2021.csv", clear delimiter(";")
gen ddate = date(date_insert, "YMD")
format ddate %td

save "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021b.dta", replace

import delimited using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_19.02.21-28.02.21.csv", clear delimiter(";")
gen ddate = date(date_insert, "DMY")
format ddate %td

save "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021c.dta", replace

import delimited using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_01.01.22-31.03.22.csv", clear delimiter(";")
gen ddate = date(date_insert, "DMY")
format ddate %td

save "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2022.dta", replace


import delimited using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_01.04-31.05.2022.csv", clear delimiter(";")

gen ddate = date(date_insert, "DMY")
format ddate %td

save "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2022b.dta", replace


import delimited using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_01.10.20 - 18.02.2021.csv", clear delimiter(";")

gen ddate = date(date_insert, "DMY")
format ddate %td

save "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021.dta", replace

import delimited using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_01-09-2020.csv", clear delimiter(";")
gen ddate = date(date_insert, "DMY")
format ddate %td

append using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2019.dta"
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021.dta"
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021b.dta"
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021c.dta"
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2022.dta"
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2022b.dta"

erase "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2019.dta"
erase "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021.dta"
erase "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021b.dta"
erase "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2021c.dta"
erase "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2022.dta"
erase "$rawdata\Countries\Germany\Nummer gegen Kummer\ET_Beratungen_2022b.dta"



gen population = 83.02 	// million (2019)
gen country = "Germany"
gen helplinename = "Nummer gegen Kummer (Eltern)"



gen duration = time_dauer
gen hour = time_begin

gen female = 0 if ang_geschlecht != 3
replace female = 1 if ang_geschlecht == 2
gen male = 0 if ang_geschlecht != 3
replace male = 1 if ang_geschlecht == 1


gen firstcall = 0 if ang_anruftyp != 4
replace firstcall = 1 if ang_anruftyp == 1

gen repcall = 0 if ang_anruftyp != 4
replace repcall = 1 if ang_anruftyp == 2 | ang_anruftyp == 3

gen habitcall = 0 if ang_anruftyp != 4
replace habitcall = 1 if ang_anruftyp == 3


gen agegroup = ""
gen agemax = .
gen agemin = .

replace agegroup  = "unter 15" if ang_anruf_alter == 1
replace agegroup  = "15-19" if ang_anruf_alter == 2
replace agegroup  = "20-24" if ang_anruf_alter == 3
replace agegroup  = "25-29" if ang_anruf_alter == 4 
replace agegroup  = "30-34" if ang_anruf_alter == 5
replace agegroup  = "35-39" if ang_anruf_alter == 6
replace agegroup  = "40-44" if ang_anruf_alter == 7
replace agegroup  = "45-49" if ang_anruf_alter == 8
replace agegroup  = "50-54" if ang_anruf_alter == 9
replace agegroup  = "55-59" if ang_anruf_alter == 10
replace agegroup  = "60-64" if ang_anruf_alter == 11
replace agegroup  = "65-69" if ang_anruf_alter == 12
replace agegroup  = "70-74" if ang_anruf_alter == 13
replace agegroup  = "über 75" if ang_anruf_alter == 14

replace agemin  = 0 if ang_anruf_alter == 1
replace agemin  = 15 if ang_anruf_alter == 2
replace agemin  = 20 if ang_anruf_alter == 3
replace agemin  = 25 if ang_anruf_alter == 4 
replace agemin  = 30 if ang_anruf_alter == 5
replace agemin  = 35 if ang_anruf_alter == 6
replace agemin  = 40 if ang_anruf_alter == 7
replace agemin  = 45 if ang_anruf_alter == 8
replace agemin  = 50 if ang_anruf_alter == 9
replace agemin  = 55 if ang_anruf_alter == 10
replace agemin  = 60 if ang_anruf_alter == 11
replace agemin  = 65 if ang_anruf_alter == 12
replace agemin  = 70 if ang_anruf_alter == 13
replace agemin  = 75 if ang_anruf_alter == 14

replace agemax  = 14  if ang_anruf_alter == 1
replace agemax  = 19  if ang_anruf_alter == 2
replace agemax  = 24  if ang_anruf_alter == 3
replace agemax  = 29  if ang_anruf_alter == 4 
replace agemax  = 34  if ang_anruf_alter == 5
replace agemax  = 39  if ang_anruf_alter == 6
replace agemax  = 44  if ang_anruf_alter == 7
replace agemax  = 49  if ang_anruf_alter == 8
replace agemax  = 54  if ang_anruf_alter == 9
replace agemax  = 59  if ang_anruf_alter == 10
replace agemax  = 64  if ang_anruf_alter == 11
replace agemax  = 69  if ang_anruf_alter == 12
replace agemax  = 74  if ang_anruf_alter == 13
replace agemax  = 100  if ang_anruf_alter == 14

egen age = rowmean(agemax agemin)
 
 
gen migrant = . if ang_nationalitaet == 3
replace migrant = 1 if ang_nationalitaet == 1
replace migrant = 0 if ang_nationalitaet == 2

gen statecode = bundes_land_id
gen centercode = location_id

gen state = ""
replace state = "Baden-Württemberg" if statecode == 1
replace state = "Bayern" if statecode == 2
replace state = "Berlin" if statecode == 3
replace state = "Bremen" if statecode == 4
replace state = "Hamburg" if statecode == 5
replace state = "Hessen" if statecode == 6
replace state = "Mecklenburg-Vorpommern" if statecode == 7
replace state = "Niedersachsen" if statecode == 8
replace state = "Nordrhein-Westfalen" if statecode == 9
replace state = "Rheinland-Pfalz" if statecode == 10
replace state = "Sachsen" if statecode == 12
replace state = "Sachsen-Anhalt" if statecode == 13
replace state = "Schleswig-Holstein" if statecode == 14
replace state = "Saarland" if statecode == 15
replace state = "Brandenburg" if statecode == 16

 
tab ang_soz_fam_stand

gen marstat   = "Single" if ang_soz_fam_stand == 1
replace marstat = "Married/partner" if ang_soz_fam_stand == 2
replace marstat = "Separated" if ang_soz_fam_stand == 3
replace marstat = "Divorced" if ang_soz_fam_stand == 4
replace marstat = "Widowed" if ang_soz_fam_stand == 5
replace marstat = "Unknown" if ang_soz_fam_stand == 6

tab ang_soz_finanzen
gen finstat   = "Secure" if ang_soz_finanzen == 1
replace finstat = "Problematic" if ang_soz_finanzen == 2
replace finstat = "Unknown" if ang_soz_finanzen == 3

tab ang_kinder_leben_anruf
gen livingwchild   = "Children living w. caller" if ang_kinder_leben_anruf == 1
replace livingwchild = "Children not living w. caller" if ang_kinder_leben_anruf == 2
replace livingwchild = "Unknown" if ang_kinder_leben_anruf == 3

gen nchildren = string(ang_kinder_anzahl)
replace nchildren = "More than 6" if ang_kinder_anzahl == 2
replace nchildren = "Unknown" if ang_kinder_anzahl == 3


gen child_age0_14      = 0
replace child_age0_14 = 1 if ang_kinder_m_alter_1 == 1
replace child_age0_14  = 1 if ang_kinder_m_alter_2 == 1
replace child_age0_14  = 1 if ang_kinder_m_alter_3 == 1
replace child_age0_14  = 1 if ang_kinder_m_alter_4 ==1 
replace child_age0_14  = 1 if ang_kinder_m_alter_5 == 1
replace child_age0_14  = 1 if ang_kinder_w_alter_1 == 1
replace child_age0_14  = 1 if ang_kinder_w_alter_2 == 1
replace child_age0_14  = 1 if ang_kinder_w_alter_3 == 1
replace child_age0_14  = 1 if ang_kinder_w_alter_4 ==1 
replace child_age0_14  = 1 if ang_kinder_w_alter_5 == 1
replace child_age0_14  = . if ang_kinder_w_alter_9 == 1  
replace child_age0_14  = . if ang_kinder_m_alter_9 == 1  
gen child_age15_older      = 0
replace child_age15_older = 1 if ang_kinder_m_alter_6 == 1
replace child_age15_older  = 1 if ang_kinder_m_alter_7 == 1
replace child_age15_older  = 1 if ang_kinder_m_alter_8 == 1 
replace child_age15_older  = 1 if ang_kinder_w_alter_6 == 1
replace child_age15_older  = 1 if ang_kinder_w_alter_7 == 1
replace child_age15_older  = 1 if ang_kinder_w_alter_8 == 1  
replace child_age15_older  = . if ang_kinder_w_alter_9 == 1  
replace child_age15_older  = . if ang_kinder_m_alter_9 == 1  

tab ang_kinder_anzahl 
tab ang_kinder_maenlich
gen child_male = 0 if ang_kinder_maenlich ==0
replace child_male = 1 if  inrange(ang_kinder_maenlich,1,7)
gen child_female = 0 if ang_kinder_weiblich ==0
replace child_female = 1 if  inrange(ang_kinder_weiblich,1,7)

gen relation2child = ang_soz_bezug_kind
lab def reltions 1 "Parents" 2 "Foster parents" 3 "Partners of parent" 4 "Grandparents" 5 "Other relatives" 6 "Friends" 7 "Neighbors" 8 "Teachers" 9 "Other"
lab val relation2child reltions
* tab relation2child if year == 2020	// checked with official 2020 ET statistics


egen a_e_prob_sum = rowtotal(a_e_prob_*)
sum a_e_prob_* if year == 2020 & a_e_prob_sum>0		// checked with fig.5.2.1 in ET stats


lab var a_e_prob_1 "Eltern-Kind-Bezieh"
lab var a_e_prob_2 "Überforderung/Hilflosigkeit" 
lab var a_e_prob_3 "ausgebrannt" 
lab var a_e_prob_4  "Selbstvertrauen/Unsicherheit" 
lab var a_e_prob_5 "soz. Isolation/Einsamkeit" 
lab var a_e_prob_6 "körperl. Probleme" 
lab var a_e_prob_7 "psych. Probleme" 
lab var a_e_prob_8 "Suchtprobleme" 
lab var a_e_prob_9  "fehlende Unterstütung Partner/in" 
lab var a_e_prob_10 "Trennung/Scheidung" 
lab var a_e_prob_11 "häusliche Gewalt" 
lab var a_e_prob_12 "Armutsproblematik" 
lab var a_e_prob_13 "Arbeitslosigkeit" 
lab var a_e_prob_14  "Betreuung Kinder" 
lab var a_e_prob_15 "Fremdunterbr. der Kinder" 
lab var a_e_prob_16 "Verlust Angehörige" 
lab var a_e_prob_17 "Schwangerschaft" 
lab var a_e_prob_18 "Probleme Haushalt" 
lab var a_e_prob_19 "Sonstige eigene P."
                 

* Topcs based on problems of caller!
gen violence = (a_e_prob_11 == 1)
tab violence if year == 2020 & a_e_prob_sum>0		// checked with fig.5.2.1 in ET stats

gen lonely = (a_e_prob_5 == 1)
tab lonely if year == 2020 & a_e_prob_sum>0		

gen physhealth = (a_e_prob_6 == 1)
tab physhealth if year == 2020 & a_e_prob_sum>0	

gen addiction = (a_e_prob_8 == 1)
tab addiction if year == 2020 & a_e_prob_sum>0	

gen T_econ = (a_e_prob_12  == 1 | a_e_prob_13 == 1)
tab T_econ if year == 2020 & a_e_prob_sum>0		

gen T_social = (a_e_prob_1  == 1 | a_e_prob_9  == 1 | a_e_prob_10  == 1 | a_e_prob_14 == 1 |  a_e_prob_15 == 1)
tab T_social if year == 2020 & a_e_prob_sum>0	


egen b_prob_sum = rowtotal(b_prob_*)
sum b_prob_* if year == 2020 & b_prob_sum>0		// checked with fig.5.2.5 in ET stats

lab var b_prob_1 "Selbstvertrau./Ängstlichkeit"
lab var b_prob_2  "Lügen"
lab var b_prob_3  "Hygiene/Sauberkeit"
lab var b_prob_4  "ADS/Konzentrationsschw."
lab var b_prob_5  "Schlafstörung"
lab var b_prob_7   "psych. Probleme"
lab var b_prob_8  "Drogen(-sucht)"
lab var b_prob_9  "Essstörung"
lab var b_prob_10 "Selbstverletzung"
lab var b_prob_11  "Krankheit, Behinderung"
lab var b_prob_20  "Sonstige Gesundheit"

gen child_addiction = (b_prob_8 == 1)
tab child_addiction if year == 2020 & b_prob_sum>0	// checked with fig.5.2.5 in ET stats



egen b_gewalt_sum = rowtotal(b_gewalt_*)
sum b_gewalt_* if year == 2020 & b_gewalt_sum>0		// checked with fig.5.2.7 in ET stats

lab var  b_gewalt_1  "Aggressionen"
lab var  b_gewalt_2  "Wut (-anfälle)"
lab var  b_gewalt_3  "phys. Gewalt"
lab var  b_gewalt_4  "psych.  Gewalt"
lab var  b_gewalt_5  "häusliche Gewalt"
lab var  b_gewalt_6  "Vernachlässigt"
lab var  b_gewalt_8  "Baby schütteln"
lab var  b_gewalt_9  "Suizidgedank./-versuch"
lab var  b_gewalt_10 "sexuelle Übergriffe"
lab var  b_gewalt_11 "sexueller Missbrauch"
lab var  b_gewalt_20 "Sonstige Gewalt"

gen child_violence = (b_prob_3 == 1 | b_prob_4== 1 | b_prob_5 == 1 | b_prob_8 == 1 | b_prob_10 == 1 | b_prob_11 == 1 | b_prob_20 == 1 )

gen child_suicide = (b_prob_9 == 1)


replace addiction = 1 if child_addiction == 1

gen suicide = child_suicide

replace violence = 1 if child_violence == 1





gen coronacall = 0  if ddate > mdy(3,1,2020)
replace coronacall = 1 if zb_3_yes ==1
 
tab coronacall if year == 2020





*keep population-suicide

  gen agecode = 1 if agemin < 15
  replace agecode = 2 if agemin <20
  replace agecode = 3 if agemin >19
  
gen weekday = dow(ddate)
gen week =  week(ddate)

gen mdate = mofd(ddate)
format mdate %tm
gen wdate = wofd(ddate)
format wdate %tw

rename a_e_prob_1   e_childparrel                       // "Eltern-Kind-Bezieh"                
rename a_e_prob_2   e_overload                       // "Überforderung/Hilflosigkeit" 
rename a_e_prob_3   e_burntout                       // "ausgebrannt" 
rename a_e_prob_4   e_insecure                       //  "Selbstvertrauen/Unsicherheit" 
rename a_e_prob_5   e_lonely                       // "soz. Isolation/Einsamkeit" 
rename a_e_prob_6   e_physical                       // "körperl. Probleme" 
rename a_e_prob_7   e_psycholog                       // "psych. Probleme" 
rename a_e_prob_8   e_addiction                       // "Suchtprobleme" 
rename a_e_prob_9   e_supppartner                       //  "fehlende Unterstütung Partner/in" 
rename a_e_prob_10  e_sepdivorce                     //  "Trennung/Scheidung" 
rename a_e_prob_11  e_domvial                      //  "häusliche Gewalt" 
rename a_e_prob_12  e_poverty                      //  "Armutsproblematik" 
rename a_e_prob_13  e_unempl                     //  "Arbeitslosigkeit" 
rename a_e_prob_14  e_childcare                      //   "Betreuung Kinder" 
rename a_e_prob_15  e_childfoster                      //  "Fremdunterbr. der Kinder" 
rename a_e_prob_16  e_lossrelats                      //  "Verlust Angehörige" 
rename a_e_prob_17  e_pregnancy                      //  "Schwangerschaft" 
rename a_e_prob_18  e_household                      //  "Probleme Haushalt" 
rename a_e_prob_19  e_otherown                      //  "Sonstige eigene P."


rename b_prob_1  c_confianxi //  Selbstvertrau./Ängstlichkeit"
rename b_prob_2  c_lies //  "Lügen"
rename b_prob_3  c_hygiene //  "Hygiene/Sauberkeit"
rename b_prob_4  c_adsconcentr //  "ADS/Konzentrationsschw."
rename b_prob_5  c_sleepdisord //  "Schlafstörung"
rename b_prob_7  c_psycholog //   "psych. Probleme"
rename b_prob_8  c_drugs //  "Drogen(-sucht)"
rename b_prob_9  c_eatdisord //  "Essstörung"
rename b_prob_10 c_selfharm //  "Selbstverletzung"
rename b_prob_11 c_diseasedisab //   "Krankheit, Behinderung"
rename b_prob_20 c_otherhealth //   "Sonstige Gesundheit"

rename  b_gewalt_1  cviol_aggress  //  "Aggressionen"
rename  b_gewalt_2  cviol_angerattack  //  "Wut (-anfälle)"
rename  b_gewalt_3  cviol_phys  //  "phys. Gewalt"
rename  b_gewalt_4  cviol_psych  //  "psych.  Gewalt"
rename  b_gewalt_5  cviol_domestic  //  "häusliche Gewalt"
rename  b_gewalt_6  cviol_neglect  //  "Vernachlässigt"
rename  b_gewalt_8  cviol_babyshake  //  "Baby schütteln"
rename  b_gewalt_9  cviol_suicide  //  "Suizidgedank./-versuch"
rename  b_gewalt_10 cviol_sexharrass  //  "sexuelle Übergriffe"
rename  b_gewalt_11 cviol_sexabuse  //  "sexueller Missbrauch"
rename  b_gewalt_20 cviol_other  //  "Sonstige Gewalt"
 
 gen habitcaller = 1-firstcall
 replace habitcaller = 0 if habitcaller == .
 

egen esum = rowtotal(e_childparrel e_overload e_burntout e_insecure e_lonely e_physical e_psycholog e_addiction e_supppartner e_sepdivorce e_domvial e_poverty e_unempl e_childcare e_childfoster e_lossrelats e_pregnancy e_household e_otherown)
replace e_otherown = 1 if esum ==0 &a_e_prob_sum>0
drop esum
egen esum = rowtotal(e_childparrel e_overload e_burntout e_insecure e_lonely e_physical e_psycholog e_addiction e_supppartner e_sepdivorce e_domvial e_poverty e_unempl e_childcare e_childfoster e_lossrelats e_pregnancy e_household e_otherown)
egen csum = rowtotal(c_confianxi c_lies c_hygiene c_adsconcentr c_sleepdisord c_psycholog c_drugs c_eatdisord c_selfharm c_diseasedisab c_otherhealth)

egen cvsum = rowtotal(cviol_aggress cviol_angerattack cviol_phys cviol_psych cviol_domestic cviol_neglect cviol_babyshake cviol_suicide cviol_sexharrass cviol_sexabuse cviol_other)

gen e_any = (esum>0&esum!=.)
gen c_any = (cvsum>0| csum>0)
/*
foreach V of varlist e_childparrel e_overload e_burntout e_insecure e_lonely e_physical e_psycholog e_addiction e_supppartner e_sepdivorce e_domvial e_poverty e_unempl e_childcare e_childfoster e_lossrelats e_pregnancy e_household e_otherown{
	replace `V' = . if esum == 0 & c_any == 0
}

foreach V of varlist c_confianxi c_lies c_hygiene c_adsconcentr c_sleepdisord c_psycholog c_drugs c_eatdisord c_selfharm c_diseasedisab c_otherhealth cviol_aggress cviol_angerattack cviol_phys cviol_psych cviol_domestic cviol_neglect cviol_babyshake cviol_suicide cviol_sexharrass cviol_sexabuse cviol_other {
	replace `V' = . if esum == 0 & c_any == 0
}*/
tab b_prob_sum csum
tab a_e_prob_sum esum

gen agestated = (ang_alter_angegeben==2)

order ddate month year location_id user_id user_m_w population country helplinename duration hour female male firstcall repcall habitcall agegroup agemax agemin age migrant statecode state child_age0_14 child_age15_older child_male child_female marstat finstat livingwchild nchildren relation2child  coronacall agecode weekday week mdate wdate   esum csum cvsum e_any c_any
sort ddate

gen single = (marstat == "Single")
gen finprobs =0 if finstat != "Unknown"
replace finprobs = 1 if finstat == "Problematic"
 

gen parent = (relation2child == 1)
*livingwchild nchildren
tab livingwchild, gen(lwchild) 
tab marstat, gen(mstat) 
tab finstat, gen(fstat) 
tab nchildren, gen(nchilds)
tab agemin, gen(amin)
tab ang_nationalitaet, gen(natstat)
tab ang_anruftyp, gen(calltype)


drop ang_anruftyp ang_geschlecht ang_anruf_alter ang_alter_angegeben ang_nationalitaet ang_soz_bezug_kind ang_kinder_leben_anruf ang_soz_fam_stand ang_soz_finanzen ang_kinder_anzahl ang_kinder_maenlich ang_kinder_m_alter_1 ang_kinder_m_alter_2 ang_kinder_m_alter_3 ang_kinder_m_alter_4 ang_kinder_m_alter_5 ang_kinder_m_alter_6 ang_kinder_m_alter_7 ang_kinder_m_alter_8 ang_kinder_m_alter_9 ang_kinder_weiblich ang_kinder_w_alter_1 ang_kinder_w_alter_2 ang_kinder_w_alter_3 ang_kinder_w_alter_4 ang_kinder_w_alter_5 ang_kinder_w_alter_6 ang_kinder_w_alter_7 ang_kinder_w_alter_8 ang_kinder_w_alter_9 a_e_prob_20 a_prob_pbg_1 a_prob_pbg_2 a_prob_pbg_3 a_prob_pbg_4 a_prob_pbg_5 a_prob_pbg_6 a_prob_pbg_7 a_prob_pbg_8 a_prob_pbg_9 a_prob_pbg_10 a_prob_pbg_11 a_prob_pbg_12 a_prob_pbg_13 a_prob_pbg_14 a_prob_pbg_15 a_prob_pbg_16 a_prob_pbg_17 a_prob_pbg_18 a_prob_pbg_19 a_prob_pbg_20 a_inf_ausk_20 b_prob_12 b_prob_13 b_prob_14 b_soz_t_1 b_soz_t_2 b_soz_t_3 b_soz_t_4 b_soz_t_5 b_soz_t_6 b_soz_t_7 b_soz_t_8 b_soz_t_9 b_soz_t_10 b_soz_t_11 b_soz_t_12 b_soz_t_13 b_soz_t_14  zb_3_6 zb_3_7 zb_3_8 zb_3_9 zb_3_10 zb_3_11 zb_3_12 zb_3_13 zb_3_14 zb_3_15 zb_3_16 zb_3_17 zb_3_18 zb_3_19 zb_3_20 b_prob_15 b_prob_16 b_prob_17 b_prob_18 b_prob_19 b_soz_t_15 b_soz_t_16 b_soz_t_17 b_soz_t_18 b_soz_t_19 b_soz_t_20 b_gewalt_15 b_gewalt_16 b_gewalt_17 b_gewalt_18 b_gewalt_19 b_kiga_schule_beruf_15 b_kiga_schule_beruf_16 b_kiga_schule_beruf_17 b_kiga_schule_beruf_18 b_kiga_schule_beruf_19 b_kiga_schule_beruf_20 b_sonst_prob_15 b_sonst_prob_16 b_sonst_prob_17 b_sonst_prob_18 b_sonst_prob_19 b_sonst_prob_20 zb_1_yes zb_2_yes zb_3_yes b_prob_6 b_gewalt_7 b_gewalt_12 b_gewalt_13 b_gewalt_14 b_kiga_schule_beruf_1 b_kiga_schule_beruf_2 b_kiga_schule_beruf_3 b_kiga_schule_beruf_4 b_kiga_schule_beruf_5 b_kiga_schule_beruf_6 b_kiga_schule_beruf_7 b_kiga_schule_beruf_8 b_kiga_schule_beruf_9 b_kiga_schule_beruf_10 b_kiga_schule_beruf_11 b_kiga_schule_beruf_12 b_kiga_schule_beruf_13 b_kiga_schule_beruf_14 b_sonst_prob_1 b_sonst_prob_2 b_sonst_prob_3 b_sonst_prob_4 b_sonst_prob_5 b_sonst_prob_6 b_sonst_prob_7 b_sonst_prob_8 b_sonst_prob_9 b_sonst_prob_10 b_sonst_prob_11 b_sonst_prob_12 b_sonst_prob_13 b_sonst_prob_14 zb_1_1 zb_1_2 zb_1_3 zb_1_4 zb_1_5 zb_1_6 zb_1_7 zb_1_8 zb_1_9 zb_1_10 zb_1_11 zb_1_12 zb_1_13 zb_1_14 zb_1_15 zb_1_16 zb_1_17 zb_1_18 zb_1_19 zb_1_20 zb_2_1 zb_2_2 zb_2_3 zb_2_4 zb_2_5 zb_2_6 zb_2_7 zb_2_8 zb_2_9 zb_2_10 zb_2_11 zb_2_12 zb_2_13 zb_2_14 zb_2_15 zb_2_16 zb_2_17 zb_2_18 zb_2_19 zb_2_20 zb_3_1 zb_3_2 zb_3_3 zb_3_4 zb_3_5  eah_19 eah_20 eah_21 eah_22 eah_23 eah_24 eah_25 eah_26 eah_27 eah_28 eah_29 eah_30 anr_aufmerk_yes anr_aufmerk_1 anr_aufmerk_2 anr_aufmerk_3 anr_aufmerk_4 anr_aufmerk_5 anr_aufmerk_6 anr_aufmerk_7 anr_aufmerk_8 anr_aufmerk_9 anr_aufmerk_10 anr_aufmerk_11 anr_aufmerk_12 anr_aufmerk_13 anr_aufmerk_14 anr_aufmerk_15  a_allg_erz_1 a_allg_erz_2 a_allg_erz_3 a_allg_erz_4 a_allg_erz_5 a_allg_erz_6 a_allg_erz_7 a_allg_erz_8 a_allg_erz_9 a_allg_erz_10 a_allg_erz_11 a_allg_erz_12 a_allg_erz_13 a_allg_erz_14 a_allg_erz_15 a_allg_erz_16 a_allg_erz_17 a_allg_erz_18 a_allg_erz_19 a_allg_erz_20 a_inf_ausk_1 a_inf_ausk_2 a_inf_ausk_3 a_inf_ausk_4 a_inf_ausk_5 a_inf_ausk_6 a_inf_ausk_7 a_inf_ausk_8 a_inf_ausk_9 a_inf_ausk_10 a_inf_ausk_11 a_inf_ausk_12 a_inf_ausk_13 a_inf_ausk_14 a_inf_ausk_15 a_inf_ausk_16 a_inf_ausk_17 a_inf_ausk_18 a_inf_ausk_19 einsch_des_gesp empf_anderer_hilfen eah_1 eah_2 eah_3 eah_4 eah_5 eah_6 eah_7 eah_8 eah_9 eah_10 eah_11 eah_12 eah_13 eah_14 eah_15 eah_16 eah_17 eah_18 form_offen gruppeneingabe gespr_ende gespr_ende_opt empf_fam_sprech
 
drop bundes_land_id time_insert date_insert wday time_dauer time_begin anruf_bereich habitcaller centercode a_e_prob_sum b_prob_sum b_gewalt_sum 
drop country_id disabled violence lonely physhealth addiction T_econ T_social child_addiction child_violence child_suicide suicide id
save "$rawdata\Countries\Germany\Nummer gegen Kummer\ET.dta", replace


 


  
  
  
  
  