clear all
set more off

global root "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data"
global results "C:\Users\joyse\Dropbox (MIT)\Risky behavior\Tables"
dis "$S_DATE $S_TIME"

use "$root\bbdd_final_Chile_cleaned.dta", clear
svyset [pw=factor]
estimates drop _all
eststo clear


*Merging dataset with employment dataset
// use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"
// // Open the second dataset
// use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\ENE2016\muniunemp.dta", clear
// decode r_p_c, generate(comuna_s)
// merge 1:m comuna_s using "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"
// drop _merge r_p_c
// sort idencuesta
// drop if missing(idencuesta)
// order comuna_s tasaocup tasadesocup, after(region)
// label var same_community "Dummy if they live in the same community as their last school"
// label var tasaocup "Employment rate"
// label var tasadesocup "Unemployment rate"
// save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace



*summ unprotected weapon robber tobacco alcohol mari other risky_behavior edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return risk_a short_t long_t jobloss divorce health_y health_f crime natural_d shocks if edad<=19


//**SAMPLE & RESULTS

//AGGSHOCKS

*Get F value for instruments
// regress individual_shocks edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region tasaocup if edad<=19 [pw=factor] , r
// test tasaocup
// gen F_test_inst=r(F)


*Run ivpoisson for risky_
// ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region (individual_shocks=tasaocup) if edad<=19 [pw=factor], vce(robust)
// gen sample=e(sample)
//gen Hansen_pvalue = 1 - chi2tail(`e(J_df)', `e(J)')

// outreg2 using "$results\Instrumental Variables Aggshock Analysis\aggshocks_tasaocup.xls", replace excel ctitle(Risky behavior) label dec(3) addstat("Relevance: F-value",F_test_inst) addnote("Instrumented: individual shocks, Instruments: tasaocup")
//

*Run ivregress for other variables
// local vars "unprotected weapon robber tobacco alcohol mari other"
// foreach v of local vars {
// ivreg2 `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region (individual_shocks=tasaocup) if edad<=19 [pw=factor], r
// outreg2 using "$results\Instrumental Variables Aggshock Analysis\aggshocks_tasaocup.xls", append excel ctitle(`v') label dec(3) addstat("Relevance: P-value for Kleibergen-Paap (<0.05)", e(idp)) 
// }
//"Exogeneity: Hansen probability (>0.05)", e(jp)


// //DISAGGSCHOCKS
// *Get F value for instruments
// regress health_y crime divorce jobloss edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d health_f i.region tasadesocup if edad<=19, r
// test tasadesocup
// //gen F_test_inst1=r(F)
//
//
// *Poisson regression for risky
// ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d jobloss crime health_f divorce i.region (health_y=tasadesocup) if edad<=19 [pw=factor], vce(robust)
// //gen Hansen_pvalue1 = 1 - chi2tail(`e(J_df)', `e(J)')
// outreg2 using "$results\Instrumental Variables Disaggshock Analysis\health_y_tasadesocup.xls", replace excel ctitle(Risky behavior) label dec(3) addstat("Relevance: F-value",F_test_inst1) addnote("Instrumented: health_y, Instruments: tasadesocup")
// //"Exogeneity: Hansen probability (>0.05)", Hansen_pvalue1
//
//
// *ivregress for others 
// local vars "unprotected weapon robber tobacco alcohol mari other"
// foreach v of local vars {
// ivreg2 `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d jobloss crime health_f divorce i.region (health_y=tasadesocup) if edad<=19 [pw=factor], r
// outreg2 using "$results\Instrumental Variables Disaggshock Analysis\health_y_tasadesocup.xls", append excel ctitle(`v') label dec(3) addstat("Relevance: P-value for Kleibergen-Paap (<0.05)", e(idp)) 
// }
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