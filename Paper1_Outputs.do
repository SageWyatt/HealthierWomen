/// Data import and cleaning

use "S:\Project\HealthierWomen\Files\SageFinalFiles\Paper1RawWide.dta"
** ^^^this is a sibship file
gen week16antall = antall

keep mor_dalder ASCVD_T MOR_FAAR mors_alder_siste PARITET_MOR_1 mor_dalder mor_lnr MUTD3C MORS_ALDER_1 week16antall 

save "S:\Project\HealthierWomen\Files\SageFinalFiles\CVDdata.dta", replace

clear all

////

import spss BARN_lnr MOR_lnr FAAR PLUR2C preecxx HYPERTENSJON_ALENE SVLEN_RS PRETERM FSTART ABRUPTIOP sga_10 DIABETES_SVSK PDOD EKLAMPSI HELLP FDATO SVLEN_DG PREEKL HYPERTENSJON_KRONISK DIABETES_MELLITUS using "S:\Project\HealthierWomen\Files\SageFinalFiles\Paper1RawLong.sav"
** ^^^this is a cross-sectional file

drop if SVLEN_RS < 20
drop if MOR_lnr == ""
 
order MOR_lnr
sort MOR_lnr FAAR
by MOR_lnr : generate sibs = _n
order sibs, after(MOR_lnr)
egen antall = max(sibs), by (MOR_lnr)
order antall, after(MOR_lnr)

drop if antall > 8

reshape wide BARN_lnr FAAR PLUR2C preecxx HYPERTENSJON_ALENE SVLEN_RS antall PRETERM FSTART ABRUPTIOP sga_10 DIABETES_SVSK PDOD EKLAMPSI HELLP FDATO SVLEN_DG PREEKL HYPERTENSJON_KRONISK DIABETES_MELLITUS, i(MOR_lnr) j(sibs)

////

gen mor_lnr = MOR_lnr

joinby mor_lnr using "S:\Project\HealthierWomen\Files\SageFinalFiles\CVDdata.dta", unmatched(master)

drop antall3
	gen antall3 = antall1
	replace antall3 = 3 if antall1 > 3
	
		gen week16antall3 = week16antall
	replace week16antall3 = 3 if week16antall > 3
	
	tab antall3 week16antall3, m

/// Variable generation for main results

gen comp_selec = 0
replace comp_selec = 1 if ABRUPTIOP1 == 1 | ABRUPTIOP2 == 1 | ABRUPTIOP3 == 1 | ABRUPTIOP4 == 1 | ABRUPTIOP5 == 1 | ABRUPTIOP6 == 1 | ABRUPTIOP7 == 1 | ABRUPTIOP8 == 1 | sga_101 == 1 | sga_102 == 1 | sga_103 == 1 | sga_104 == 1 | sga_105 == 1 | sga_106 == 1 | sga_107 == 1 | sga_108 == 1 | DIABETES_SVSK1 == 1 | DIABETES_SVSK2 == 1 | DIABETES_SVSK3 == 1 | DIABETES_SVSK4 == 1 | DIABETES_SVSK5 == 1 | DIABETES_SVSK6 == 1 | DIABETES_SVSK7 == 1 | DIABETES_SVSK8 == 1 | PDOD1 == 1 | PDOD2 == 1 | PDOD3 == 1 | PDOD4 == 1 | PDOD5 == 1 | PDOD6 == 1 | PDOD7 == 1 | PDOD8 == 1

gen PRETERM_selec = 0
replace PRETERM_selec = 1 if PRETERM1 == 1 | PRETERM2 == 1 | PRETERM3 == 1 | PRETERM4 == 1 | PRETERM5 == 1 | PRETERM6 == 1 | PRETERM7 == 1 | PRETERM8 == 1

tab antall3 week16antall3

drop antall3 week16antall3

////

drop if PLUR2C1 == 1
drop if PLUR2C2 == 1
drop if PLUR2C3 == 1
drop if PLUR2C4 == 1
drop if PLUR2C5 == 1
drop if PLUR2C6 == 1
drop if PLUR2C7 == 1
drop if PLUR2C8 == 1

/////

drop if PARITET_MOR_1 != 0
drop if FAAR1 > 2013

drop if PRETERM1 == .
drop if PRETERM2 == . & antall1 > 1

////




gen ascvd_sens = .
replace ascvd_sens = mor_dalder if ASCVD_T == 1
replace ascvd_sens = 2020 - MOR_FAAR if ASCVD_T == 0

gen ASCVD_T_69yrs = ASCVD_T
replace ASCVD_T_69yrs = 0 if ascvd_sens > 69

gen ascvd_sens_69 = .
replace ascvd_sens_69 = ascvd_sens 
replace ascvd_sens_69 = 69 if ascvd_sens > 69

stset ascvd_sens_69, origin(mors_alder_siste) failure(ASCVD_T_69yrs) id(mor_lnr)


////

drop antall2 antall4 antall5 antall6 antall7 antall8

gen newprx1 = 0
replace newprx1 = 1 if (preecxx1 == 1 | HYPERTENSJON_ALENE1 == 1) & antall >= 1
gen newprx2 = 0
replace newprx2 = 1 if (preecxx2 == 1 | HYPERTENSJON_ALENE2 == 1) & antall >= 2
gen newprx3 = 0
replace newprx3 = 1 if (preecxx3 == 1 | HYPERTENSJON_ALENE3 == 1) & antall >= 3
gen newprx4 = 0
replace newprx4 = 1 if (preecxx4 == 1 | HYPERTENSJON_ALENE4 == 1) & antall >= 4
gen newprx5 = 0
replace newprx5 = 1 if (preecxx5 == 1 | HYPERTENSJON_ALENE5 == 1) & antall >= 5
gen newprx6 = 0
replace newprx6 = 1 if (preecxx6 == 1 | HYPERTENSJON_ALENE6 == 1) & antall >= 6
gen newprx7 = 0
replace newprx7 = 1 if (preecxx7 == 1 | HYPERTENSJON_ALENE7 == 1) & antall >= 7
gen newprx8 = 0
replace newprx8 = 1 if (preecxx8 == 1 | HYPERTENSJON_ALENE8 == 1) & antall >= 8

gen newprx_selec = 0
replace newprx_selec = 1 if newprx1 == 1 | newprx2 == 1 | newprx3 == 1 | newprx4 == 1 | newprx5 == 1 | newprx6 == 1 | newprx7 == 1 | newprx8 == 1

gen prxafter1stH = 0
replace prxafter1stH = 1 if (newprx2 == 1) & antall == 2
replace prxafter1stH = 1 if (newprx2 == 1 | newprx3 == 1) & antall == 3
replace prxafter1stH = 1 if (newprx2 == 1 | newprx3 == 1 | newprx4 == 1) & antall == 4
replace prxafter1stH = 1 if (newprx2 == 1 | newprx3 == 1 | newprx4 == 1 | newprx5 == 1) & antall == 5
replace prxafter1stH = 1 if (newprx2 == 1 | newprx3 == 1 | newprx4 == 1 | newprx5 == 1 | newprx6 == 1) & antall == 6
replace prxafter1stH = 1 if (newprx2 == 1 | newprx3 == 1 | newprx4 == 1 | newprx5 == 1 | newprx6 == 1 | newprx7 == 1) & antall == 7
replace prxafter1stH = 1 if (newprx2 == 1 | newprx3 == 1 | newprx4 == 1 | newprx5 == 1 | newprx6 == 1 | newprx7 == 1 | newprx8 == 1) & antall == 8

gen prxafter2ndH = 0
replace prxafter2ndH = 1 if (newprx3 == 1) & antall == 3
replace prxafter2ndH = 1 if (newprx3 == 1 | newprx4 == 1) & antall == 4
replace prxafter2ndH = 1 if (newprx3 == 1 | newprx4 == 1 | newprx5 == 1) & antall == 5
replace prxafter2ndH = 1 if (newprx3 == 1 | newprx4 == 1 | newprx5 == 1 | newprx6 == 1) & antall == 6
replace prxafter2ndH = 1 if (newprx3 == 1 | newprx4 == 1 | newprx5 == 1 | newprx6 == 1 | newprx7 == 1) & antall == 7
replace prxafter2ndH = 1 if (newprx3 == 1 | newprx4 == 1 | newprx5 == 1 | newprx6 == 1 | newprx7 == 1 | newprx8 == 1) & antall == 8

gen prxgest_1 = .
replace prxgest_1 = 0 if newprx1 == 0
replace prxgest_1 = 1 if newprx1 == 1 & PRETERM1 == 0
replace prxgest_1 = 2 if newprx1 == 1 & PRETERM1 == 1

gen prxgest_2 = .
replace prxgest_2 = 0 if newprx2 == 0
replace prxgest_2 = 1 if newprx2 == 1 & PRETERM2 == 0
replace prxgest_2 = 2 if newprx2 == 1 & PRETERM2 == 1


gen faar_siste = .
replace faar_siste = FAAR1 if antall == 1
replace faar_siste = FAAR2 if antall == 2
replace faar_siste = FAAR3 if antall == 3
replace faar_siste = FAAR4 if antall == 4
replace faar_siste = FAAR5 if antall == 5
replace faar_siste = FAAR6 if antall == 6
replace faar_siste = FAAR7 if antall == 7
replace faar_siste = FAAR8 if antall == 8


gen scen1 = prxgest_1*10 + prxgest_2

gen scen2 = scen1*10 + prxafter2ndH

gen frh = .
replace frh = 30 + prxgest_1 if antall == 1
replace frh = 300 + scen1 if antall == 2
replace frh = 3000 + scen2 if antall > 2

gen liv = 2
replace liv = 0 if frh == 30 | frh == 300 | frh == 3000
replace liv = 1 if frh == 310 | frh == 3100
replace liv = 3 if frh == 322 | frh == 3220 | frh == 3221


///// Variable generation for supplementary results

gen newpree_1 = 0
replace newpree_1 = 1 if (PREEKL1 != .)
gen newpree_2 = 0
replace newpree_2 = 1 if (PREEKL2 != .) & antall >= 2
gen newpree_3 = 0
replace newpree_3 = 1 if (PREEKL3 != .) & antall >= 3
gen newpree_4 = 0
replace newpree_4 = 1 if (PREEKL4 != .) & antall >= 4
gen newpree_5 = 0
replace newpree_5 = 1 if (PREEKL5 != .) & antall >= 5
gen newpree_6 = 0
replace newpree_6 = 1 if (PREEKL6 != .) & antall >= 6
gen newpree_7 = 0
replace newpree_7 = 1 if (PREEKL7 != .) & antall >= 7
gen newpree_8 = 0
replace newpree_8 = 1 if (PREEKL8 != .) & antall >= 8

gen newpree_selec = 0
replace newpree_selec = 1 if newpree_1 == 1 | newpree_2 == 1 | newpree_3 == 1 | newpree_4 == 1 | newpree_5 == 1 | newpree_6 == 1 | newpree_7 == 1 | newpree_8 == 1

gen pree_after_1stH = 0
replace pree_after_1stH = 1 if (newpree_2 == 1) & antall == 2
replace pree_after_1stH = 1 if (newpree_2 == 1 | newpree_3 == 1) & antall == 3
replace pree_after_1stH = 1 if (newpree_2 == 1 | newpree_3 == 1 | newpree_4 == 1) & antall == 4
replace pree_after_1stH = 1 if (newpree_2 == 1 | newpree_3 == 1 | newpree_4 == 1 | newpree_5 == 1) & antall == 5
replace pree_after_1stH = 1 if (newpree_2 == 1 | newpree_3 == 1 | newpree_4 == 1 | newpree_5 == 1 | newpree_6 == 1) & antall == 6
replace pree_after_1stH = 1 if (newpree_2 == 1 | newpree_3 == 1 | newpree_4 == 1 | newpree_5 == 1 | newpree_6 == 1 | newpree_7 == 1) & antall == 7
replace pree_after_1stH = 1 if (newpree_2 == 1 | newpree_3 == 1 | newpree_4 == 1 | newpree_5 == 1 | newpree_6 == 1 | newpree_7 == 1 | newpree_8 == 1) & antall == 8

gen ekl_1 = 0
replace ekl_1 = 1 if (EKLAMPSI1 == 1 | HELLP1 == 1) & antall >= 1
gen ekl_2 = 0
replace ekl_2 = 1 if (EKLAMPSI2 == 1 | HELLP2 == 1) & antall >= 2
gen ekl_3 = 0
replace ekl_3 = 1 if (EKLAMPSI3 == 1 | HELLP3 == 1) & antall >= 3
gen ekl_4 = 0
replace ekl_4 = 1 if (EKLAMPSI4 == 1 | HELLP4 == 1) & antall >= 4
gen ekl_5 = 0
replace ekl_5 = 1 if (EKLAMPSI5 == 1 | HELLP5 == 1) & antall >= 5
gen ekl_6 = 0
replace ekl_6 = 1 if (EKLAMPSI6 == 1 | HELLP6 == 1) & antall >= 6
gen ekl_7 = 0
replace ekl_7 = 1 if (EKLAMPSI7 == 1 | HELLP7 == 1) & antall >= 7
gen ekl_8 = 0
replace ekl_8 = 1 if (EKLAMPSI8 == 1 | HELLP8 == 1) & antall >= 8

gen ekl_selec = 0
replace ekl_selec = 1 if ekl_1 == 1 | ekl_2 == 1 | ekl_3 == 1 | ekl_4 == 1 | ekl_5 == 1 | ekl_6 == 1 | ekl_7 == 1 | ekl_8 == 1

gen ekl_after_1stH = 0
replace ekl_after_1stH = 1 if (ekl_2 == 1) & antall == 2
replace ekl_after_1stH = 1 if (ekl_2 == 1 | ekl_3 == 1) & antall == 3
replace ekl_after_1stH = 1 if (ekl_2 == 1 | ekl_3 == 1 | ekl_4 == 1) & antall == 4
replace ekl_after_1stH = 1 if (ekl_2 == 1 | ekl_3 == 1 | ekl_4 == 1 | ekl_5 == 1) & antall == 5
replace ekl_after_1stH = 1 if (ekl_2 == 1 | ekl_3 == 1 | ekl_4 == 1 | ekl_5 == 1 | ekl_6 == 1) & antall == 6
replace ekl_after_1stH = 1 if (ekl_2 == 1 | ekl_3 == 1 | ekl_4 == 1 | ekl_5 == 1 | ekl_6 == 1 | ekl_7 == 1) & antall == 7
replace ekl_after_1stH = 1 if (ekl_2 == 1 | ekl_3 == 1 | ekl_4 == 1 | ekl_5 == 1 | ekl_6 == 1 | ekl_7 == 1 | ekl_8 == 1) & antall == 8

gen newght_1 = 0
replace newght_1 = 1 if (HYPERTENSJON_ALENE1 == 1) & antall >= 1
gen newght_2 = 0
replace newght_2 = 1 if (HYPERTENSJON_ALENE2 == 1) & antall >= 2
gen newght_3 = 0
replace newght_3 = 1 if (HYPERTENSJON_ALENE3 == 1) & antall >= 3
gen newght_4 = 0
replace newght_4 = 1 if (HYPERTENSJON_ALENE4 == 1) & antall >= 4
gen newght_5 = 0
replace newght_5 = 1 if (HYPERTENSJON_ALENE5 == 1) & antall >= 5
gen newght_6 = 0
replace newght_6 = 1 if (HYPERTENSJON_ALENE6 == 1) & antall >= 6
gen newght_7 = 0
replace newght_7 = 1 if (HYPERTENSJON_ALENE7 == 1) & antall >= 7
gen newght_8 = 0
replace newght_8 = 1 if (HYPERTENSJON_ALENE8 == 1) & antall >= 8

gen newght_selec = 0
replace newght_selec = 1 if newght_1 == 1 | newght_2 == 1 | newght_3 == 1 | newght_4 == 1 | newght_5 == 1 | newght_6 == 1 | newght_7 == 1 | newght_8 == 1

gen ght_after_1stH = 0
replace ght_after_1stH = 1 if (newght_2 == 1) & antall == 2
replace ght_after_1stH = 1 if (newght_2 == 1 | newght_3 == 1) & antall == 3
replace ght_after_1stH = 1 if (newght_2 == 1 | newght_3 == 1 | newght_4 == 1) & antall == 4
replace ght_after_1stH = 1 if (newght_2 == 1 | newght_3 == 1 | newght_4 == 1 | newght_5 == 1) & antall == 5
replace ght_after_1stH = 1 if (newght_2 == 1 | newght_3 == 1 | newght_4 == 1 | newght_5 == 1 | newght_6 == 1) & antall == 6
replace ght_after_1stH = 1 if (newght_2 == 1 | newght_3 == 1 | newght_4 == 1 | newght_5 == 1 | newght_6 == 1 | newght_7 == 1) & antall == 7
replace ght_after_1stH = 1 if (newght_2 == 1 | newght_3 == 1 | newght_4 == 1 | newght_5 == 1 | newght_6 == 1 | newght_7 == 1 | newght_8 == 1) & antall == 8

gen type = .
replace type = 0 if newprx_selec == 0
replace type = 1 if newght_1 == 1 & PRETERM1 == 0 & ght_after_1stH == 0
replace type = 2 if newpree_1 == 1 & PRETERM1 == 0 & pree_after_1stH == 0
replace type = 3 if ekl_1 == 1 & PRETERM1 == 0 & ekl_after_1stH == 0

gen FDATO_2siste = .
replace FDATO_2siste = FDATO1 if antall == 2
replace FDATO_2siste = FDATO2 if antall == 3
replace FDATO_2siste = FDATO3 if antall == 4
replace FDATO_2siste = FDATO4 if antall == 5
replace FDATO_2siste = FDATO5 if antall == 6
replace FDATO_2siste = FDATO6 if antall == 7
replace FDATO_2siste = FDATO7 if antall == 8
format FDATO_2siste %tc

gen FDATO_siste = .
replace FDATO_siste = FDATO2 if antall1 == 2
replace FDATO_siste = FDATO3 if antall1 == 3
replace FDATO_siste = FDATO4 if antall1 == 4
replace FDATO_siste = FDATO5 if antall1 == 5
replace FDATO_siste = FDATO6 if antall1 == 6
replace FDATO_siste = FDATO7 if antall1 == 7
replace FDATO_siste = FDATO8 if antall1 == 8
format FDATO_siste %tc

gen GEST_siste = .
replace GEST_siste = SVLEN_DG1 if antall1 == 1
replace GEST_siste = SVLEN_DG2 if antall1 == 2
replace GEST_siste = SVLEN_DG3 if antall1 == 3
replace GEST_siste = SVLEN_DG4 if antall1 == 4
replace GEST_siste = SVLEN_DG5 if antall1 == 5
replace GEST_siste = SVLEN_DG6 if antall1 == 6
replace GEST_siste = SVLEN_DG7 if antall1 == 7
replace GEST_siste = SVLEN_DG8 if antall1 == 8




/////

gen DIABETES_FOR2C1 = 0
replace DIABETES_FOR2C1 = 1 if DIABETES_MELLITUS1 == 1 | DIABETES_MELLITUS1 == 2

/////

drop _merge

joinby MOR_lnr using "S:\Project\HealthierWomen\Files\SageFinalFiles\EmigrationData.dta", unmatched(master)
**^^ this contains information on emigration, regstatus2020_REG

gen time = ascvd_sens_69 - mors_alder_siste


gen period5c_siste = 5
	replace period5c_siste = 1 if faar_siste < 1980
	replace period5c_siste = 2 if faar_siste < 1990 & faar_siste >= 1980
	replace period5c_siste = 3 if faar_siste < 2000 & faar_siste >= 1990
	replace period5c_siste = 4 if faar_siste < 2013 & faar_siste >= 2000
	
gen period5c_1 = 5
	replace period5c_1 = 1 if FAAR1 < 1980
	replace period5c_1 = 2 if FAAR1 < 1990 & FAAR1 >= 1980
	replace period5c_1 = 3 if FAAR1 < 2000 & FAAR1 >= 1990
	replace period5c_1 = 4 if FAAR1 < 2014 & FAAR1 >= 2000
	
	
	gen mors_alder_cat = .
	replace mors_alder_cat = 1 if MORS_ALDER_1 < 20
	replace mors_alder_cat = 2 if MORS_ALDER_1 >= 20 & MORS_ALDER_1 < 30
	replace mors_alder_cat = 3 if MORS_ALDER_1 >= 30 

	gen antall3 = antall1
	replace antall3 = 3 if antall1 > 3

replace ascvd_sens_69 = age_followUpEnd if regstatus2020_REG == 3

/// Export file to R for main results

keep mor_lnr prxgest_1 scen1 scen2 time period5c_siste mors_alder_cat MUTD3C antall3 ASCVD_T_69yrs FSTART1 FSTART2 FSTART3 FSTART4 FSTART5 FSTART6 FSTART7 FSTART8 comp_selec newprx_selec PRETERM_selec liv type PRETERM1 PRETERM2 GEST_siste FDATO_siste FDATO_2siste HYPERTENSJON_KRONISK1 DIABETES_FOR2C1

save "S:\Project\HealthierWomen\Files\SageFinalFiles\Paper1CleanFile.dta", replace

clear all

