clear all
set more off

global root "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data"
global results "C:\Users\joyse\Dropbox (MIT)\Risky behavior\Tables"
dis "$S_DATE $S_TIME"

use "$root\bbdd_final_Chile_cleaned.dta", clear
svyset [pw=factor]
estimates drop _all
eststo clear
sort idencuesta

// *Getting a3 info
// use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"
// use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\chile_parents.dta", clear
// // Merge the datasets using idencuesta
// merge 1:1 idencuesta using "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"
// drop _merge 
// order lives_with_mom lives_with_dad, after(a3)
// sort idencuesta
// label var lives_with_mom "Dummy if currently lives with bio mom"
// label var lives_with_dad "Dummy if currently lives with bio dad"
// save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace
//
//
// *Creating variables if lives with mom or dad until infancy (13)
// gen lives_with_mom_inf=lives_with_mom
// gen lives_with_dad_inf=lives_with_dad
//
//
// // Loop through every observation
// forval i = 1/3560 {
//     // Check if lives_with_mom_inf is 0
//     if lives_with_mom_inf[`i'] == 0 {
//         // Check the value of a12
//         if a12[`i'] == 1 {
//             // Keep lives_with_mom_inf as 0
//         }
//         else if inlist(a12[`i'], 2, 3, 4, 5, 99) {
//             // Check the value of a13
//             if a13[`i'] >= 13 {
//                 replace lives_with_mom_inf = 1 in `i'
//             }
//             else {
//                 // Keep lives_with_mom_inf as 0
//             }
//         }
//     }
// }
//
//
// // Loop through every observation
// forval i = 1/3560 {
//     // Check if lives_with_dad_inf is 0
//     if lives_with_dad_inf[`i'] == 0 {
//         // Check the value of a14
//         if a14[`i'] == 1 {
//             // Keep lives_with_dad_inf as 0
//         }
//         else if inlist(a14[`i'], 2, 3, 4, 5, 99) {
//             // Check the value of a15
//             if a15[`i'] >= 13 {
//                 replace lives_with_dad_inf = 1 in `i'
//             }
//             else {
//                 // Keep lives_with_dad_inf as 0
//             }
//         }
//     }
// }
//
//
// order lives_with_dad_inf, after(lives_with_dad)
// order lives_with_mom_inf, after(lives_with_mom)
// label var lives_with_dad_inf "Dummy if lived with bio dad at least to age 13"
// label var lives_with_mom_inf "Dummy if lived with bio mom at least to age 13"
// gen lives_with_momdad_inf = (lives_with_dad_inf == 1 & lives_with_mom_inf == 1)
// label var lives_with_momdad_inf "Dummy if lived with bio mom and bio dad at least to age 13"
// order lives_with_momdad_inf, after(lives_with_dad_inf)
//
// save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace


*summ unprotected weapon robber tobacco alcohol mari other risky_behavior edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return risk_a short_t long_t jobloss divorce health_y health_f crime natural_d shocks if edad<=19


//**SAMPLE & RESULTS

//AGGSHOCKS

*Get F value for instruments
regress individual_shocks edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd if edad<=19 [pw=factor] , r
test lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd
gen F_test_inst=r(F)


*Run ivpoisson for risky_
ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region (individual_shocks=lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd) if edad<=19 [pw=factor], vce(robust)
gen sample=e(sample)
gen Hansen_pvalue = 1 - chi2tail(`e(J_df)', `e(J)')

outreg2 using "$results\Instrumental Variables Aggshock Analysis\aggshocks_momanddad_inf_mate2m_difgrumate2m.xls", replace excel ctitle(Risky behavior) label dec(3) addstat("Relevance: F-value",F_test_inst, "Exogeneity: Hansen p value >0.05", Hansen_pvalue) addnote("Instrumented: individual shocks, Instruments: lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd")
//"Exogeneity: Hansen p value >0.05", Hansen_pvalue

*Run ivregress for other variables
local vars "unprotected weapon robber tobacco alcohol mari other"
foreach v of local vars {
ivreg2 `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region (individual_shocks=lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd) if edad<=19 [pw=factor], r
outreg2 using "$results\Instrumental Variables Aggshock Analysis\aggshocks_momanddad_inf_mate2m_difgrumate2m.xls", append excel ctitle(`v') label dec(3) addstat("Relevance: P-value for Kleibergen-Paap (<0.05)", e(idp), "Exogeneity: Hansen probability (>0.05)", e(jp)) 
}
//"Exogeneity: Hansen probability (>0.05)", e(jp)


//DISAGGSCHOCKS
*Get F value for instruments
regress jobloss divorce  health_y crime edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d health_f i.region lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd if edad<=19, r
test lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd
gen F_test_inst1=r(F)


*Poisson regression for risky
ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d health_y crime health_f divorce i.region (jobloss=lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd) if edad<=19 [pw=factor], vce(robust)
gen Hansen_pvalue1 = 1 - chi2tail(`e(J_df)', `e(J)')
outreg2 using "$results\Instrumental Variables Disaggshock Analysis\disagg_momanddad_inf_mate2m_difgrumate2m.xls", replace excel ctitle(Risky behavior) label dec(3) addstat("Relevance: F-value",F_test_inst1, "Exogeneity: Hansen probability (>0.05)", Hansen_pvalue1) addnote("Instrumented: jobloss, Instruments: lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd")
//"Exogeneity: Hansen probability (>0.05)", Hansen_pvalue1


*ivregress for others 
local vars "unprotected weapon robber tobacco alcohol mari other"
foreach v of local vars {
ivreg2 `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d health_y crime health_f divorce i.region (jobloss=lives_with_momdad_inf prom_mate2m_rbd difgru_mate2m_rbd) if edad<=19 [pw=factor], r
outreg2 using "$results\Instrumental Variables Disaggshock Analysis\disagg_momanddad_inf_mate2m_difgrumate2m.xls", append excel ctitle(`v') label dec(3) addstat("Relevance: P-value for Kleibergen-Paap (<0.05)", e(idp), "Exogeneity: Hansen probability (>0.05)", e(jp)) 
}
// "Exogeneity: Hansen probability (>0.05)", e(jp)




// // cd "$results"
// // /** DESCRIPTIVE STATISTICS */
// // local variables risky unprotected_sex weapon robbery tobacco alcohol marijuana other_d edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d individual_shocks jobloss divorce health_y health_f crime prom_lect2m_rbd prom_mate2m_rbd
// // asdoc sum `variables' [aw=factor] if edad<=19 & sample==1, stat(mean sd) save(descriptive.doc) replace dec(3) label
// // asdoc sum `variables' [aw=factor] if edad<=19 & sample==1 & dum_r==0, stat(mean sd) save(descriptive.doc) append dec(3) label
// // asdoc sum `variables' [aw=factor] if edad<=19 & sample==1 & dum_r==1, stat(mean sd) save(descriptive.doc) append dec(3) label
// //
// //
// //
// // sort dum_r
// //				 
// // foreach var in `variables' {                       
// //   quietly asdoc ttest `var' if edad<=19 & sample==1, by(dum_r) une save(descriptive.doc) append label
// //  }
//
//
//
// /*
// local variables risky unprotected_sex weapon robbery tobacco alcohol marijuana other_d edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d individual_shocks jobloss divorce health_y health_f crime
//  			 
// matrix drop _all
// count if edad<=19 & sample==1
// scalar N = r(N)
//					 
// foreach var in `variables' {                       
//   quietly sum `var' if edad<=19 & sample==1 [aw=factor], detail 
//     scalar `var'_mean   = r(mean)
//   scalar `var'_sd     = r(sd)
//  matrix row_`var' = (`var'_mean, `var'_sd)   
//  matrix rownames row_`var' = "`var'" 
//  matrix OUT = nullmat(OUT)\ row_`var'
//  }
//
// 
// matrix colnames OUT = "Mean" "SD"
// local rname ""
// foreach var in `variables' {
// local lbl : variable label `var' 
// local rname `"  `rname'  "`lbl'" "'	
// }	
//
// matrix list OUT
//
//
// matrix drop _all
// count if edad<=19 & sample==1 & dum_r==0
// scalar N = r(N)
//					 
// foreach var in `variables' {                       
//   quietly sum `var' if edad<=19 & sample==1 & dum_r==0 [aw=factor], detail 
//   scalar `var'_mean   = r(mean)
//   scalar `var'_sd     = r(sd)
//  matrix row_`var' = (`var'_mean, `var'_sd)   
//  matrix rownames row_`var' = "`var'" 
//  matrix OUT = nullmat(OUT)\ row_`var'
//  }
//
// 
// matrix colnames OUT = "Mean" "SD"
// local rname ""
// foreach var in `variables' {
// local lbl : variable label `var' 
// local rname `"  `rname'  "`lbl'" "'	
// }	
//
// matrix list OUT
//
// matrix drop _all
// count if edad<=19 & sample==1 & dum_r==1
// scalar N = r(N)
//					 
// foreach var in `variables' {                       
//   quietly sum `var' if edad<=19 & sample==1 & dum_r==1 [aw=factor], detail 
//   scalar `var'_mean   = r(mean)
//   scalar `var'_sd     = r(sd)
//  matrix row_`var' = (`var'_mean, `var'_sd)   
//  matrix rownames row_`var' = "`var'" 
//  matrix OUT = nullmat(OUT)\ row_`var'
//  }
//
// 
// matrix colnames OUT = "Mean" "SD"
// local rname ""
// foreach var in `variables' {
// local lbl : variable label `var' 
// local rname `"  `rname'  "`lbl'" "'	
// }	
//
// matrix list OUT
//
// */
//
//
// //STOP