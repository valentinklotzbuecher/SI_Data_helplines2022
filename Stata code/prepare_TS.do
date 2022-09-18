
///////////////////////////////////////////////////////////////////
// obtain raw data:

import excel "$rawdata\Countries\Germany\2021_q4.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2021_q4.dta",  replace
import excel "$rawdata\Countries\Germany\2021_q3.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2021_q3.dta",  replace
import excel "$rawdata\Countries\Germany\2021_q2.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2021_q2.dta",  replace

import excel "$rawdata\Countries\Germany\2021_q1.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2021_q1.dta",  replace

*use "$rawdata\Countries\Germany\2021_q3.dta", clear
use "$rawdata\Countries\Germany\2021_q1.dta", clear

append using "$rawdata\Countries\Germany\2021_q2.dta"
append using "$rawdata\Countries\Germany\2021_q3.dta"			 
append using "$rawdata\Countries\Germany\2021_q4.dta"

*import excel "$rawdata\Countries\Germany\2021-04-14 TelefonSeelsorge.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2021.dta",  replace
 


import excel "$rawdata\Countries\Germany\maerz-2022.ods-2022-6-15 17.23.14.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2022b_3.dta",  replace

import excel "$rawdata\Countries\Germany\april-2022.ods-2022-6-15 17.23.22.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2022b_4.dta",  replace

import excel "$rawdata\Countries\Germany\mai-2022.ods-2022-6-15 17.23.32.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2022b_5.dta",  replace

import excel "$rawdata\Countries\Germany\juni-2022.ods-2022-6-15 17.23.38.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2022b_6.dta",  replace

import excel "$rawdata\Countries\Germany\Daten TelefonSeelsorge 2022I.xlsx-2022-3-22 12.58.39.xlsx",  firstrow clear
gen ddate = date(substr(datum_formatted,1,10), "DMY")
format ddate %td
sort ddate
drop if month(ddate)==3
drop ddate
save "$rawdata\Countries\Germany\2022a.dta",  replace

use "$rawdata\Countries\Germany\2022a.dta", clear
append using "$rawdata\Countries\Germany\2022b_3.dta"
append using "$rawdata\Countries\Germany\2022b_4.dta"
append using "$rawdata\Countries\Germany\2022b_5.dta"
append using "$rawdata\Countries\Germany\2022b_6.dta"

save "$rawdata\Countries\Germany\2022.dta",  replace




import excel "$rawdata\Countries\Germany\2020-dec TelefonSeelsorge data.xlsx",  firstrow clear
drop in 1/20011
save "$rawdata\Countries\Germany\dec2020.dta",  replace

// import excel "$rawdata\Countries\Germany\2020-05-19 TelefonSeelsorge.xlsx",  firstrow clear
import excel "$rawdata\Countries\Germany\2020- 12 TelefonSeelsorge 2020.xlsx",  firstrow clear
save "$rawdata\Countries\Germany\2020NEW.dta",  replace

import excel "$rawdata\Countries\Germany\2019 Jahr.xlsx", sheet("Tabelle1") firstrow clear
save "$rawdata\Countries\Germany\2019.dta",  replace

clear all 

// import excel "$rawdata\Countries\Germany\2020 Jahr.xlsx", sheet("Tabelle1") firstrow clear

///////////////////////////////////////////////////////////////////
// List of city/center identifying codes:

import excel using "$rawdata\Countries\Germany\liste_städtecodes_LStorch_FINAL.xlsx", firstrow clear
rename citycodestring centercodestring
rename city center
keep region centercodestring  center

save "$rawdata\Countries\Germany\liste_städtecodes_LStorch.dta", replace

use "$rawdata\Countries\Germany\2020NEW.dta", clear
append using "$rawdata\Countries\Germany\2019.dta"
append using "$rawdata\Countries\Germany\dec2020.dta"
append using "$rawdata\Countries\Germany\2021.dta"

append using "$rawdata\Countries\Germany\2022.dta"

drop datum


save "$rawdata\Countries\Germany\20192020.dta", replace
*erase "$rawdata\Countries\Germany\2019.dta"
*erase "$rawdata\Countries\Germany\2020NEW.dta"
*erase "$rawdata\Countries\Germany\dec2020.dta"


*/
 
///////////////////////////////////////////////////////////////////
use  "$rawdata\Countries\Germany\20192020.dta", clear


///////////////////////////////////////////////////////////////////
// drop "bad" calls etc.
/*
drop if kontakt_art == "sexuelle Stimulierung"		// relevant?
drop if kontakt_art == "Sexanruf"		// relevant?


*/

drop if beratungstyp == "onsite"	
drop if kontakt_art == "Ratsuchender nicht erschienen"
drop if kontakt_art == "Aufleger / Verwählt"
drop if kontakt_art == "Aufleger/ verwählt"
drop if kontakt_art == "Scherzanruf"
drop if kontakt_art == "Scherz/Provokation/Beschimpfung"
drop if kontakt_art_kategorie == "Nicht Auftrag der TS"
drop if kontakt_art == "Nicht Auftrag der TS"
drop if kontakt_art_kategorie == "ungeöffnete Mail"
drop if kontakt_art == "Test-/ Scherzanruf" | kontakt_art == "zu Hause" | kontakt_art == "ungeöffnete Mail" 
///////////////////////////////////////////////////////////////////
** Spatial data

// identify call centers and states:
gen centercodestring = substr(room_index,1,16)
encode centercodestring, gen(centercode)
lab var centercode "Center code"

merge m:1 centercodestring using "$rawdata\Countries\Germany\liste_städtecodes_LStorch.dta"
replace region = "Unknown" if _merge != 3 & region == ""
// drop if _merge != 3
drop _merge


gen state = region
replace state = "Nordrhein-Westfalen" if substr(region,1,19) == "Nordrhein-Westfalen"
replace state = "Brandenburg" if substr(region,1,19) == "Brandenburg "





// Neubrandenburg-> MP?

lab var state "State/Bundesland"

encode state, gen(statecode)
lab var statecode "State code"

// state dummies:
gen BW = (state == "Baden-Württemberg")
gen BY = (state == "Bayern")
gen HE = (state == "Hessen")
gen NW = (state == "Nordrhein-Westfalen")
gen RP = (state == "Rheinland-Pfalz")
gen SL = (state == "Saarland")
gen BE = (state == "Berlin")
gen BB = (state == "Brandenburg")
gen HB = (state == "Bremen")
gen HH = (state == "Hamburg")
gen MV = (state == "Mecklenburg-Vorpommern")
gen LS = (state == "Niedersachsen")
gen SX = (state == "Sachsen")
gen SA = (state == "Sachsen-Anhalt")
gen SH = (state == "Schleswig-Holstein")
gen TH = (state == "Thüringen")

// br if state == ""
// tab center		

///////////////////////////////////////////////////////////////////
**Time data
gen ddate = date(substr(datum_formatted,1,10), "DMY")
format ddate %td
sort ddate

gen month = month(ddate)
gen year = year(ddate)
gen weekday = dow(ddate)
gen week =  week(ddate)

gen mdate = mofd(ddate)
format mdate %tm
gen wdate = wofd(ddate)
format wdate %tw

gen double dtime = clock(datum_formatted, "DMYhm")
generate hrs=hh(dtime)
generate mins=mm(dtime)

///////////////////////////////////////////////////////////////////
**Variable generation

global x_base "beratungstyp kontakt_art geschlecht namensnennung alter_range alter_bekannt beruf beruf_bekannt lebensform lebensform_bekannt suizidalitaet psychisch_diagnose erstkontakt kontakt_art_kategorie"

foreach v in $x_base {
     replace `v' = "." if `v' == "na"
 	encode `v', gen(`v'_code)
}




gen chats = (beratungstyp == "chat") 
gen mails = (beratungstyp == "mail") 
// gen onsitecontacts = (beratungstyp == "onside")
gen phones = (beratungstyp == "phone") 

tab beratungstyp,m
lab var chats "Chat contacts"
lab var mails "Mail contacts"
lab var phones "Phone contacts"

tab erstkontakt
gen firsts = (erstkontakt == "ja") 
gen recurs = (erstkontakt == "nein") 
lab var firsts "First contacts"
lab var recurs "Recurring contacts"
foreach V of varlist firsts recurs {
replace `V' = . if erstkontakt == ""
replace `V' = . if erstkontakt == "."
}


gen female = 1 if geschlecht == "female"
replace female = 0 if geschlecht == "male" 
lab var female "Female"

gen male = 1 if geschlecht == "male"
replace male = 0 if geschlecht == "female" 
lab var male "Male"

gen othergender = 1 if geschlecht == "other"
replace othergender = 0 if geschlecht == "male" | geschlecht == "female" 
lab var othergender "Other gender"


tab alter_range
replace alter_range = "" if alter_range == "."
replace alter_range = "0_to_9" if alter_range == "+_9"
replace alter_range = "80_or_above" if alter_range == "80_+"

gen age_0_9 = 	 (alter_range == "0_to_9")
gen age_10_14  = (alter_range == "10_14" )
gen age_15_19  = (alter_range == "15_19" )
gen age_20_29  = (alter_range == "20_29" )
gen age_30_39  = (alter_range == "30_39" )
gen age_40_49  = (alter_range == "40_49" )
gen age_50_59  = (alter_range == "50_59" )
gen age_60_69  = (alter_range == "60_69" )
gen age_70_79  = (alter_range == "70_79" )
gen age_80plus = (alter_range == "80_or_above")  
foreach V of varlist age_* {
replace `V' = . if alter_range == ""
}

lab var age_0_9  "Age: 0-9"
lab var age_10_14  "Age: 10-14 "
lab var age_15_19  "Age: 15-19 "
lab var age_20_29  "Age: 20-29 "
lab var age_30_39  "Age: 30-39 "
lab var age_40_49  "Age: 40-49 "
lab var age_50_59  "Age: 50-59 "
lab var age_60_69  "Age: 60-69 "
lab var age_70_79  "Age: 70-79 "
lab var age_80plus "Age: 80 and above"


gen age_min = substr(alter_range,1,2)
replace age_min = "0" if alter_range == "0_to_9"
gen age_max = substr(alter_range,4,2)
replace age_max = "9" if alter_range == "0_to_9"
replace age_max = "100" if alter_range == "80_or_above"
destring age_min age_max, replace
gen age = round((age_min + age_max)/2)

gen agegroup = alter_range

lab var age "Approx. age"

gen alone = (lebensform == "allein")
gen inst = (lebensform == "einrichtung")
gen family = (lebensform == "familie")
gen partner = (lebensform == "partnerschaft_ehe")
gen wg = (lebensform == "wg")
foreach V of varlist alone inst family partner wg {
replace `V' = . if lebensform == "."
}

lab var  alone "Living alone"
lab var  inst "Living in institution"
lab var  family "Living with family"
lab var  partner "Living with partner"
lab var  wg "Living in shared flat"

gen jobsearch = (beruf == "arbeitssuchend")
gen employed = (beruf == "erwerbstaetig")
gen disab = (beruf == "erwerbsunfaehig")
gen nojobsearch = (beruf == "nicht_arbeitssuchend")
gen retired = (beruf == "ruhestand")
gen educ = (beruf == "schule_studium_ausbildung")
foreach V of varlist jobsearch employed disab nojobsearch retired educ {
replace `V' = . if beruf == "."
}

lab var jobsearch "Searching job"
lab var employed  "Employed"
lab var disab  "Disability"
lab var nojobsearch "Not searching job"
lab var retired "Retired"
lab var educ "In education"

gen suicide0 = (suizidalitaet == "suizideinesanderen")
gen suicide1 = (suizidalitaet == "suizidgedanken") 
gen suicide2 = (suizidalitaet == "suizidabsichten") 
gen suicide3 = (suizidalitaet == "suizidversuche") 
foreach V of varlist suicide* {
replace `V' = . if suizidalitaet == "."
}

lab var suicide0 "Suicide of others"
lab var suicide1 "Suicidal thoughts"
lab var suicide2 "Suicidal intentions"
lab var suicide3 "Suicide attempts"

gen psydiknowns = (psychisch_diagnose == "known")
replace psydiknowns = . if psychisch_diagnose == "."

lab var psydiknowns "Psych. diagnosis"
// lab var psydiunknown "Psychological diagnosis"
        
gen drtn = dauer/60
label var drtn "Duration in minutes"

gen physicalprobs = (KörperlBefindenBeschwerden == "ja")
lab var physicalprobs "Physical constitution"
gen depressed = (DepressiveStimmung == "ja")
lab var depressed "Depressive mood"
gen grief = (Trauer == "ja")
lab var grief "Grief"
gen fears = (Ängste == "ja")
lab var fears "Fears"
gen stressemot = (StressemotionaleErschöpfung == "ja")
lab var stressemot "Stress, emotional fatigue"
gen anger = (ÄrgerAgression == "ja")
lab var anger "Anger, agression"
gen selfharm = (SelbstverletzendesVerhalten == "ja")
lab var selfharm "Self-harming behaviour"
gen confused = (Verwirrtheitszustände == "ja")
lab var confused "Confusion"
gen addict = (Sucht== "ja")
lab var addict "Addiction"
gen confshame = (SelbstbildSelbstwertSchamS== "ja")
lab var confshame "Low confidence, shame"
gen lonely = (EinsamkeitIsolation== "ja")
lab var lonely "Loneliness, isolation"
gen posithank = (PositivesBefindenFreudeDank== "ja")
lab var posithank "Positive feeling"
gen suicself = (SuizidalitätSuiziddesRatsuch== "ja")
lab var suicself "Suicidal self"
gen suicother = (SuizidalitätSuizideinesander== "ja")
lab var suicother "Suicidal other"
gen sex = (Sexualität== "ja")
lab var sex "Sexuality"
gen othermental = (SonstigesseelischesBefinden== "ja")
lab var othermental "Other mental issues"
gen partnersearch = (PartnersuchePartnerwahl== "ja")
lab var partnersearch "Partner search or choice"
gen livepartner = (LebeninPartnerschaft== "ja")
lab var livepartner "Life with partner"
gen parenting = (ElternschaftErziehung== "ja")
lab var parenting "Parenting"
gen pregnancy = (SchwangerschaftKinderwunsch== "ja")
lab var pregnancy "Pregnancy, childwish"
gen famrel = (FamiliäreBeziehungen== "ja")
lab var  famrel "Family relations"
gen everydayrel = (AlltagsbeziehungenNachbarnFr== "ja")
lab var everydayrel "Everyday relationships"
gen pubinstcont = (KontaktmitöffentlEinrichtung== "ja")
lab var pubinstcont "Public institutions"
gen caretherap = (BetreuungPflegeTherapieBeh== "ja")
lab var  caretherap "Care, therapy"
gen separat = (Trennung== "ja")
lab var separat "Separation"
gen mortality = (SterbenundTod== "ja")
lab var mortality "Mortality, death"
gen virtualrel = (VirtuelleBeziehungen== "ja")
lab var virtualrel "Virtual relationships"
gen migration = (MigrationIntegration== "ja")
lab var migration "Migration, integration"
gen physviol = (KörperlicheundoderseelischeG== "ja")
lab var physviol "Physical violence"
gen sexviol = (SexualisierteGewalt== "ja")
lab var sexviol "Sexual violence"
gen schooleduc = (SchuleundAusbildung== "ja")
lab var schooleduc "School, education"
gen worksit = (Arbeitssituation== "ja")
lab var worksit  "Work situation"
gen unempl = (ArbeitslosigkeitArbeitssuche== "ja")
lab var unempl "Unemployment, job search"
gen dailyrout = (Alltagsgestaltung== "ja")
lab var dailyrout "Daily routines"
gen volunt = (EhrenamtlTätigkeit== "ja")
lab var volunt "Volunteering"
gen poverty = (Armut== "ja")
lab var poverty "Poverty"
gen fininher = (FinanzfragenErbschaftUnterha== "ja")
lab var fininher "Finances, inheritance"
gen housing = (WohnungWohnumfeld== "ja")
lab var housing "Housing situation"
gen belief = (SinnGlaubeWerte== "ja")
lab var belief "Belief, values"
gen church = (KirchenundGlaubensgemeinschaft== "ja")
lab var church "Church, religion"
gen soccult = (GesellschaftundKultur== "ja")
lab var soccult "Society, culture"
gen TSfeedback_pos = (RückmeldungzurTSDankLob== "ja")
lab var TSfeedback_pos "TS: positive feedback"
gen TSfeedback_neg = (RückmeldungzurTSBeschwerde== "ja")
lab var TSfeedback_neg "TS: negative feedback"
gen TSfeedback_agr = (RückmeldungzurTSVereinbarun== "ja")
lab var TSfeedback_agr "TS: agreed feedback"
gen TSfeedback_other = (RückmeldungzurTSSonstigeRü== "ja")
lab var TSfeedback_other "TS: other feedback"
gen inform = (InformationenVerweisanweiter== "ja")
lab var inform "Further information"
gen topic_other = (SonstigeThemen== "ja")
lab var topic_other "Other topic"
gen topic_current = (AktuellesThema== "ja")
lab var topic_current "Current topic"
  
  
 global statedums "BW BY HE NW RP SL BE BB HB HH MV LS SX SA SH TH"


global callvars "chats mails phones drtn"

global indvars "firsts recurs female male othergender alone inst family partner wg jobsearch employed disab nojobsearch retired educ suicide0 suicide1 suicide2 suicide3 psydiknowns "
 
global agevars "age_0_9 age_10_14 age_15_19 age_20_29 age_30_39 age_40_49 age_50_59 age_60_69 age_70_79 age_80plus" 
  
global issuevars "physicalprobs depressed grief fears stressemot anger selfharm confused addict confshame lonely posithank suicself suicother sex othermental partnersearch livepartner parenting pregnancy famrel everydayrel pubinstcont caretherap separat mortality virtualrel migration physviol sexviol schooleduc worksit unempl dailyrout volunt poverty fininher housing belief church soccult TSfeedback_pos TSfeedback_neg TSfeedback_agr TSfeedback_other inform topic_other topic_current"  
 
 
 
 
egen topicsum = rowtotal($issuevars)
sum topicsum,d
// foreach V in $issuevars {
// replace `V' = . if topicsum == 0
// }
// 


rename chats 	chat
rename mails    mail
rename phones   phone
rename firsts   firstcall
rename recurs   repcall
rename age_min agemin 
rename age_max agemax
rename drtn duration
rename hrs hour

gen suicide = suicself
rename suicide0 suicidal_others
rename suicide1 suicidal_thoughts
rename suicide2 suicidal_plan
rename suicide3 suicidal_attempt

foreach V of varlist suicidal_others suicidal_thoughts suicidal_plan suicidal_attempt suicother {
replace suicide = 1 if `V' == 1
}

rename physicalprobs physhealth

rename addict addiction
gen violence =  0 if physviol !=. | sexviol !=.
replace violence =  1 if physviol ==1 | sexviol ==1
renvars alone inst family partner, prefix("living_")
rename wg living_shared
gen unemployed = 0 if jobsearch  != .
replace unemployed = 1 if jobsearch  == 1 | nojobsearch == 1
 
rename disab disability   


gen coronacall = topic_current


replace coronacall = 0 if  ddate<mdy(3,10,2020) 
*replace coronacall = 2 if coronacall == 1 & ddate>mdy(2,23,2022) & hour >15

rename educ education

gen country = "Germany"
gen population = 83.02 	// million (2019)


gen namestated = (namensnennung == "1")
gen agestated = (alter_bekannt == "known")


gen helplinename = "Telefonseelsorge Deutschland"

replace duration = . if phone != 1
replace duration = 120 if duration > 120 & duration !=.
 
drop  room_index-centercodestring 

format dtime %tc
encode region, gen(regioncode)
drop region

order helplinename ddate dtime duration center regioncode topicsum namestated agestated , first
rename state Bundesland

save "$rawdata\Countries\Germany\GERcontactsFULL.dta",  replace
  
  
///////////////////////////////////////////////////////////////////


use "$rawdata\Countries\Germany\GERcontactsFULL.dta", clear





merge m:1 country ddate using "$rawdata\otherdata.dta" , keep(master match)


gen quarter = quarter(ddate)


 
merge m:1 Bundesland ddate using "$npidata\bmwi_land_panel.dta" , gen(_mNPI)
drop if _mNPI == 2
save "$rawdata\Countries\Germany\GERcontacts.dta",  replace





