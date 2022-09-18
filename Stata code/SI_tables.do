 
  
  
  
  
  
  
use "$rawdata\Countries\Germany\merged.dta", clear

 gen calls = 1 
  tab h1code, gen(h1line)
   tab agecode, gen(age_)

lab var age_1 "Age <15"
lab var age_2 "Age 15--19"
lab var age_3 "Age >19"

estpost tabstat female  male   phone chat mail  h1line* if age_3==0  , statistics(mean sum  count) columns(statistics)

   
   
estpost tabstat female  male   phone chat mail age_*  if h1code==1  , statistics(mean sum  count) columns(statistics)

# delimit ;
esttab using ".\TeX\Tables\descriptives1.tex", replace style(tex) type noabbrev label nomtitle nonumber  noisily
	cells("mean(fmt(%9.3f)) sum(fmt(%12.0fc))  count(fmt(%12.0fc))" )  
	substitute("\_" "\"
				"\hline" "" "&        mean&         sum&       count\\" ""
				" contacts" ""   
				"Age" "Caller age"  
				"ale" "ale caller"
				"Total observations  &      375798&            &            \\" ""  )
				stats(N , fmt(%18.0g) labels("Total observations")) 		
				prehead("\renewcommand{\arraystretch}{1.1}"
							"\begin{table}[htbp]\small"
							"\begin{tabular}{l D{.}{.}{5.6}@{} D{.}{.}{10.4}@{} D{.}{.}{9.0}@{}}\toprule"
 							"\textbf{A}\quad NgK children/youth line & \multicolumn{1}{c}{Share} & \multicolumn{1}{c}{Sum} &  \multicolumn{1}{c}{n}\\\midrule" )	
				postfoot("\midrule");
# delimit cr
  
estpost tabstat female  male   phone chat mail age_*  if h1code==2  , statistics(mean sum  count) columns(statistics)
# delimit ;
esttab using ".\TeX\Tables\descriptives2.tex", replace style(tex) type noabbrev label nomtitle nonumber noisily
	cells("mean(fmt(%9.3f)) sum(fmt(%12.0fc))  count(fmt(%12.0fc))" )  
	substitute("\_" "\"
				"\hline" "" "&        mean&         sum&       count\\" "" " contacts" ""   "Age" "Caller age"  "ale" "ale caller"
				"Total observations  &     2550473&            &            \\" "" )
				stats(N , fmt(%18.0g) labels("Total observations")) 		
				prehead( 
				"\textbf{B}\quad TelefonSeelsorge & \multicolumn{1}{c}{Share} & \multicolumn{1}{c}{Sum} &  \multicolumn{1}{c}{n}\\\midrule" )	
				postfoot("\midrule");
# delimit cr

lab var h1line1 "NgK children/youth line"
lab var h1line2 "TelefonSeelsorge"
estpost tabstat female  male   phone chat mail age_*  h1line*  , statistics(mean sum  count) columns(statistics)
# delimit ;
esttab using ".\TeX\Tables\descriptives3.tex", replace style(tex) type noabbrev label nomtitle nonumber noisily
	cells("mean(fmt(%9.3f)) sum(fmt(%12.0fc))  count(fmt(%12.0fc))" )  
	substitute("\_" "\"
				"\hline" "" "&        mean&         sum&       count\\" "" " contacts" ""    "Age" "Caller age"  "ale" "ale caller"
				"Total observations  &     2926271&            &            \\" "")
				stats(N , fmt(%18.0g) labels("Total observations")) 	
				prehead( 	"\textbf{C}\quad Combined dataset & \multicolumn{1}{c}{Share} & \multicolumn{1}{c}{Sum} &  \multicolumn{1}{c}{n}\\\midrule" )	
				postfoot("\bottomrule"
							"\end{tabular}\\" 
       						"\parbox{12cm}{\caption[Summary Statistics, combined dataset]{  {\bf Summary Statistics, combined dataset.} Conversations with \textbf{A} the NgK children/youth line, \textbf{B} TelefonSeelsorge, and \textbf{C} the combined dataset used in the main analysis. Columns show the respective share and number of calls, along with the overall number of conversations for which information is available. \label{descriptives1}}}"
							"\end{table}");
# delimit cr





frame reset
use "$rawdata\Countries\Germany\Nummer gegen Kummer\KJT_beratungen.dta", clear
  append using "$rawdata\Countries\Germany\Nummer gegen Kummer\OB.dta"


gen knowncaller = 0
replace knowncaller = 1 if habitcall == 1
lab var knowncaller "Known caller"
lab var phone "Phone call"
lab var chat "Chat contact"
lab var mail "Mail contact"
 
lab var  ptwith_youngp  "Problems with young people" 
lab var ptwith_adultp    "Problems with adults"                  
lab var ptwith_y_sibling    "\qquad siblings"                 
lab var ptwith_y_bestfriend   "\qquad best friend"              
lab var ptwith_y_friends    "\qquad friends"                 
lab var ptwith_y_partner    "\qquad partner"                 
lab var  ptwith_y_classmate  "\qquad classmates"                
lab var ptwith_y_online   "\qquad online relations"                            
lab var  ptwith_y_other  "\qquad other young people"   
 lab var  ptwith_self  "Problems with self"           
lab var   ptwith_a_parents "\qquad with parents"              
lab var  ptwith_a_father  "\qquad with father"               
lab var   ptwith_a_mother "\qquad with mother"				 
lab var   ptwith_a_prntpartner "\qquad with partner of parent"   
lab var ptwith_a_family   "\qquad in family"                      
lab var   ptwith_a_teacher "\qquad with teachers"                    
lab var  ptwith_a_other  "\qquad with other adults"                 



estpost tabstat female male diverse phone chat mail migrant   knowncaller   concern_other ptwith_self ptwith_youngp  ptwith_y_siblings ptwith_y_bestfriend ptwith_y_friends ptwith_y_partner ptwith_y_classmate ptwith_y_online ptwith_y_other ptwith_adultp ptwith_a_parents ptwith_a_father ptwith_a_mother ptwith_a_prntpartner ptwith_a_family ptwith_a_teacher ptwith_a_other  , statistics(mean sum  count) columns(statistics)

# delimit ;
esttab using ".\TeX\Tables\descriptivesNgK.tex", replace style(tex) type noabbrev label nomtitle nonumber  noisily
	cells("mean(fmt(%9.3f)) sum(fmt(%12.0fc))  count(fmt(%12.0fc))" )  
	substitute("\_" "\" "_" " "
				"\hline" "" "&        mean&         sum&       count\\" ""
				"Total observations  &      375844&            &            \\" ""
				"{N}\\" "{N}\\\midrule")
				stats(N , fmt(%18.0g) labels("Total observations"))
				varlabels(v2x_libdem "\textit{Liberal democracy index} "
						   v2xcl_rol "\textit{Individual liberty index}"						   
						   )
				prehead("\renewcommand{\arraystretch}{1.1}"
							"\begin{table}[htbp]\small"
							"\begin{tabular}{l D{.}{.}{5.6}@{} D{.}{.}{10.4}@{} D{.}{.}{9.0}@{}}\toprule"
 							" & \multicolumn{1}{c}{Share} & \multicolumn{1}{c}{Sum} &  \multicolumn{1}{c}{n}\\\midrule" )	
				postfoot("\bottomrule"
							"\end{tabular}\\" 
       						"\parbox{12cm}{\caption[ Summary Statistics, NgK children/youth line]{  {\bf Summary Statistics, NgK children/youth line.} Conversations with the NgK children/youth line. Columns show the respective share and number of calls, along with the overall number of conversations for which information is available.   \label{descriptivesNgK}}}"
							"\end{table}");
# delimit cr







 frame reset
clear all
use "$rawdata/Countries/Germany/TS_sample.dta", clear

lab var living_alone "Living alone" 
lab var living_inst "\qquad in institution" 
lab var living_family "\qquad with family" 
lab var living_partner "\qquad with partner" 
lab var living_shared "\qquad in shared accom." 
lab var jobsearch "Unemployed, searching" 
lab var employed "Working" 
lab var disability "Disability" 
lab var nojobsearch "Unempl., not searching" 
lab var retired "Retired" 
lab var education "In education" 
lab var suicidal_others "Suicidality of others" 
lab var suicidal_thoughts "Suicidal thoughts" 
lab var suicidal_plan "Suicide plans" 
lab var suicidal_attempt "Suicide attempt" 
lab var psydiknowns "Known psychol. diagnosis" 
 
estpost tabstat female male othergender phone chat mail living_alone living_inst living_family living_partner living_shared  employed education jobsearch nojobsearch retired disability psydiknowns  suicidal_thoughts suicidal_plan suicidal_attempt suicidal_others , statistics(mean sum  count) columns(statistics)

# delimit ;
esttab using ".\TeX\Tables\descriptivesTS.tex", replace style(tex) type noabbrev label nomtitle nonumber  noisily
	cells("mean(fmt(%9.3f)) sum(fmt(%12.0fc))  count(fmt(%12.0fc))" )  
	substitute("\_" "\" "_" " "
				"\hline" "" "&        mean&         sum&       count\\" ""
				"Total observations  &     2308411&            &            \\" "")
				stats(N , fmt(%18.0g) labels("Total observations"))
				prehead("\renewcommand{\arraystretch}{1.1}"
							"\begin{table}[htbp]\small"
							"\begin{tabular}{l D{.}{.}{5.6}@{} D{.}{.}{10.4}@{} D{.}{.}{9.0}@{}}\toprule"
 							" & \multicolumn{1}{c}{Share} & \multicolumn{1}{c}{Sum} &  \multicolumn{1}{c}{n}\\\midrule" )	
				postfoot("\bottomrule"
							"\end{tabular}\\" 
       						"\parbox{12cm}{\caption[Summary Statistics, TelefonSeelsorge]{  {\bf Summary Statistics, TelefonSeelsorge.} Conversations with TelefonSeelsorge. Columns show the respective share and number of calls, along with the overall number of conversations for which information is available.  \label{descriptivesTS}}}"
							"\end{table}");
# delimit cr



use "$rawdata\Countries\Germany\Nummer gegen Kummer\ET.dta", clear  

lab var female "Female caller"
lab var male "Male caller"
lab var firstcall "First-time caller"
lab var repcall  "Repeat caller"
lab var habitcall "Habitual caller"
lab var migrant "Migration background"
lab var finprobs "Financial problems"
lab var child_age0_14 "Referring to children (age<15))"
lab var child_age15_older "\qquad adolescents (age>14)"
lab var child_male "\qquad male children/adolescents"
lab var child_female "\qquad female children/adolescents"
  
replace relation2child = . if relation2child ==9
tab relation2child, gen(rel_)

replace marstat = "" if marstat =="Unknown"
tab marstat, gen(ms_)

estpost tabstat female male firstcall repcall habitcall migrant finprobs ms_2 ms_4 ms_3 ms_1 ms_5 rel_*   lwchild* child_age0_14 child_age15_older child_male child_female, statistics(mean sum  count) columns(statistics)

# delimit ;
esttab using ".\TeX\Tables\descriptivesET.tex", replace style(tex) type noabbrev label nomtitle nonumber  noisily
	cells("mean(fmt(%9.3f)) sum(fmt(%12.0fc))  count(fmt(%12.0fc))" )  
	substitute("\_" "\" "_" " "
	"marstat==" ""	"relation2child==" "" "livingwchild==" ""
				"\hline" "" "&        mean&         sum&       count\\" "" 
				"Observations        &       56150&            &            \\" "")
 				prehead("\renewcommand{\arraystretch}{1.1}"
							"\begin{table}[htbp]\small"
							"\begin{tabular}{l D{.}{.}{5.6}@{} D{.}{.}{10.4}@{} D{.}{.}{9.0}@{}}\toprule"
 							" & \multicolumn{1}{c}{Share} & \multicolumn{1}{c}{Sum} &  \multicolumn{1}{c}{n}\\\midrule" )	
				postfoot("\bottomrule"
							"\end{tabular}\\" 
       						"\parbox{13cm}{\caption[Summary Statistics, NgK parent helpline]{{\bf Summary Statistics, NgK parent helpline.} Conversations with the NgK parent line. Columns show the respective share and number of calls, along with the overall number of conversations for which information is available. \label{descriptivesET}}}"
							"\end{table}");
# delimit cr


 




 
			