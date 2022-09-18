


import delimited "$rawdata/Sentiment_COVID-19-main/data/Final_Output_Bert_Fitted.csv",  clear 

keep if country  == "DEU" |  country  == "FRA"
gen ddate = date(tweet_date,"YMD")
format ddate %td
save "$rawdata/Sentiment_COVID-19-main/data/Final_Output_Bert_Fitted.dta", replace

use "$rawdata/COVID-19-Governments-Responses-master/Gov_Responses_Covid19_last.dta",  clear 

keep if iso  == "DEU" |  iso  == "FRA"

rename d ddate

drop geoid iso
rename state state_emergency
save "$rawdata/COVID-19-Governments-Responses-master/Gov_Responses_Covid19_last_GERFRA.dta",  replace 


import delimited "$rawdata\normalcy-index-data-main\normalcy-index.csv",  clear 

keep if iso3  == "DEU"   
gen ddate = date(date,"YMD")
drop date
gen country = "Germany" if iso3  == "DEU"
 save "$rawdata\normalcy-index-data-main\normalcy-index.dta", replace



* Government response:
import delimited "$rawdata\Oxford COVID-19 Government Response Tracker\covid-policy-tracker-master\data\OxCGRT_latest.csv",  clear 

tostring date, gen(stringdate)
gen ddate = date(stringdate,"YMD")
format ddate %td

gen country = countryname

keep if jurisdiction == "NAT_TOTAL"

keep if country =="Germany"  
save "$rawdata\Oxford COVID-19 Government Response Tracker\OxCGRT_latest.dta", replace


import delimited "$rawdata\Google Community Mobility Reports\Global_Mobility_Report.csv",  clear 
// tab country_region

keep if country_region =="Germany"  

gen ddate = date(substr(date,1,10), "YMD")
format ddate %td
gen country = country_region
keep if sub_region_1 == ""	//  dicard subnational
keep if metro_area == ""	//  dicard subnational

drop metro_area iso_3166_2_code census_fips_code country_region_code country_region sub_region_1 sub_region_2 date 

rename  retail_and_recreation_percent_ch GMretailrec 
rename  grocery_and_pharmacy_percent_cha GMgrocpharm 
rename  parks_percent_change_from_baseli GMparks
rename  transit_stations_percent_change_ GMtransit
rename  workplaces_percent_change_from_b GMworkpl
rename  residential_percent_change_from_ GMresident

global GMvars "GMretailrec  GMgrocpharm  GMparks GMtransit GMworkpl GMresident"
 
save "$rawdata\Google Community Mobility Reports\Global_Mobility_Report.dta", replace


* Merge all:

use "$rawdata\Oxford COVID-19 Government Response Tracker\OxCGRT_latest.dta", clear

*merge 1:1 country ddate using  "$rawdata/COVID-19-Governments-Responses-master/Gov_Responses_Covid19_last_GERFRA.dta",  gen(_mR2C) 


merge 1:1 country ddate using "$rawdata\Google Community Mobility Reports\Global_Mobility_Report.dta", gen(_mgoogle)
drop if _mgoogle == 2

merge 1:1 country ddate using "$rawdata\normalcy-index-data-main\normalcy-index.dta", gen(_mnormalcy)

encode country, gen(countryAcode)
xtset countryAcode ddate


gen newcases = D.confirmedcases
gen newdeaths = D.confirmeddeaths

drop regionname regioncode jurisdiction m1_wildcard _mgoogle countryAcode date stringdate
order country ddate, first


rename c8_internationaltravelcontrols c8_internattravel
rename c4_restrictionsongatherings c4_restrgather
rename c7_restrictionsoninternalmovemen c7_restrinternalmov
rename h1_publicinformationcampaigns h1_publicinfocampaigns

gen ic1_schoolclosing = ((c1_schoolclosing-0.5*(1-c1_flag))/3)*100
replace ic1_schoolclosing = 0 if c1_schoolclosing == 0
gen li_c1_schoolclosing = log(ic1_schoolclosing+1)

gen ic2_workplaceclosing = ((c2_workplaceclosing-0.5*(1-c2_flag))/3)*100
replace ic2_workplaceclosing = 0 if c2_workplaceclosing == 0
gen li_c2_workplaceclosing = log(ic2_workplaceclosing+1)

gen ic6_stayathomerequirements = ((c6_stayathomerequirements-0.5*(1-c6_flag))/3)*100
replace ic6_stayathomerequirements = 0 if c6_stayathomerequirements == 0
gen li_c6_stayathomerequirements = log(ic6_stayathomerequirements+1)


gen ic4_restrgather = ((c4_restrgather-0.5*(1-c4_flag))/4)*100
replace ic4_restrgather = 0 if c4_restrgather == 0
gen li_c4_restrgather = log(ic4_restrgather+1)

gen ic8_internattravel = ((c8_internattravel)/4)*100
replace ic8_internattravel = 0 if c8_internattravel == 0
gen li_c8_internattravel = log(ic8_internattravel+1)

gen ic3_cancelpublicevents = ((c3_cancelpublicevents-0.5*(1-c3_flag))/2)*100
replace ic3_cancelpublicevents = 0 if c3_cancelpublicevents == 0
gen li_c3_cancelpublicevents = log(ic3_cancelpublicevents+1)

gen ic5_closepublictransport = ((c5_closepublictransport-0.5*(1-c3_flag))/2)*100
replace ic5_closepublictransport = 0 if c5_closepublictransport == 0
gen li_c5_closepublictransport = log(ic5_closepublictransport+1)

gen ic7_restrinternalmov = ((c7_restrinternalmov-0.5*(1-c3_flag))/2)*100
replace ic7_restrinternalmov = 0 if c7_restrinternalmov == 0
gen li_c7_restrinternalmov = log(ic7_restrinternalmov+1)

gen ie1_incomesupport = ((e1_incomesupport-0.5*(1-e1_flag))/2)*100
replace ie1_incomesupport = 0 if e1_incomesupport == 0
gen li_e1_incomesupport = log(ie1_incomesupport+1)

gen ie2_debtcontractrelief = ((e2_debtcontractrelief)/2)*100
replace ie2_debtcontractrelief = 0 if e2_debtcontractrelief == 0
gen li_e2_debtcontractrelief = log(ie2_debtcontractrelief+1)


gen ih1_publicinfocampaigns = ((h1_publicinfocampaigns-0.5*(1-h1_flag))/2)*100
replace ih1_publicinfocampaigns = 0 if h1_publicinfocampaigns == 0
gen li_h1_publicinfocampaigns = log(ih1_publicinfocampaigns+1)

keep if country == "Germany"
merge 1:1 ddate using "$rawdata\otherdataX.dta"
save "$rawdata\otherdata.dta", replace



use "$rawdata\otherdata.dta",clear







