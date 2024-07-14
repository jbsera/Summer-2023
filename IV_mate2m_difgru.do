clear all
set more off

global root "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data"
global results "C:\Users\joyse\Dropbox (MIT)\Risky behavior\Tables"
dis "$S_DATE $S_TIME"

use "$root\bbdd_final_Chile_cleaned.dta", clear
svyset [pw=factor]
estimates drop _all
eststo clear


//**SAMPLE & RESULTS

//AGGSHOCKS

*Get F value for instruments
regress individual_shocks edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region prom_mate2m_rbd difgru_mate2m_rbd if edad<=19 [pw=factor] , r
test prom_mate2m_rbd difgru_mate2m_rbd
gen F_test_inst=r(F)


*Run ivpoisson for risky_
ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region (individual_shocks=prom_mate2m_rbd difgru_mate2m_rbd) if edad<=19 [pw=factor], vce(robust)
gen sample=e(sample)
gen Hansen_pvalue = 1 - chi2tail(`e(J_df)', `e(J)')

outreg2 using "$results\Instrumental Variables Aggshock Analysis\aggshocks_mate2mdifgru.xls", replace excel ctitle(Risky behavior) label dec(3) addstat("Relevance: F-value",F_test_inst, "Exogeneity: Hansen probability (>0.05)", Hansen_pvalue) addnote("Instrumented: individual shocks, Instruments: prom_mate2m_rbd difgru_mate2m_rbd")


*Run ivregress for other variables
local vars "unprotected weapon robber tobacco alcohol mari other"
foreach v of local vars {
ivreg2 `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region (individual_shocks=prom_mate2m_rbd difgru_mate2m_rbd) if edad<=19 & sample==1 [pw=factor], r
outreg2 using "$results\Instrumental Variables Aggshock Analysis\aggshocks_mate2mdifgru.xls", append excel ctitle(`v') label dec(3) addstat("Relevance: P-value for Kleibergen-Paap (<0.05)", e(idp), "Exogeneity: Hansen probability (>0.05)", e(jp)) 
}



//DISAGGSCHOCKS
*Get F value for instruments
regress jobloss edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d divorce health_y health_f crime i.region prom_mate2m_rbd difgru_mate2m_rbd if edad<=19 & sample==1, r
test prom_mate2m_rbd difgru_mate2m_rbd
gen F_test_inst1=r(F)


*Poisson regression for risky
ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d divorce health_y health_f crime i.region (jobloss=prom_mate2m_rbd difgru_mate2m_rbd) if edad<=19 & sample==1 [pw=factor], vce(robust)
gen Hansen_pvalue1 = 1 - chi2tail(`e(J_df)', `e(J)')
outreg2 using "$results\disaggshocks_mate2mdifgru.xls", replace excel ctitle(Risky behavior) label dec(3) addstat("Relevance: F-value",F_test_inst1, "Exogeneity: Hansen probability (>0.05)", Hansen_pvalue1) addnote("Instrumented: health_y, Instruments: prom_mate2m_rbd difgru_mate2m_rbd")



*ivregress for others 
local vars "unprotected weapon robber tobacco alcohol mari other"
foreach v of local vars {
ivreg2 `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d divorce health_y health_f crime i.region (jobloss=prom_mate2m_rbd difgru_mate2m_rbd) if edad<=19 & sample==1 [pw=factor], r
outreg2 using "$results\disaggshocks_mate2mdifgru.xls", append excel ctitle(`v') label dec(3) addstat("Relevance: P-value for Kleibergen-Paap (<0.05)", e(idp), "Exogeneity: Hansen probability (>0.05)", e(jp)) 
}
