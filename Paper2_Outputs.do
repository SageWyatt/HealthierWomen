/// Data import and cleaning

use "S:\Project\HealthierWomen\Files\SageFinalFiles\RawWideFile.dta"
** ^^^this is a sibship file
gen week16antall = antall

keep mor_dalder ASCVD_T MOR_FAAR mors_alder_siste PARITET_MOR_1 mor_dalder mor_lnr MUTD3C MORS_ALDER_1 week16antall 

save "S:\Project\HealthierWomen\Files\SageFinalFiles\CVDdata.dta", replace

clear all

///

import spss BARN_lnr MOR_lnr FAAR PLUR2C PARITET_MOR FAAR SVLEN_RS PRETERM preecxx HYPERTENSJON_ALENE Z DIABETES_MELLITUS FSTART MORS_ALDER using "S:\Project\HealthierWomen\Files\SageFinalFiles\RawLongFile.sav"
** ^^ this is a cross-sectional file

drop if SVLEN_RS < 20
/// Data import and cleaning

drop if MOR_lnr == ""

order MOR_lnr
sort MOR_lnr FAAR
by MOR_lnr : generate sibs = _n
order sibs, after(MOR_lnr)
egen antall = max(sibs), by (MOR_lnr)
order antall, after(MOR_lnr)

drop if antall > 8

foreach x of varlist _all {
	rename `x' `x'_
}

reshape wide antall BARN_lnr PLUR2C PARITET_MOR FAAR SVLEN_RS PRETERM preecxx HYPERTENSJON_ALENE Z DIABETES_MELLITUS FSTART MORS_ALDER, i(MOR_lnr) j(sibs)


gen mor_lnr = MOR_lnr

joinby mor_lnr using "S:\Project\HealthierWomen\Files\SageFinalFiles\CVDdata.dta", unmatched(master)

gen antall = antall_1

drop antall_1 antall_2 antall_3 antall_4 antall_5 antall_6 antall_7 antall_8

gen Antall_barn2cx = 0
replace Antall_barn2cx = 1 if antall == 1

drop if PLUR2C_1 == 1
drop if PRETERM_1 == .

drop if PARITET_MOR_1 != 0
keep if FAAR_1 <= 2011

drop if Z_1 > 5
drop if Z_1 < -5

gen new_mas = .
replace new_mas = MORS_ALDER_1 if antall == 1
replace new_mas = MORS_ALDER_2 if antall == 2
replace new_mas = MORS_ALDER_3 if antall == 3
replace new_mas = MORS_ALDER_4 if antall == 4
replace new_mas = MORS_ALDER_5 if antall == 5
replace new_mas = MORS_ALDER_6 if antall == 6
replace new_mas = MORS_ALDER_7 if antall == 7
replace new_mas = MORS_ALDER_8 if antall == 8

replace mors_alder_siste = new_mas if mors_alder_siste == .

//// Variable generation: exposure

gen newprx_1 = 0
replace newprx_1 = 1 if (preecxx_1 == 1 | HYPERTENSJON_ALENE_1 == 1) & antall >= 1
gen newprx_2 = 0
replace newprx_2 = 1 if (preecxx_2 == 1 | HYPERTENSJON_ALENE_2 == 1) & antall >= 2
gen newprx_3 = 0
replace newprx_3 = 1 if (preecxx_3 == 1 | HYPERTENSJON_ALENE_3 == 1) & antall >= 3
gen newprx_4 = 0
replace newprx_4 = 1 if (preecxx_4 == 1 | HYPERTENSJON_ALENE_4 == 1) & antall >= 4
gen newprx_5 = 0
replace newprx_5 = 1 if (preecxx_5 == 1 | HYPERTENSJON_ALENE_5 == 1) & antall >= 5
gen newprx_6 = 0
replace newprx_6 = 1 if (preecxx_6 == 1 | HYPERTENSJON_ALENE_6 == 1) & antall >= 6
gen newprx_7 = 0
replace newprx_7 = 1 if (preecxx_7 == 1 | HYPERTENSJON_ALENE_7 == 1) & antall >= 7
gen newprx_8 = 0
replace newprx_8 = 1 if (preecxx_8 == 1 | HYPERTENSJON_ALENE_8 == 1) & antall >= 8

gen newprx_selec = 0
replace newprx_selec = 1 if newprx_1 == 1 | newprx_2 == 1 | newprx_3 == 1 | newprx_4 == 1 | newprx_5 == 1 | newprx_6 == 1 | newprx_7 == 1 | newprx_8 == 1 

gen newprx_trm_1 = 0
replace newprx_trm_1 = 1 if newprx_1 == 1 & PRETERM_1 == 0

gen newprx_prt_1 = 0
replace newprx_prt_1 = 1 if newprx_1 == 1 & PRETERM_1 == 1

/// Variable generation: covariate

gen firstbirth = 99
replace firstbirth = 0 if newprx_1 == 0 & PRETERM_1 == 0
replace firstbirth = 1 if newprx_1 == 0 & PRETERM_1 == 1
replace firstbirth = 2 if newprx_1 == 1 & PRETERM_1 == 0
replace firstbirth = 3 if newprx_1 == 1 & PRETERM_1 == 1

gen mors_alder_cat = .
replace mors_alder_cat = 1 if MORS_ALDER_1 < 20
replace mors_alder_cat = 2 if MORS_ALDER_1 >= 20 & MORS_ALDER_1 < 25
replace mors_alder_cat = 3 if MORS_ALDER_1 >= 25 & MORS_ALDER_1 < 30
replace mors_alder_cat = 4 if MORS_ALDER_1 >= 30 & MORS_ALDER_1 < 35
replace mors_alder_cat = 5 if MORS_ALDER_1 >= 35

gen faarcat = .
replace faarcat = 1979 if FAAR_1 < 1980
replace faarcat = 1989 if FAAR_1 < 1990 & FAAR_1 >= 1980
replace faarcat = 1999 if FAAR_1 < 2000 & FAAR_1 >= 1990
replace faarcat = 2011 if FAAR_1 >= 2000


/// Cause-specific risk model setup

joinby MOR_lnr using "S:\Project\HealthierWomen\Files\SageFinalFiles\EmigrationData.dta", unmatched(master)
**^^ this contains information on emigration, regstatus2020_REG

gen ascvd_sens = .
replace ascvd_sens = mor_dalder
replace ascvd_sens = 2020 - MOR_FAAR if ASCVD_T == 0

drop _merge

gen MOR_lnr = MOR_lnr_
drop MOR_lnr_

gen ASCVD_T_69yrs = ASCVD_T
replace ASCVD_T_69yrs = 0 if ascvd_sens > 69

gen ascvd_sens_69 = .
replace ascvd_sens_69 = ascvd_sens 
replace ascvd_sens_69 = 69 if ascvd_sens > 69

gen time = ascvd_sens_69 - mors_alder_siste

replace ascvd_sens_69 = age_followUpEnd if regstatus2020_REG == 3

stset ascvd_sens_69, origin(mors_alder_siste) failure(ASCVD_T_69yrs) id(mor_lnr)

/// Table 1
tab firstbirth
tab Antall_barn2cx firstbirth, col
tab mors_alder_cat firstbirth, col
tab MUTD3C firstbirth, col
tab faarcat firstbirth, col

/// Table 3

gen z2c_1 = .
replace z2c_1 = 1 if Z_1 < 0
replace z2c_1 = 2 if Z_1 >= 0

gen prx2c = Antall_barn2cx*100 + 10*firstbirth + z2c_1

stcox ib2.prx2c
stcox ib2.prx2c faarcat MUTD3C mors_alder_cat
stptime, by(prx2c)
tab prx2c

/// The Interaction

stcox ib0.newprx_1 PRETERM_1 Z_1 c.newprx_1#c.PRETERM_1#c.Z_1

stcox ib0.firstbirth c.Z_1 firstbirth#c.Z_1

/// Additional Tables

////// Medical indication for delivery

gen newfstart = 0
replace newfstart = 1 if FSTART_1 == 3
replace newfstart = 1 if FSTART_1 == 2

gen fst2c = newfstart*100 + 10*firstbirth + z2c_1

tab fst2c Antall_barn2cx, row

stcox ib2.fst2c faarcat MUTD3C mors_alder_cat

stptime, by(fst2c)


gen liv1 = 1000*Antall_barn2cx + fst2c
stcox ib2.liv1 faarcat MUTD3C mors_alder_cat
stptime, by(liv1)

////// HDP sub-stratification

gen preebirth = 99
replace preebirth = 0 if preecxx_1 == 0 & PRETERM_1 == 0
replace preebirth = 1 if preecxx_1 == 0 & PRETERM_1 == 1
replace preebirth = 2 if preecxx_1 == 1 & PRETERM_1 == 0
replace preebirth = 3 if preecxx_1 == 1 & PRETERM_1 == 1

gen pre2c = 10*preebirth + z2c_1


stcox ib2.pre2c faarcat MUTD3C mors_alder_cat
stptime, by(pre2c)


replace HYPERTENSJON_ALENE_1 = 0 if HYPERTENSJON_ALENE_1 == .

gen gesthypbirth = 99
replace gesthypbirth = 0 if HYPERTENSJON_ALENE_1 == 0 & PRETERM_1 == 0
replace gesthypbirth = 1 if HYPERTENSJON_ALENE_1 == 0 & PRETERM_1 == 1
replace gesthypbirth = 2 if HYPERTENSJON_ALENE_1 == 1 & PRETERM_1 == 0
replace gesthypbirth = 3 if HYPERTENSJON_ALENE_1 == 1 & PRETERM_1 == 1

gen ght2c = 10*gesthypbirth + z2c_1


stcox ib2.ght2c faarcat MUTD3C mors_alder_cat
stptime, by(ght2c)

/// Competing risk model setup

gen mord69 = .
replace mord69 = mor_dalder 
replace mord69 = 69 if mor_dalder > 69
replace mord69 = 2020 - MOR_FAAR if mor_dalder == .

gen event_type = 0
replace event_type = 2 if mor_dalder != . & mor_dalder <= 69
replace event_type = 1 if ASCVD_T_69yrs == 1

gen cr_time = mord69 - mors_alder_siste

drop if cr_time == .
browse cr_time prx2c mors_alder_siste mord69 event_type ascvd_sens_69
stset mord69, origin(mors_alder_siste) failure(event_type == 1) id(mor_lnr)

stcrreg ib2.prx2c faarcat MUTD3C mors_alder_siste, compete(event_type == 2)


stcrreg ib2.figexp faarcat MUTD3C new_mas, compete(event_type == 2)

/// Competing risk model outputs

stcrreg ib2.figexp faarcat MUTD3C mors_alder_cat, compete(event_type == 2)
stptime, by(figexp)

stcrreg ib2.prx2c faarcat MUTD3C mors_alder_cat, compete(event_type == 2)
stptime, by(prx2c)

stcrreg ib0.newprx_1 PRETERM_1 Z_1 c.newprx_1#c.PRETERM_1#c.Z_1, compete(event_type == 2)

stcrreg ib2.fst2c faarcat MUTD3C mors_alder_cat, compete(event_type == 2)
stptime, by(fst2c)

stcrreg ib2.pre2c faarcat MUTD3C mors_alder_cat, compete(event_type == 2)
stptime, by(pre2c)

stcrreg ib2.ght2c faarcat MUTD3C mors_alder_cat, compete(event_type == 2)
stptime, by(ght2c)

/// Export to R for Graphs

keep mor_lnr SVLEN_RS_1 PRETERM_1 newprx_1 Z_1 ASCVD_T_69yrs ascvd_sens_69 FAAR_1 MORS_ALDER_1 MUTD3C firstbirth Antall_barn2cx cr_time event_type mord69

save "S:\Project\HealthierWomen\Files\SageFinalFiles\Paper2CleanFile.dta", replace

clear all


