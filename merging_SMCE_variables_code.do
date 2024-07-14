
clear all

///////////////////MERGE FINAL SMCE SCHOOLS MATCHES WITH CHILE DATA
import delimited "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\chile_school_comparison_final.csv", clear
merge 1:1 idencuesta using "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile.dta"
drop _merge c27_norm_final c27_norm_gen c27_norm_gen_num c27_norm_reg c27_norm_reg_num v1
order c27_est, after(c27_com)
order c27_final, after(c27_est)
order rbd, after(c27_final)
save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace



////////////////////////////////FIRST ROUND: COMBINE SMCE 4B SCHOOL DATA

use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"

// Open the second dataset
use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\Simce 2017\Simce 4° Basico 2017\Archivos DTA (Stata)\simce4b2017_rbd_publica_final.dta", clear
ds

// Merge the datasets using the rbd variable
merge 1:m rbd using "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"
drop _merge nom_rbd cod_reg_rbd nalu_lect4b_rbd  grado nom_reg_rbd cod_depe1  nalu_mate4b_rbd  cod_pro_rbd dvrbd nom_pro_rbd  cod_com_rbd   cod_rural_rbd palu_eda_ins_lect4b_rbd palu_eda_ele_lect4b_rbd palu_eda_ade_lect4b_rbd palu_eda_ins_mate4b_rbd palu_eda_ele_mate4b_rbd palu_eda_ade_mate4b_rbd


rename agno agno4b
rename cod_depe2 cod_depe2_4b
rename nom_com_rbd nom_com_rbd4b
rename noaplica noaplica4b
rename cod_grupo cod_grupo4b   

// Create dummies for the cod_grupo4b variable
tabulate cod_grupo4b, generate(cod_grupo4b_dummy)
label variable cod_grupo4b_dummy1 "Dummy for cod_grupo4b bajo"
label variable cod_grupo4b_dummy2 "Dummy for cod_grupo4b medio bajo"
label variable cod_grupo4b_dummy3 "Dummy for cod_grupo4b medio"
label variable cod_grupo4b_dummy4 "Dummy for cod_grupo4b alto medio"
label variable cod_grupo4b_dummy5 "Dummy for cod_grupo4b alto"
order cod_grupo4b_dummy1 cod_grupo4b_dummy2 cod_grupo4b_dummy3 cod_grupo4b_dummy4 cod_grupo4b_dummy5, after(cod_grupo4b)

//Create dummies for sigdif_lect4b_rbd variable
tabulate sigdif_lect4b_rbd, generate(sigdif_lect4b_rbd_dummy)
label variable sigdif_lect4b_rbd_dummy1 "Dummy for sigdif_lect4b_rbd Diferencia negativa y estadísticamente significativa"
label variable sigdif_lect4b_rbd_dummy2 "Dummy for sigdif_lect4b_rbd Diferencia estadísticamente NO significativa"
label variable sigdif_lect4b_rbd_dummy3 "Dummy for sigdif_lect4b_rbd Diferencia positiva y estadísticamente significativa"
order sigdif_lect4b_rbd_dummy1 sigdif_lect4b_rbd_dummy2 sigdif_lect4b_rbd_dummy3, after(sigdif_lect4b_rbd)

//Create dummies for sigdif_mate4b_rbd variable
tabulate sigdif_mate4b_rbd, generate(sigdif_mate4b_rbd_dummy)
label variable sigdif_mate4b_rbd_dummy1 "Dummy for sigdif_mate4b_rbd Diferencia negativa y estadísticamente significativa"
label variable sigdif_mate4b_rbd_dummy2 "Dummy for sigdif_mate4b_rbd Diferencia estadísticamente NO significativa"
label variable sigdif_mate4b_rbd_dummy3 "Dummy for sigdif_mate4b_rbd Diferencia positiva y estadísticamente significativa"
order sigdif_mate4b_rbd_dummy1 sigdif_mate4b_rbd_dummy2 sigdif_mate4b_rbd_dummy3, after(sigdif_mate4b_rbd)

//Create dummies for siggru_lect4b_rbd variable
tabulate siggru_lect4b_rbd, generate(siggru_lect4b_rbd_dummy)
label variable siggru_lect4b_rbd_dummy1 "Dummy for siggru_lect4b_rbd Diferencia negativa y estadísticamente significativa"
label variable siggru_lect4b_rbd_dummy2 "Dummy for siggru_lect4b_rbd Diferencia estadísticamente NO significativa"
label variable siggru_lect4b_rbd_dummy3 "Dummy for siggru_lect4b_rbd Diferencia positiva y estadísticamente significativa"
order siggru_lect4b_rbd_dummy1 siggru_lect4b_rbd_dummy2 siggru_lect4b_rbd_dummy3, after(siggru_lect4b_rbd)

//Create dummies for siggru_mate4b_rbd variable
tabulate siggru_mate4b_rbd, generate(siggru_mate4b_rbd_dummy)
label variable siggru_mate4b_rbd_dummy1 "Dummy for siggru_mate4b_rbd Diferencia negativa y estadísticamente significativa"
label variable siggru_mate4b_rbd_dummy2 "Dummy for siggru_mate4b_rbd Diferencia estadísticamente NO significativa"
label variable siggru_mate4b_rbd_dummy3 "Dummy for siggru_mate4b_rbd Diferencia positiva y estadísticamente significativa"
order siggru_mate4b_rbd_dummy1 siggru_mate4b_rbd_dummy2 siggru_mate4b_rbd_dummy3, after(siggru_mate4b_rbd)


sort idencuesta

save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace




///////////////////////////////////SECOND ROUND WITH 8B

// Repeat the process, merging with 8b
use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"

// Open the second dataset
use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\Simce 2017\Simce 8° Basico 2017\Archivos DTA (Stata)\simce8b2017_rbd_publica_final.dta", clear


// // Merge the datasets using the rbd variable
merge 1:m rbd using "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"
drop _merge dvrbd nom_rbd nom_pro_rbd   nalu_nat8b_rbd siggru_nat8b_rbd  fecha_bbdd  cod_com_rbd  dif_nat8b_rbd  marcadif_nat8b_rbd cod_reg_rbd cod_rural_rbd      sigdif_nat8b_rbd grado  nom_reg_rbd  nom_deprov_rbd  nalu_lect8b_rbd  prom_nat8b_rbd marca_nat8b_rbd cod_pro_rbd cod_depe1 nalu_mate8b_rbd difgru_nat8b_rbd

rename agno agno8b
rename codigo_bbdd codigo_bbdd8b
rename cod_depe2 cod_depe2_8b
rename nom_com_rbd nom_com_rbd8b
rename noaplica noaplica8b
rename cod_grupo cod_grupo8b    


// Create dummies for the cod_grupo8b variable
tabulate cod_grupo8b, generate(cod_grupo8b_dummy)
label variable cod_grupo8b_dummy1 "Dummy for cod_grupo8b bajo"
label variable cod_grupo8b_dummy2 "Dummy for cod_grupo8b medio bajo"
label variable cod_grupo8b_dummy3 "Dummy for cod_grupo8b medio"
label variable cod_grupo8b_dummy4 "Dummy for cod_grupo8b alto medio"
label variable cod_grupo8b_dummy5 "Dummy for cod_grupo8b alto"
order cod_grupo8b_dummy1 cod_grupo8b_dummy2 cod_grupo8b_dummy3 cod_grupo8b_dummy4 cod_grupo8b_dummy5, after(cod_grupo8b)

//Create dummies for sigdif_lect8b_rbd variable
tabulate sigdif_lect8b_rbd, generate(sigdif_lect8b_rbd_dummy)
label variable sigdif_lect8b_rbd_dummy1 "Dummy for sigdif_lect8b_rbd Diferencia negativa y estadísticamente significativa"
label variable sigdif_lect8b_rbd_dummy2 "Dummy for sigdif_lect8b_rbd Diferencia estadísticamente NO significativa"
label variable sigdif_lect8b_rbd_dummy3 "Dummy for sigdif_lect8b_rbd Diferencia positiva y estadísticamente significativa"
order sigdif_lect8b_rbd_dummy1 sigdif_lect8b_rbd_dummy2 sigdif_lect8b_rbd_dummy3, after(sigdif_lect8b_rbd)

//Create dummies for sigdif_mate8b_rbd variable
tabulate sigdif_mate8b_rbd, generate(sigdif_mate8b_rbd_dummy)
label variable sigdif_mate8b_rbd_dummy1 "Dummy for sigdif_mate8b_rbd Diferencia negativa y estadísticamente significativa"
label variable sigdif_mate8b_rbd_dummy2 "Dummy for sigdif_mate8b_rbd Diferencia estadísticamente NO significativa"
label variable sigdif_mate8b_rbd_dummy3 "Dummy for sigdif_mate8b_rbd Diferencia positiva y estadísticamente significativa"
order sigdif_mate8b_rbd_dummy1 sigdif_mate8b_rbd_dummy2 sigdif_mate8b_rbd_dummy3, after(sigdif_mate8b_rbd)

//Create dummies for siggru_lect8b_rbd variable
tabulate siggru_lect8b_rbd, generate(siggru_lect8b_rbd_dummy)
label variable siggru_lect8b_rbd_dummy1 "Dummy for siggru_lect8b_rbd Diferencia negativa y estadísticamente significativa"
label variable siggru_lect8b_rbd_dummy2 "Dummy for siggru_lect8b_rbd Diferencia estadísticamente NO significativa"
label variable siggru_lect8b_rbd_dummy3 "Dummy for siggru_lect8b_rbd Diferencia positiva y estadísticamente significativa"
order siggru_lect8b_rbd_dummy1 siggru_lect8b_rbd_dummy2 siggru_lect8b_rbd_dummy3, after(siggru_lect8b_rbd)

//Create dummies for siggru_mate8b_rbd variable
tabulate siggru_mate8b_rbd, generate(siggru_mate8b_rbd_dummy)
label variable siggru_mate8b_rbd_dummy1 "Dummy for siggru_mate8b_rbd Diferencia negativa y estadísticamente significativa"
label variable siggru_mate8b_rbd_dummy2 "Dummy for siggru_mate8b_rbd Diferencia estadísticamente NO significativa"
label variable siggru_mate8b_rbd_dummy3 "Dummy for siggru_mate8b_rbd Diferencia positiva y estadísticamente significativa"
order siggru_mate8b_rbd_dummy1 siggru_mate8b_rbd_dummy2 siggru_mate8b_rbd_dummy3, after(siggru_mate8b_rbd)



sort idencuesta

save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace




// ////////////////////THIRD ROUND WITH 2M
//Load the first dataset
use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"

// Open the second dataset
use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\Simce 2017\Simce 2° Medio 2017\Archivos DTA (Stata)\simce2m2017_rbd_publica_final.dta", clear

// Merge the datasets using the rbd variable
merge 1:m rbd using "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", 


drop _merge nom_rbd nalu_lect2m_rbd nom_reg_rbd cod_depe1 fecha_bbdd cod_reg_rbd grado nom_pro_rbd dvrbd cod_com_rbd cod_pro_rbd prom_soc2m_rbd cod_rural_rbd    difgru_soc2m_rbd  siggru_soc2m_rbd  marcadif_soc2m_rbd nalu_soc2m_rbd  dif_soc2m_rbd  sigdif_soc2m_rbd  marca_soc2m_rbd nom_deprov_rbd  nalu_mate2m_rbd  palu_eda_ins_lect2m_rbd palu_eda_ele_lect2m_rbd palu_eda_ade_lect2m_rbd palu_eda_ins_mate2m_rbd palu_eda_ele_mate2m_rbd palu_eda_ade_mate2m_rbd

rename agno agno2m
rename codigo_bbdd codigo_bbdd2m
rename cod_depe2 cod_depe2_2m
rename nom_com_rbd nom_com_rbd2m
rename noaplica noaplica2m
rename cod_grupo cod_grupo2m  


// Create dummies for the cod_grupo2m variable
tabulate cod_grupo2m, generate(cod_grupo2m_dummy)
label variable cod_grupo2m_dummy1 "Dummy for cod_grupo2m bajo"
label variable cod_grupo2m_dummy2 "Dummy for cod_grupo2m medio bajo"
label variable cod_grupo2m_dummy3 "Dummy for cod_grupo2m medio"
label variable cod_grupo2m_dummy4 "Dummy for cod_grupo2m alto medio"
label variable cod_grupo2m_dummy5 "Dummy for cod_grupo2m alto"
order cod_grupo2m_dummy1 cod_grupo2m_dummy2 cod_grupo2m_dummy3 cod_grupo2m_dummy4 cod_grupo2m_dummy5, after(cod_grupo2m)

//Create dummies for sigdif_lect2m_rbd variable
tabulate sigdif_lect2m_rbd, generate(sigdif_lect2m_rbd_dummy)
label variable sigdif_lect2m_rbd_dummy1 "Dummy for sigdif_lect2m_rbd Diferencia negativa y estadísticamente significativa"
label variable sigdif_lect2m_rbd_dummy2 "Dummy for sigdif_lect2m_rbd Diferencia estadísticamente NO significativa"
label variable sigdif_lect2m_rbd_dummy3 "Dummy for sigdif_lect2m_rbd Diferencia positiva y estadísticamente significativa"
order sigdif_lect2m_rbd_dummy1 sigdif_lect2m_rbd_dummy2 sigdif_lect2m_rbd_dummy3, after(sigdif_lect2m_rbd)

//Create dummies for sigdif_mate2m_rbd variable
tabulate sigdif_mate2m_rbd, generate(sigdif_mate2m_rbd_dummy)
label variable sigdif_mate2m_rbd_dummy1 "Dummy for sigdif_mate2m_rbd Diferencia negativa y estadísticamente significativa"
label variable sigdif_mate2m_rbd_dummy2 "Dummy for sigdif_mate2m_rbd Diferencia estadísticamente NO significativa"
label variable sigdif_mate2m_rbd_dummy3 "Dummy for sigdif_mate2m_rbd Diferencia positiva y estadísticamente significativa"
order sigdif_mate2m_rbd_dummy1 sigdif_mate2m_rbd_dummy2 sigdif_mate2m_rbd_dummy3, after(sigdif_mate2m_rbd)

//Create dummies for siggru_lect2m_rbd variable
tabulate siggru_lect2m_rbd, generate(siggru_lect2m_rbd_dummy)
label variable siggru_lect2m_rbd_dummy1 "Dummy for siggru_lect2m_rbd Diferencia negativa y estadísticamente significativa"
label variable siggru_lect2m_rbd_dummy2 "Dummy for siggru_lect2m_rbd Diferencia estadísticamente NO significativa"
label variable siggru_lect2m_rbd_dummy3 "Dummy for siggru_lect2m_rbd Diferencia positiva y estadísticamente significativa"
order siggru_lect2m_rbd_dummy1 siggru_lect2m_rbd_dummy2 siggru_lect2m_rbd_dummy3, after(siggru_lect2m_rbd)

//Create dummies for siggru_mate2m_rbd variable
tabulate siggru_mate2m_rbd, generate(siggru_mate2m_rbd_dummy)
label variable siggru_mate2m_rbd_dummy1 "Dummy for siggru_mate2m_rbd Diferencia negativa y estadísticamente significativa"
label variable siggru_mate2m_rbd_dummy2 "Dummy for siggru_mate2m_rbd Diferencia estadísticamente NO significativa"
label variable siggru_mate2m_rbd_dummy3 "Dummy for siggru_mate2m_rbd Diferencia positiva y estadísticamente significativa"
order siggru_mate2m_rbd_dummy1 siggru_mate2m_rbd_dummy2 siggru_mate2m_rbd_dummy3, after(siggru_mate2m_rbd)





sort idencuesta

save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace



///////////////////CLEANING AND CHECKING
///Combining agno, cod_depe2, nom_com_rbd, and codigo_bbdd
egen agno = rowfirst(agno4b agno2m agno8b)
egen cod_depe2 = rowfirst(cod_depe2_2m cod_depe2_4b cod_depe2_8b)

//Create dummies for the cod_depe2 variable 
tabulate cod_depe2, generate(cod_depe2_dummy)
label variable cod_depe2_dummy1 "Dummy for cod_depe2 municipal"
label variable cod_depe2_dummy2 "Dummy for cod_depe2 particular subvencionado"
label variable cod_depe2_dummy3 "Dummy for cod_depe2 particular pagado"
order cod_depe2_dummy1 cod_depe2_dummy2 cod_depe2_dummy3, after(cod_depe2)



* Create an empty string variable nom_com_rbd
gen nom_com_rbd = ""

//Loop through the data
forvalues i = 1/`=_N' {
    * Check nom_com_rbd2m
    if !missing(nom_com_rbd2m[`i']) & missing(nom_com_rbd[`i']) {
        replace nom_com_rbd = nom_com_rbd2m[`i'] in `i'
    }

    * Check nom_com_rbd4b
    if !missing(nom_com_rbd4b[`i']) & missing(nom_com_rbd[`i']) {
        replace nom_com_rbd = nom_com_rbd4b[`i'] in `i'
    }

    * Check nom_com_rbd8b
    if !missing(nom_com_rbd8b[`i']) & missing(nom_com_rbd[`i']) {
        replace nom_com_rbd = nom_com_rbd8b[`i'] in `i'
    }
}

* Create an empty string variable codigo_bbdd
gen codigo_bbdd = ""

* Loop through the data
forvalues i = 1/`=_N' {
    * Check codigo_bbdd2m
    if !missing(codigo_bbdd2m[`i']) & missing(codigo_bbdd[`i']) {
        replace codigo_bbdd = codigo_bbdd2m[`i'] in `i'
    }
	  * Check codigo_bbdd8b
    if !missing(codigo_bbdd8b[`i']) & missing(codigo_bbdd[`i']) {
        replace codigo_bbdd = codigo_bbdd8b[`i'] in `i'
    }

  
}


drop agno4b agno8b agno2m codigo_bbdd2m codigo_bbdd8b cod_depe2_2m cod_depe2_4b cod_depe2_8b nom_com_rbd2m nom_com_rbd4b nom_com_rbd8b


///Fixing order of data
order c27_final, before(rbd)
order agno, after(rbd)
order codigo_bbdd, after(agno)
order cod_depe2, after(codigo_bbdd)
order nom_com_rbd, after(cod_depe2)


order c27_final  rbd  agno  codigo_bbdd  cod_depe2 cod_depe2_dummy1 cod_depe2_dummy2 cod_depe2_dummy3  nom_com_rbd  cod_grupo2m cod_grupo2m_dummy1 cod_grupo2m_dummy2 cod_grupo2m_dummy3 cod_grupo2m_dummy4 cod_grupo2m_dummy5 prom_lect2m_rbd   prom_mate2m_rbd   dif_lect2m_rbd   dif_mate2m_rbd    difgru_lect2m_rbd   difgru_mate2m_rbd   sigdif_lect2m_rbd sigdif_lect2m_rbd_dummy1 sigdif_lect2m_rbd_dummy2 sigdif_lect2m_rbd_dummy3  sigdif_mate2m_rbd  sigdif_mate2m_rbd_dummy1 sigdif_mate2m_rbd_dummy2 sigdif_mate2m_rbd_dummy3 siggru_lect2m_rbd siggru_lect2m_rbd_dummy1 siggru_lect2m_rbd_dummy2 siggru_lect2m_rbd_dummy3   siggru_mate2m_rbd siggru_mate2m_rbd_dummy1 siggru_mate2m_rbd_dummy2 siggru_mate2m_rbd_dummy3  marca_lect2m_rbd   marca_mate2m_rbd marcadif_lect2m_rbd   marcadif_mate2m_rbd   noaplica2m     cod_grupo8b cod_grupo8b_dummy1 cod_grupo8b_dummy2 cod_grupo8b_dummy3 cod_grupo8b_dummy4 cod_grupo8b_dummy5 prom_lect8b_rbd   prom_mate8b_rbd   dif_lect8b_rbd   dif_mate8b_rbd   difgru_lect8b_rbd   difgru_mate8b_rbd   sigdif_lect8b_rbd sigdif_lect8b_rbd_dummy1 sigdif_lect8b_rbd_dummy2 sigdif_lect8b_rbd_dummy3  sigdif_mate8b_rbd sigdif_mate8b_rbd_dummy1 sigdif_mate8b_rbd_dummy2 sigdif_mate8b_rbd_dummy3  siggru_lect8b_rbd siggru_lect8b_rbd_dummy1 siggru_lect8b_rbd_dummy2 siggru_lect8b_rbd_dummy3 siggru_mate8b_rbd  siggru_mate8b_rbd_dummy1 siggru_mate8b_rbd_dummy2 siggru_mate8b_rbd_dummy3 marca_lect8b_rbd marca_mate8b_rbd   marcadif_lect8b_rbd marcadif_mate8b_rbd noaplica8b  cod_grupo4b  cod_grupo4b_dummy1 cod_grupo4b_dummy2 cod_grupo4b_dummy3 cod_grupo4b_dummy4 cod_grupo4b_dummy5  prom_lect4b_rbd   prom_mate4b_rbd  dif_lect4b_rbd  dif_mate4b_rbd   difgru_mate4b_rbd difgru_lect4b_rbd  sigdif_lect4b_rbd sigdif_lect4b_rbd_dummy1 sigdif_lect4b_rbd_dummy2 sigdif_lect4b_rbd_dummy3 sigdif_mate4b_rbd sigdif_mate4b_rbd_dummy1 sigdif_mate4b_rbd_dummy2 sigdif_mate4b_rbd_dummy3 siggru_lect4b_rbd siggru_lect4b_rbd_dummy1 siggru_lect4b_rbd_dummy2 siggru_lect4b_rbd_dummy3 siggru_mate4b_rbd  siggru_mate4b_rbd_dummy1 siggru_mate4b_rbd_dummy2 siggru_mate4b_rbd_dummy3 marca_lect4b_rbd   marca_mate4b_rbd   marcadif_lect4b_rbd   marcadif_mate4b_rbd   noaplica4b, after(c27_est)     

save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace
///Get the capitalized comuna_s variable (had to do in python because stata not working, hence the merge)
use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\capital_comuna.dta", clear
merge 1:m idencuesta using "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"

drop _merge
order comuna_s_capitalized, after(comuna_s)

//Create dummy if they live in the same community as the school 
gen same_community = (comuna_s_capitalized == nom_com_rbd)

order same_community, after(nom_com_rbd)
drop if missing(idencuesta)

save "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta", replace



///CHECKING DATASET FOR MISSING RBDS
// generate difference = 0
// replace difference = 1 if missing(rbd) & !missing(c27_final)
// order difference, before(agno2m)
//
// list  c27_final if difference==1 

///CHECKING DATASET FOR MISSING NOMS
// generate difference2 = 0
// replace difference2 = 1 if missing(c27_final) & !missing(rbd) & !missing(idencuesta)
// order difference2, before(agno2m)
//
// list  c27_final if difference2==1 


//// Check if the columns are equal
// use "C:\Users\joyse\Dropbox (MIT)\Risky behavior\data\bbdd_final_Chile_cleaned.dta"
//
// list nom_rbd4b c27_final if  nom_rbd4b != c27_final & !missing(nom_rbd4b, c27_final)