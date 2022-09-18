

use  "$rawdata\Countries\Germany\Nummer gegen Kummer\OB.dta", clear
  replace age = 7 if agegroup =="<8"
  replace age = 26 if agegroup ==">25" 

gen  ageclass = "0-14" if age <15
replace  ageclass = "15-19" if age <20 & age >14
replace  ageclass = "20+" if age >19 & age !=.

gen helplinename = "Nummer gegen Kummer - Online Beratung"

drop if year(ddate)<2019

save "$rawdata\Countries\Germany\Nummer gegen Kummer\OB_ready.dta", replace


use "$rawdata\Countries\Germany\Nummer gegen Kummer\KJT_beratungen.dta", clear
 

gen agex = subinstr(agegroup," (estimated)","",.)  
  replace age = 7 if agex =="<8"
  replace age = 26 if agex ==">25" 
gen  ageclass = "0-14" if age <15
replace  ageclass = "15-19" if age <20 & age >14
replace  ageclass = "20+" if age >19 & age !=.


 
gen x_warcall =warcall  
 gen x_coronacall = coronacall
replace x_coronacall = 0 if  ddate<mdy(4,1,2020) 
replace x_warcall = 0 if  ddate<mdy(3,1,2022) 
   tab x_warcall x_coronacall
    
save "$rawdata\Countries\Germany\Nummer gegen Kummer\KJT_ready.dta", replace
  
  
  
  
use "$rawdata\Countries\Germany\GERcontactsFULL.dta", clear

 tab agegroup
gen ageclass = "0_14" if agemin<15
replace ageclass = "15_19" if  agemin>14 & agemin<20
replace ageclass = "20+" if agemin>19 & agemin !=.
replace ageclass = subinstr(ageclass,"_","-",.)


gen x_warcall = 0  
replace x_warcall = 1 if coronacall == 1 & ddate>mdy(2,23,2022) & hour >15
gen x_coronacall = coronacall
replace x_coronacall = 0 if  ddate<mdy(3,10,2020) 
replace x_coronacall = 0 if coronacall == 1 & ddate>mdy(2,23,2022) & hour >15
   tab x_warcall x_coronacall
   
   
/*
drop if agegroup == ""
keep if topicsum >0  
drop if othergender
drop if female == .
*/
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\KJT_ready.dta"
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\OB_ready.dta"
encode ageclass, gen(agecode)
tab agecode 

tab age
tab agex
drop agex
 
   
drop regioncode BW-TH centercode statecode month year weekday week mdate wdate dtime age_0_9 age_10_14 age_15_19 age_20_29 age_30_39 age_40_49 age_50_59 age_60_69 age_70_79 age_80plus agemin agemax  topicsum   
 
gen month = month(ddate)
gen year = year(ddate)
gen weekday = dow(ddate)
gen week =  week(ddate)

gen mdate = mofd(ddate)
format mdate %tm
gen wdate = wofd(ddate)
format wdate %tw

encode helplinename, gen(hcode)
encode Bundesland, gen(statecode)
encode center, gen(centercode)


drop helplinename Bundesland center
 
tab hcode 

replace agestated = 1 if hcode != 3
replace agestated = 0 if hcode != 3 & substr(agegroup,-11,11) =="(estimated)"


gen x_lonely = lonely
replace x_lonely = t_psysoc_lonely  if hcode != 3



gen x_fear = fears
replace x_fear =  0 if hcode != 3
foreach S of varlist t_psysoc_fear t_livsit_fearfut  {
replace x_fear = 1  if `S' ==1
}

* corona_fearinfect corona_fearloss corona_fearfuture war_fearwar war_fearnuclear war_fearfuture war_fearrelsfrnds

gen x_addiction = addiction
replace x_addiction =  t_add_drugs if hcode != 3
replace x_addiction =  1 if t_add_alc==1 &  hcode != 3
replace x_addiction =  1 if t_add_tobac==1 & hcode != 3
replace x_addiction =  1 if t_add_other==1 & hcode != 3

  
gen x_suicide = suicidal_thoughts
replace x_suicide =  0 if hcode != 3
foreach S of varlist suicidal_others  suicidal_plan suicidal_attempt suicself suicother   t_add_suic {
replace x_suicide = 1  if `S' ==1
}

gen x_family = famrel
replace x_family =  0 if hcode != 3
foreach S of varlist parenting ptwith_a_family t_fam_rules t_fam_childpar t_fam_siblgns t_fam_supp t_fam_parconf t_fam_exhousng t_fam_other t_fam_care  t_livsit_runawy {
replace x_family = 1  if `S' ==1
}
*corona_famlyconfl



gen x_grief = grief
replace x_grief = 0  if hcode != 3
foreach S of varlist t_psysoc_grief t_fam_loss t_peer_loss  {
replace x_grief   = 1  if `S' ==1
}


gen x_sex = sex
replace x_sex = 0  if hcode != 3
foreach S of varlist t_sex_info t_sex_contrcptn t_sex_ftime t_sex_orient t_sex_mast t_sex_pract t_sex_risk t_sex_phant t_sex_other {
replace x_sex  = 1  if `S' ==1
}

gen x_school = schooleduc
replace x_school = 0  if hcode != 3
foreach S of varlist t_school_fearfail t_school_grades t_school_teachr t_school_clssmts t_school_mobb t_school_overld t_school_learn t_school_work t_school_skip t_school_swtch t_school_fearfail t_school_other  {
replace x_school  = 1  if `S' ==1
}
*corona_school

gen x_economic = fininher
replace x_economic = 0  if hcode != 3
foreach S of varlist unempl worksit poverty t_fam_povrty  housing t_livsit_envir t_livsit_opport t_livsit_other {
replace x_economic  = 1  if `S' ==1
}

gen x_pregnancy = pregnancy 
replace x_pregnancy = 0  if hcode != 3
foreach S of varlist t_sex_preg t_sex_abort {
replace x_pregnancy  = 1  if `S' ==1
}

gen x_culture = belief
replace x_culture  = 0  if hcode != 3
foreach S of varlist church migration soccult t_livsit_radicl t_livsit_relig t_livsit_racism t_livsit_asylm  {
replace  x_culture  = 1  if `S' ==1
}

gen x_phealth =  physhealth
replace x_phealth  = 0  if hcode != 3
foreach S of varlist caretherap t_fam_care t_add_anorex t_add_obese t_fam_health t_psysoc_body t_psysoc_diesease {
replace x_phealth   = 1  if `S' ==1
}

gen x_parship =   livepartner
replace x_parship  = 0  if hcode != 3
foreach S of varlist t_love_distrel t_love_relconf   {
replace  x_parship  = 1  if `S' ==1
}
gen x_love =  partnersearch
replace x_love  = 0  if hcode != 3
foreach S of varlist    separat t_love_crush t_love_contwish t_love_heart t_love_parship t_love_relconf t_love_jealous t_love_separat t_love_left t_love_distrel t_love_infid t_love_other {
replace  x_love  = 1  if `S' ==1
}


gen x_peers = everydayrel
replace x_peers = 0  if hcode != 3
foreach S of varlist t_peer_frndsearch t_peer_conf t_peer_comp t_peer_loyal t_peer_outsdr t_peer_mobb t_peer_loss t_peer_statsym t_peer_prssre t_peer_dare t_peer_other  {
replace  x_peers = 1  if `S' ==1
}

gen x_mhlight = stressemot
replace x_mhlight = 0  if hcode != 3
foreach S of varlist confused  anger t_psysoc_bored  t_psysoc_conf  {
replace x_mhlight  = 1  if `S' ==1
}

gen x_mhsevere = depressed
replace x_mhsevere = 0  if hcode != 3
foreach S of varlist confshame othermental selfharm t_add_selfharm t_psysoc_psychprob  {
replace x_mhsevere  = 1  if `S' ==1
}
gen x_leisure = virtualrel
replace x_leisure = 0  if hcode != 3
foreach S of varlist  volunt t_livsit_safinet t_psysoc_leisure{
replace x_leisure  = 1  if `S' ==1
}


gen x_other = topic_other
replace x_other = 0  if hcode != 3
foreach S of varlist   pubinstcont  dailyrout t_livsit_law posithank{
replace x_other  = 1  if `S' ==1
}
* TSfeedback_agr TSfeedback_neg TSfeedback_other TSfeedback_pos inform

gen x_violence = physviol
replace x_violence  = 0  if hcode != 3
foreach S of varlist  sexviol violence t_viol_psych t_viol_phys t_viol_sex t_viol_other t_viol {
replace x_violence  = 1  if `S' ==1
}
* corona_domviol 
  
gen x_currenttopic = coronacall

egen tsum = rowtotal(x_*)
br if tsum == 0

 encode agegroup, gen(agecodefull)
 
  gen fullinfo = 1
  replace fullinfo = 0 if female ==.
  replace fullinfo = 0 if agecode ==.  
  replace fullinfo = 0 if tsum ==0  
  tab fullinfo

 order fullinfo ddate phone chat mail female male   agecodefull agecode agestated hcode statecode centercode hour duration  x_* , first 
 keep  ddate phone chat mail female male   agecodefull agecode agestated hcode statecode centercode hour duration  tsum x_* month year weekday week mdate wdate
 sort hcode ddate
 
 gen h1code = 1 if hcode <3
 replace h1code = 2 if hcode == 3
						
						
drop if year(ddate)<2019
drop if ddate > mdy(5,31,2022)						
 
save "$rawdata\Countries\Germany\merged.dta", replace
  
use "$rawdata\Countries\Germany\merged.dta", clear
						









