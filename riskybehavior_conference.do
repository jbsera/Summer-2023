/*====================================================================
Project: Risky behavior in Chile. 
Author: AR
Creation date: 5 August 2023
====================================================================*/

clear all
set more off

global root "C:\Users\andrea.repetto\Dropbox\Risky behavior\data"
global results "C:\Users\andrea.repetto\Dropbox\Risky behavior\tables"
global figures "C:\Users\andrea.repetto\Dropbox\Risky behavior\figures"
dis "$S_DATE $S_TIME"

use  "$root\bbdd_final_Chile_cleaned.dta", clear
svyset [pw=factor]
estimates drop _all
eststo clear


/******1. RISKY BEHAVIOR */



/*
**** SEXUAL ACTIVITY
lab var activo_sex "Sexually active"

*First sexual intercourse
gen first_intercourse=edad_1era_rs
replace first_int=0 if activo_sex==0
lab var first_int "Age first sexual intercourse"

*Number of sexual partners
gen number_partners=aa5
replace number_partners=0 if activo_sex==0  //menores de 12 anos!
lab var number_partners "Number of sexual partners"
replace a_aa6=0 if aa6_10==10
lab var a_aa6 "Unprotected sex"
lab var embarazo_a "Teenage pregnancy"



**** CARRIES A WEAPON
lab var a_aa11 "Carries a weapon"
lab var a_aa12 "Robbery"


**** TOBACCO, ALCOHOL, DRUGS
lab var a_aa13 "Tobacco"
lab var a_aa14 "Binge drinking"
lab var a_aa15 "Marijuana"
lab var a_aa16 "Other drugs"



*** SUMMARY STATS

egen risky_behavior= rowtotal(a_aa6 a_aa11 a_aa12 a_aa13 a_aa14 a_aa15 a_aa16)
lab var risky_behavior "Risky behavior"
gen dum_risky=0
replace dum_risky=1 if risky_b>0 & risky~=.

rename a_aa6 unprotected_sex
rename a_aa11 weapon
rename a_aa12 robbery
rename a_aa13 tobacco
rename a_aa14 alcohol
rename a_aa15 marijuana
rename a_aa16 other_drugs


***


/** 2. COVARIATES */


** Expected wages

egen salario_esp=rowmean(salario_esp_cd salario_esp_e)
lab var salario_esp "Expected higher education wage"
gen dsalario_esp_1=salario_esp_b-salario_esp_a
lab var dsalario_esp_1 "Implied perceived returns for secondary"
gen dsalario_esp_2=salario_esp_cd-salario_esp_b
lab var dsalario_esp_2 "Implied perceived returns for technical"
gen dsalario_esp_3=salario_esp_e-salario_esp_a
lab var dsalario_esp_3 "Implied perceived returns for university"
gen lnsalario=ln(salario_esp_e/salario_esp_b)
ren lnsalario expected_return
lab var expected_return "Expected return to a college education"



** Aspirations (pregunta c31)
gen aspira_y=0
replace aspira_y=0 if exp_educ==1
replace aspira_y=8 if exp_educ==2
replace aspira_y=12 if exp_educ==3
replace aspira_y=14 if exp_educ==4
replace aspira_y=17 if exp_educ==5
replace aspira_y=19 if exp_educ==6
replace aspira_y=. if exp_educ==7




gen aspirations=aspira_y-aeduc
replace aspirations=0 if aspirations<0
replace aspirations=0 if aspirations>=1 &  aspirations<.  & exp_educ_cond==1
replace aspirations=1 if aspirations==0 & exp_educ_cond>=2 & exp_educ_cond<.
label var aspirations "Educational aspirations"


* Socio emotional skills
drop z_locus
qui sum locus_full_index if edad<=19,d
gen z_locus=(locus_full_index-r(mean))/r(sd) if edad<=19
lab var z_locus "Locus of control score"


qui sum rosenb if edad<=19, d
gen z_rosen=(rosen-r(mean))/r(sd) if edad<=19
lab var	z_rosen "Rosenberg score"

qui sum gse_prom if edad<=19, d
gen z_gse=(gse_prom-r(mean))/r(sd) if edad<=19
lab var	z_gse "Self-efficacy score"



* Cognitive skills: numeracy 
qui sum numeracy if edad<=19,d
gen z_numeracy=(numeracy-r(mean))/r(sd) if edad<=19
lab var z_numeracy "Numeracy skills"


/* Preferences */

gen risk_averse=0
replace risk_averse=1 if f106==0 & f105==0 & f104==0
lab var risk_averse "Risk averse"


ren dcto_a short_term_discount
lab var short_t "Short term discount rate"
ren dcto_b2 long_term_discount
lab var long_term "Long term discount rate"
gen time_inconsistent=0
replace time_inconsistent=1 if short_t>long_term 
lab var time_i "Time inconsistent"
gen dif_discount=short_t-long_t
lab var dif_disc "Discount difference"

/* Shocks */

gen jobloss=0
replace jobloss=1 if h115_a==1
lab var jobloss "Job loss youth"
gen divorce=0
replace divorce=1 if h115_e==1
lab var divorce "Parental separation"
gen health_youth=0
replace health_youth=1 if h115_g==1
lab var health_y "Health shock youth"
gen health_family=0
replace health_family=1 if h115_h==1
lab var health_f "Health or death in family"
gen crime=0
replace crime=1 if h115_i==1
lab var crime "Crime victim"
gen natural_disaster=0
replace natural_disaster=1 if h115_k==1
lab var natural_d "Natural disaster"
gen shocks=jobloss+divorce+health_y+health_f+crime+natural_d
gen individual_shocks=jobloss+divorce+health_y+health_f+crime
lab var shocks "Number of economic shocks (0-6)"
lab var individual_shocks "Number of economic shocks (0-5)"

*/

/* Labor market */

*work
gen employedtoday=.
replace employedtoday=1 if a11<=8 & a11~=.
replace employedtoday=0 if a11==9 

gen everemployed=(d38==1)
replace everemployed=. if d38==.


/* Labels */


lab var edad "Age"
lab var hombre "Male"
lab var aeduc "Years of education"
lab var embarazo_adolescente "Teenage parenthood"
lab var miembros_0_5 "Household members under 5 years"
lab var miembros_65 "Household members over 65 years"
replace yhogar_pc=yhogar_pc/1000
lab var yhogar_pc "Income per capita (thousand pesos)"


compress





*summ unprotected weapon robber tobacco alcohol mari other risky_behavior edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return risk_a short_t long_t jobloss divorce health_y health_f crime natural_d shocks if edad<=19


//**SAMPLE & RESULTS

count if edad<=19

*regress individual_shocks prom_mate2m_rbd edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region if edad<=19 [pw=factor] , r
regress individual_shocks tasa* edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region if edad<=19 [pw=factor] , r

gen teenagesample=e(sample)

regress employedtoday [pw=factor] if teenagesample==1
regress everemployed [pw=factor] if teenagesample==1



graph bar unprotected weapon robber tobacco alcohol mari other  if e(sample)==1 [pw=factor], title("Prevalence of risky behaviors") ytitle("Fraction of respondents") legend( label(1 "Unprotected sex") label(2 "Weapon") label (3 "Robbery") label (4 "Tobacco") label (5 "Binge drinking") label (6 "Marijuana") label (7 "Other drugs") rows(2) size(small))
graph save "$figures\prevalence", asis replace

graph bar jobloss divorce health_y health_f crime if e(sample)==1 [pw=factor], title("Prevalence of shocks") ytitle("Fraction of respondents") legend( label(1 "Job loss youth") label(2 "Parental divorce") label (3 "Health shock youth") label (4 "Health/death family") label (5 "Crime victim") label (6 "Natural disaster") rows(2) size(small))
graph save "$figures\shocks", asis replace





**** REGRESSION ANALYSIS

***** Poisson OLS

poisson risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d individual_shocks i.region if teenagesample==1 [pw=factor], r
*outreg2 using "$results\aggshocks_conference.xls", replace excel ctitle(Risky behavior) label dec(3)



local vars "unprotected weapon robber tobacco alcohol mari other"
foreach v of local vars {
regress `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d individual_shocks i.region if teenagesample==1 [pw=factor], r
*outreg2 using "$results\aggshocks_conference.xls", append excel ctitle(`v') label dec(3)
}


poisson risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d jobloss divorce health_y health_f crime i.region if teenagesample==1 [pw=factor], r
*outreg2 using "$results\disaggshocks_conference.xls", replace excel ctitle(Risky behavior) label dec(3)
local vars "unprotected weapon robber tobacco alcohol mari other"
foreach v of local vars {
regress `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d jobloss divorce health_y health_f crime i.region if teenagesample==1 [pw=factor], r
*outreg2 using "$results\disaggshocks_conference.xls", append excel ctitle(`v') label dec(3)
}



//




***** IV


//Aggshocks
*Get F value for instruments
*regress individual_shocks prom_mate2m_rbd difgru_mate2m edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region if teenagesample==1 [pw=factor] , r
*test prom_mate2m_rbd difgru_mate2m
regress individual_shocks tasaocup tasadesocup edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region if teenagesample==1 [pw=factor] , r
test tasaocup tasadesocup
gen F_test_inst_agg=r(F)
*outreg2 using "$results\iv_firststage_aggshocks_mate2mdifgr2m_confer.xls", replace excel ctitle(Aggregate shock) 

*regress jobloss prom_mate2m_rbd difgru_mate2m edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region if teenagesample==1 [pw=factor] , r
*test prom_mate2m_rbd difgru_mate2m
regress jobloss tasaocup tasadesocup edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d i.region if teenagesample==1 [pw=factor] , r
test tasaocup tasadesocup

gen F_test_inst_jobloss=r(F)


*outreg2 using "$results\iv_firststage_aggshocks_mate2mdifgr2m_confer.xls", append excel ctitle(Job loss) 



*ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d (individual_shocks=prom_mate2m_rbd difgru_mate2m) i.region if teenagesample==1 [pw=factor], vce(robust)
*gen Hansen_pvalue_agg = 1 - chi2tail(`e(J_df)', `e(J)')

ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d (individual_shocks=tasaocup tasadesocup) i.region if teenagesample==1 [pw=factor], vce(robust)
gen Hansen_pvalue_agg = 1 - chi2tail(`e(J_df)', `e(J)')
*outreg2 using "$results\ivaggshocks_mate2mdifgr2m_confer.xls", replace excel ctitle(Risky behavior) label dec(3) addstat("Relevance: F-value",F_test_inst_agg, "Exogeneity: Hansen probability (>0.05)", Hansen_pvalue_agg) addnote("Instrumented: individual shocks, Instruments: prom_mate2m_rbd difgru_mate2m")



local vars "unprotected weapon robber tobacco alcohol mari other"
foreach v of local vars {
*ivregress 2sls `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d (individual_shocks=prom_mate2m_rbd difgru_mate2m) i.region if teenagesample==1 [pw=factor], r
ivregress 2sls `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d (individual_shocks=tasaocup tasadesocup) i.region if teenagesample==1 [pw=factor], r
*outreg2 using "$results\ivaggshocks_mate2mdifgr2m_confer.xls", append excel ctitle(`v') label dec(3)
}



// 


*ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d (jobloss=prom_mate2m_rbd difgru_mate2m) i.region if teenagesample==1 [pw=factor], vce(robust)
ivpoisson gmm risky_ edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d (jobloss=tasaocup tasadesocup) i.region if teenagesample==1 [pw=factor], vce(robust)
gen Hansen_pvalue_jl = 1 - chi2tail(`e(J_df)', `e(J)')
*outreg2 using "$results\ivjobloss_mate2mdifgr2m_confer.xls", replace excel ctitle(Risky behavior) label dec(3) addstat("Relevance: F-value",F_test_inst_jobloss, "Exogeneity: Hansen probability (>0.05)", Hansen_pvalue) addnote("Instrumented: job loss, Instruments: prom_mate2m_rbd difgru_mate2m")



local vars "unprotected weapon robber tobacco alcohol mari other"
foreach v of local vars {
*ivregress 2sls gmm `v'  edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d (jobloss=prom_mate2m_rbd difgru_mate2m) i.region if teenagesample==1 [pw=factor], vce(robust)
ivregress 2sls `v' edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d (jobloss=tasaocup tasadesocup) i.region if teenagesample==1 [pw=factor], vce(robust)
*outreg2 using "$results\ivjobloss_mate2mdifgr2m_confer.xls", append excel ctitle(`v') label dec(3)
}


//
STOP






cd "$results"
/** DESCRIPTIVE STATISTICS */
local variables risky unprotected_sex weapon robbery tobacco alcohol marijuana other_d edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d individual_shocks jobloss divorce health_y health_f crime prom_lect2m_rbd prom_mate2m_rbd
asdoc sum `variables' [aw=factor] if teenagesample==1, stat(mean sd) save(descriptiveconference.doc) replace dec(3) label
asdoc sum `variables' [aw=factor] if teenagesample==1 & dum_r==0, stat(mean sd) save(descriptiveconference.doc) append dec(3) label
asdoc sum `variables' [aw=factor] if teenagesample==1 & dum_r==1, stat(mean sd) save(descriptiveconference.doc) append dec(3) label

sort dum_r
foreach var in `variables' {                       
quietly asdoc ttest `var' if teenagesample==1, by(dum_r) une save(descriptiveconference.doc) append label
}




//


local variables risky unprotected_sex weapon robbery tobacco alcohol marijuana other_d edad hombre aeduc embarazo_adolescente miembros_0_5 miembros_65 yhogar_pc z_numeracy z_locus z_rosen expected_return aspirations risk_a short_t dif_d individual_shocks jobloss divorce health_y health_f crime prom_lect2m_rbd prom_mate2m_rbd
  			 
matrix drop _all
count if teenagesample==1
scalar N = r(N)
					 
foreach var in `variables' {                       
  quietly sum `var' if teenagesample==1 [aw=factor], detail 
    scalar `var'_mean   = r(mean)
  scalar `var'_sd     = r(sd)
 matrix row_`var' = (`var'_mean, `var'_sd)   
 matrix rownames row_`var' = "`var'" 
 matrix OUT = nullmat(OUT)\ row_`var'
 }

 
matrix colnames OUT = "Mean" "SD"
local rname ""
foreach var in `variables' {
local lbl : variable label `var' 
local rname `"  `rname'  "`lbl'" "'	
}	

matrix list OUT


matrix drop _all
count if teenagesample==1 & dum_r==0
scalar N = r(N)
					 
foreach var in `variables' {                       
  quietly sum `var' if teenagesample==1 & dum_r==0 [aw=factor], detail 
  scalar `var'_mean   = r(mean)
  scalar `var'_sd     = r(sd)
 matrix row_`var' = (`var'_mean, `var'_sd)   
 matrix rownames row_`var' = "`var'" 
 matrix OUT = nullmat(OUT)\ row_`var'
 }

 
matrix colnames OUT = "Mean" "SD"
local rname ""
foreach var in `variables' {
local lbl : variable label `var' 
local rname `"  `rname'  "`lbl'" "'	
}	

matrix list OUT

matrix drop _all
count if teenagesample==1 & dum_r==1
scalar N = r(N)
					 
foreach var in `variables' {                       
  quietly sum `var' if teenagesample==1 & dum_r==1 [aw=factor], detail 
  scalar `var'_mean   = r(mean)
  scalar `var'_sd     = r(sd)
 matrix row_`var' = (`var'_mean, `var'_sd)   
 matrix rownames row_`var' = "`var'" 
 matrix OUT = nullmat(OUT)\ row_`var'
 }

 
matrix colnames OUT = "Mean" "SD"
local rname ""
foreach var in `variables' {
local lbl : variable label `var' 
local rname `"  `rname'  "`lbl'" "'	
}	

matrix list OUT



STOP


