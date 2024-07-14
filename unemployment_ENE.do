clear all
use "C:\Users\andrea.repetto\Dropbox\Risky behavior\data\ENE2016\ene-2016-08-jas.dta"


keep if region==8 | region==5 | region==13


*** CREATE rate of unemployment by r_p_c (comuna)

sort r_p_c


* Población en edad de trabajar (PET)
generate mayores_15 = (edad>=15 & edad<.)
by r_p_c: egen pet=total(mayores_15)


* Fuerza de trabajo (FT)
generate fuerza_de_trabajo = inrange(cae_especifico,1,9)
by r_p_c: egen fdt=total(fuerza_de_trabajo)

* Personas ocupadas (O)
generate ocupados = inrange(cae_especifico,1,7)
by r_p_c: egen o=total(ocupados)

* Personas desocupadas (DO)
generate desocupados = inlist(cae_especifico,8,9)
by r_p_c: egen d=total(desocupados)


collapse pet fdt o d, by (r_p_c)

gen tasaocup=o/pet
gen tasadesocup=d/fdt



sort r_p_c

keep r_p_c tasadesocup tasaocup

save "C:\Users\andrea.repetto\Dropbox\Risky behavior\data\ENE2016\muniunemp", replace
