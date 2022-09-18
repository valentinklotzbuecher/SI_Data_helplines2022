
// Mail 2019
usespss "$rawdata\Countries\Germany\Nummer gegen Kummer\OB_mail_beratung_2019.sav", clear
 
split timestampkind, p(" ")
gen ddate = date(timestampkind1, "DMY") 
format ddate %td
gen hour = substr(timestampkind,-5,2)


gen agegroup = string(alter)
replace agegroup  = "<8" if alter<8
replace agegroup  = ">25" if alter>25 & alter != 0
replace agegroup = "" if agegroup == "0"

gen age = alter 
replace age = . if age == 0
replace age = . if age == 111
 
rename  anruftyp kt

gen female = 0 if sex != 3
replace female = 1 if sex == 1		//  !!!!!!!!!!!!!!!!!!
gen male = 0 if sex != 3
replace male = 1 if sex == 0		//  !!!!!!!!!!!!!!!!!!
 
gen migrant = .
replace migrant = 0 if migration != 3
replace migrant = 1 if migration == 1

gen concern_other = 0
replace concern_other = 1 if alterprob !=0

gen concern_female = 0 if sexprob == 1
replace concern_female = 1 if sexprob ==   2
gen concern_male = 0 if sexprob == 2
replace concern_male = 1 if sexprob ==   1 
gen concern_agegroup = string(alterprob) if alterprob != 0
replace concern_agegroup  = "<8" if alterprob == 1
replace concern_agegroup  = ">25" if alterprob == 111
replace concern_agegroup  = concern_agegroup + " (estimated)" if altprobang !=3 & alterprob != 0
gen concern_age = alterprob
replace concern_age = .  if alterprob == 0
replace concern_age = .  if alterprob == 1
replace concern_age   = . if alterprob == 111 
 
gen dialog = dialogmail 
 
drop alter* sexprob insorge sex migration timestamp timestampkind altprobang dialogmail
  
 renvars ETG1X1-ort16text, lower

save  "$rawdata\Countries\Germany\Nummer gegen Kummer\OBmail2019.dta", replace



// Mail 2020
import delimited using  "$rawdata\Countries\Germany\Nummer gegen Kummer\Email 20.csv", clear
save  "$rawdata\Countries\Germany\Nummer gegen Kummer\OBmail2020.dta", replace

// Mail 2021-22
import delimited using  "$rawdata\Countries\Germany\Nummer gegen Kummer\Email  21-Mai22.csv", clear
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\OBmail2020.dta"

split timestampkind, p(" ")
gen ddate = date(timestampkind1, "DMY") 
format ddate %td
drop if ddate == .
gen hour = substr(timestampkind,-5,2)

gen female = 0 if gender <3
replace female = 1 if gender == 1		//  !!!!!!!!!!!!!!!!!!
gen male = 0 if gender <3
replace male = 1 if gender == 2		//  !!!!!!!!!!!!!!!!!!
gen diverse = 0 if gender != 4
replace diverse = 1 if gender == 3
 
 gen dialog = dialogmail -1
drop dialogmail
 
gen agegroup = string(age)
replace agegroup  = "<8" if age<8
replace agegroup  = ">25" if age>25 & age != 0
replace agegroup = "" if age == 0
 
replace age = . if age == 0
replace age = . if age == 111
   
save  "$rawdata\Countries\Germany\Nummer gegen Kummer\OBmail202022.dta", replace

 
 // Chat 2020ff
import delimited using  "$rawdata\Countries\Germany\Nummer gegen Kummer\chat 20.csv", clear
save  "$rawdata\Countries\Germany\Nummer gegen Kummer\OBchat2020.dta", replace

import delimited using  "$rawdata\Countries\Germany\Nummer gegen Kummer\chat 21-Mai22.csv", clear
 append using "$rawdata\Countries\Germany\Nummer gegen Kummer\OBchat2020.dta"

 
split timestampkind, p(" ")
gen ddate = date(timestampkind1, "DMY") 
format ddate %td
drop if ddate == .
gen hour = substr(timestampkind,-5,2)

gen female = 0 if gender <3
replace female = 1 if gender == 1		//  !!!!!!!!!!!!!!!!!!
gen male = 0 if gender <3
replace male = 1 if gender == 2		//  !!!!!!!!!!!!!!!!!!
gen diverse = 0 if gender != 4
replace diverse = 1 if gender == 3
  
 
gen agegroup = string(age)
replace agegroup  = "<8" if age<8
replace agegroup  = ">25" if age>25 & age != 0
replace agegroup = "" if age == 0
 
replace age = . if age == 0
replace age = . if age == 111
   
save  "$rawdata\Countries\Germany\Nummer gegen Kummer\OBchat202021.dta", replace
 
 
 
 // combine
use "$rawdata\Countries\Germany\Nummer gegen Kummer\OBmail2019.dta", clear

gen mail = 1
gen phone = 0 
gen chat = 0

append using "$rawdata\Countries\Germany\Nummer gegen Kummer\OBmail202022.dta"
append using "$rawdata\Countries\Germany\Nummer gegen Kummer\OBchat202021.dta"

replace chat = 1 if chat == .
replace mail = 0 if mail == .
replace phone = 0  if phone == .

destring hour, replace
encode berater_id, gen(user_id)
encode kind_id, gen(child_id)
drop berater_id kind_id id count_id   ageprob insorge

gen t_psysoc_body = (etg1x1 ==1)
lab var t_psysoc_body "Body/appearance"
gen t_psysoc_diesease = (etg1x2 ==1)
lab var t_psysoc_diesease "Disease/disability"
gen t_psysoc_grief = (etg1x3 ==1)
lab var t_psysoc_grief "Grief/loss"
gen t_psysoc_lonely = (etg1x4 ==1)
lab var t_psysoc_lonely "Loneliness"
gen t_psysoc_bored = (etg1x5 ==1)
lab var t_psysoc_bored "Boredom"
gen t_psysoc_leisure = (etg1x6 ==1)
lab var t_psysoc_leisure "Leisure/hobbies"
gen t_psysoc_fear = (etg1x7 ==1)
lab var t_psysoc_fear "Fear/anxiety"
gen t_psysoc_conf = (etg1x8 ==1)
lab var t_psysoc_conf "Confidence"
gen t_psysoc_ident = (etg1x9 ==1)
lab var t_psysoc_ident "Identity"
gen t_psysoc_psychprob = (etg1x10 ==1)
lab var t_psysoc_psychprob "Psychological problems"
 

gen t_fam_rules = (etg4x1 ==1)
lab var t_fam_rules "Rules/restrictions/opinions"
gen t_fam_childpar = (etg4x2 ==1)
lab var t_fam_childpar "Child-parent relations"
gen t_fam_siblgns = (etg4x3 ==1)
lab var t_fam_siblgns "Problems with siblings"
gen t_fam_supp = (etg4x4 ==1)
lab var t_fam_supp "Support"
gen t_fam_parconf = (etg4x5 ==1)
lab var t_fam_parconf "Conflicts of parents/separation/divorce"
gen t_fam_loss = (etg4x6 ==1)
lab var t_fam_loss "Grief/loss in family"
gen t_fam_health = (etg4x7 ==1)
lab var t_fam_health "Addiction/mental/pysical health of relatives"
gen t_fam_povrty = (etg4x8 ==1)
lab var t_fam_povrty "Poverty"
gen t_fam_exhousng = (etg4x9 ==1)
lab var t_fam_exhousng "External housing"
gen t_fam_care = (etg4x11 ==1)
lab var t_fam_care "Caring for relatives"
gen t_fam_other = (etg4x15 ==1)
lab var t_fam_other "Other family issues"

gen t_love_crush = (etg2x1 ==1)
lab var t_love_crush "Crush/in love"
gen t_love_contwish = (etg2x2 ==1)
lab var t_love_contwish "Looking for contact"
gen t_love_heart = (etg2x3 ==1)
lab var t_love_heart "Heartache"
gen t_love_parship = (etg2x4 ==1)
lab var t_love_parship "Forming relationship"
gen t_love_relconf = (etg2x5 ==1)
lab var t_love_relconf "Conflict in relationship"
gen t_love_jealous = (etg2x6 ==1)
lab var t_love_jealous "Jealousy"
gen t_love_separat = (etg2x7 ==1)
lab var t_love_separat "Separation (wish)"
gen t_love_left = (etg2x8 ==1)
lab var t_love_left "Left by partner"
gen t_love_distrel = (etg2x9 ==1)
lab var t_love_distrel "Distance relationship"
gen t_love_infid = (etg2x10 ==1)
lab var t_love_infid "Affairs/infidelity"
gen t_love_other = (etg2x15 ==1)
lab var t_love_other "Other relationship/love issues"


gen t_peer_frndsearch = (etg3x1 ==1)
lab var t_peer_frndsearch "Looking for friend(s)"
gen t_peer_conf = (etg3x2 ==1)
lab var t_peer_conf "Conflict with friends"
gen t_peer_comp = (etg3x3 ==1)
lab var t_peer_comp "Competition/envy"
gen t_peer_loyal = (etg3x4 ==1)
lab var t_peer_loyal "Loyalty"
gen t_peer_outsdr = (etg3x5 ==1)
lab var t_peer_outsdr "Outsider"
gen t_peer_mobb = (etg3x6 ==1)
lab var t_peer_mobb "Mobbing/exclusion by peers"
gen t_peer_loss = (etg3x7 ==1)
lab var t_peer_loss "Loss of friends (moving etc.)"
gen t_peer_statsym = (etg3x8 ==1)
lab var t_peer_statsym "Status symbols"
gen t_peer_prssre = (etg3x9 ==1)
lab var t_peer_prssre "Peer pressure"
gen t_peer_dare = (etg3x10 ==1)
lab var t_peer_dare "Dare/test of courage"
gen t_peer_other = (etg3x15 ==1)
lab var t_peer_other "Other peer issues"



gen t_sex_info = (etg5x1 ==1)
lab var t_sex_info "Body/development/sexuality information"
gen t_sex_contrcptn = (etg5x2 ==1)
lab var t_sex_contrcptn "Contraception"
gen t_sex_ftime = (etg5x3 ==1)
lab var t_sex_ftime "The first time"
gen t_sex_preg = (etg5x4 ==1)
lab var t_sex_preg "Pregnancy"
gen t_sex_orient = (etg5x5 ==1)
lab var t_sex_orient "Sexual orientation"
gen t_sex_mast = (etg5x6 ==1)
lab var t_sex_mast "Masturbation"
gen t_sex_pract = (etg5x7 ==1)
lab var t_sex_pract "Sexual practices"
gen t_sex_risk = (etg5x8 ==1)
lab var t_sex_risk "Risks (HIV/STDs/prevention)"
gen t_sex_phant = (etg5x10 ==1)
lab var t_sex_phant "Sexual phantasies"
gen t_sex_abort = (etg5x11 ==1)
lab var t_sex_abort "Abortion"
gen t_sex_other = (etg5x15 ==1)
lab var t_sex_other "Other sex-related issues"

gen t_livsit_runawy = (etg7x1 ==1)
lab var t_livsit_runawy "Runaway/street children"
gen t_livsit_law = (etg7x2 ==1)
lab var t_livsit_law "Conflict with law/authorities"
gen t_livsit_radicl = (etg7x3 ==1)
lab var t_livsit_radicl "Radicalism/extremism"
gen t_livsit_envir = (etg7x4 ==1)
lab var t_livsit_envir "Living situation/environment"
gen t_livsit_opport = (etg7x5 ==1)
lab var t_livsit_opport "Education/work opportunities"
gen t_livsit_fearfut = (etg7x6 ==1)
lab var t_livsit_fearfut "Fear of future"
gen t_livsit_relig = (etg7x7 ==1)
lab var t_livsit_relig "Religion"
gen t_livsit_racism = (etg7x8 ==1)
lab var t_livsit_racism "Racism/xenophobia"
gen t_livsit_asylm = (etg7x9 ==1)
lab var t_livsit_asylm "Asylum/refugees"
gen t_livsit_safinet = (etg7x10 ==1)
lab var t_livsit_safinet "Safer Internet"
gen t_livsit_other = (etg7x15 ==1)
lab var t_livsit_other "Other living sit. issues"

 

gen t_school_grades = (etg8x1 ==1)
lab var t_school_grades "Bad grades"
gen t_school_teachr = (etg8x2 ==1)
lab var t_school_teachr "Problems with teachers"
gen t_school_clssmts = (etg8x3 ==1)
lab var t_school_clssmts "Conflict with classmates"
gen t_school_mobb = (etg8x4 ==1)
lab var t_school_mobb "Mobbing/exclusion"
gen t_school_overld = (etg8x5 ==1)
lab var t_school_overld "Overload/pressure to perform"
gen t_school_learn = (etg8x6 ==1)
lab var t_school_learn "Learning difficulties"
gen t_school_work = (etg8x7 ==1)
lab var t_school_work "Problems in apprenticeship/at work"
gen t_school_skip = (etg8x8 ==1)
lab var t_school_skip "Truancy/skipping school"
gen t_school_swtch = (etg8x9 ==1)
lab var t_school_swtch "School switch"
gen t_school_fearfail = (etg8x10 ==1)
lab var t_school_fearfail "Fears of failure"
gen t_school_other = (etg8x15 ==1)
lab var t_school_other "Other school problems"

 
gen t_add_drugs = (etg9x1 ==1)
lab var t_add_drugs "Drugs/drug addiction"
gen t_add_alc = (etg9x2 ==1)
lab var t_add_alc "Alcohol"
gen t_add_tobac = (etg9x3 ==1)
lab var t_add_tobac "Tobacco"
gen t_add_selfharm = (etg9x4 ==1)
lab var t_add_selfharm "Self harm"
gen t_add_suic = (etg9x5 ==1)
lab var t_add_suic "Suicide"
gen t_add_obese = (etg9x8 ==1)
lab var t_add_obese "Obesity"
gen t_add_anorex = (etg9x7 ==1)
lab var t_add_anorex "Anorexia"
 egen addsum = rowtotal(etg9x1 etg9x2 etg9x3 etg9x4 etg9x5 etg9x6 etg9x7 etg9x8 etg9x9 etg9x10 etg9x15)
gen t_add_other = (etg9x6==1 | etg9x9==1 | etg9x10==1 | etg9x15==1)

gen t_viol_psych = (etg6x1 ==1)
lab var t_viol_psych "Psychological violence"
gen t_viol_phys = (etg6x2 ==1)
lab var t_viol_phys "Physical violence"
gen t_viol_sex = (etg6x3 ==1 | etg6x4 ==1 | etg6x8 ==1)
lab var t_viol_sex "Sexual violence"
egen violsum   =rowtotal(etg6x1 etg6x2 etg6x3 etg6x4 etg6x5 etg6x6 etg6x7 etg6x8 etg6x9 etg6x10 etg6x15)
gen t_viol_other = (violsum > 0 & t_viol_psych == 0 & t_viol_phys == 0 & t_viol_sex == 0)
lab var t_viol_other "Other violence"


order ddate hour kt  phone mail chat agegroup age female male diverse migrant concern_other concern_female concern_male concern_agegroup concern_age t_*


keep ddate hour kt phone mail chat  agegroup age female male diverse migrant concern_other concern_female concern_male concern_agegroup concern_age t_*
 

 save  "$rawdata\Countries\Germany\Nummer gegen Kummer\OB.dta", replace

 use "$rawdata\Countries\Germany\Nummer gegen Kummer\OB.dta",clear
 append using "$rawdata\Countries\Germany\Nummer gegen Kummer\KJT_beratungen.dta",
 
 
 
gen coronacall = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace coronacall = 1 if zb3x ==1 & ddate>mdy(3,31,2020) 
 
 tab coronacall if year(ddate) == 2021
 
gen corona_lonely = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_lonely = 1 if zb3x1 ==1 & ddate>mdy(3,31,2020) 
 
gen corona_domviol = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_domviol = 1 if zb3x2 ==1 & ddate>mdy(3,31,2020) 

gen corona_famlyconfl = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_famlyconfl = 1 if zb3x3 ==1 & ddate>mdy(3,31,2020) 

gen corona_bored = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_bored = 1 if zb3x4 ==1 & ddate>mdy(3,31,2020) 

gen corona_psychstablty = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_psychstablty = 1 if zb3x5 ==1 & ddate>mdy(3,31,2020) 

gen corona_school = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_school = 1 if zb3x6 ==1 & ddate>mdy(3,31,2020) 

gen corona_worrdothers = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_worrdothers = 1 if zb3x7 ==1 & ddate>mdy(3,31,2020) 

gen corona_fearinfect = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_fearinfect = 1 if zb3x8 ==1 & ddate>mdy(3,31,2020) 

gen corona_fearloss = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_fearloss = 1 if zb3x9 ==1 & ddate>mdy(3,31,2020) 

gen corona_insecurty = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_insecurty = 1 if zb3x10 ==1 & ddate>mdy(3,31,2020) 

gen corona_anger = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_anger = 1 if zb3x11 ==1 & ddate>mdy(3,31,2020) 

gen corona_fearfuture = 0 if ddate>mdy(3,31,2020) & ddate<mdy(3,1,2022)
replace corona_fearfuture = 1 if zb3x1 ==12 & ddate>mdy(3,31,2020) 






