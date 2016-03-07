/*
File Name	:	do_coronary.do
Created by	:	Enayetur Raheem
Position	:	Data Analyst
Date		:	Jan 20, 2012
Location	: 	\\dataserv\mydocs\eraheem\mystata\
Use			: 	Data is for analysis

PURPOSE

Calculation crude and standardized rates for hospitalization 
for Coronary Heart Disease (CHD).

Disease codes
Coronary heart disease, code = 1
Cardiovascular disease, code = 2
Hypertension, code = 3
COPD, code = 4
Asthma, code = 5
Diabetes, code = 6
Obesity, code = 7

	
*/

* Load the population data first
use pop_est2002-2010.dta, clear
preserve
keep if region==1
save pop_wec.dta, replace
restore

preserve
keep if region==2
save pop_lam.dta, replace
restore

preserve
keep if region==3
save pop_mdl.dta, replace
restore

preserve
keep if region == 4
save pop_on.dta, replace
restore


* Do some basic lists
* list cyear region pop_tot, sepby(region)

* Rate calculation begins
*Run the following do file to create the initial date set.
* Save it as tmp.dta

do do_chronic_data.do 
save tmp.dta, replace // probably no need to run this part of the code


* *********************************************		
**** CALCULATION OF HOSPITALIZATION RATES  ****
* *********************************************	

* *********************************************	
* CRUDE RATES CORONARY HEART DISEASE/ISCHEMIC HEART DISEASE
* *********************************************

 use tmp.dta, clear

forvalues outer = 1/1 {
	preserve // preservs data so that it can be restored

	forvalues dummy = 1/1 {

	display "Running for WEC"
	* keep only disease = 1 (CHD) and region = 1 (WEC)
	keep if code == 1 & region == 1
	collapse (sum) disch, by(cyear)
	merge 1:1 cyear using pop_wec.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	display "Table: Coronary Heart Disease (CHD)"
	display "Rate: Crude hospitalization rate in WEC"
	gen rate = (disch/pop_tot)*100000
	replace rate = round(rate, .01)
	save rate_chd.dta, replace
	*restore // restore the original data
	}
	
	restore
	
	* For Lambton County
	preserve
	forvalues dummy = 1/1 {
	display "Running for LAM"
	*preserve // preservs data so that it can be restored	
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region == 2 // CHD, LAM
	collapse (sum) disch, by(cyear)
	merge 1:1 cyear using pop_lam.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	display "Table: Coronary Heart Disease (CHD)"
	display "Rate: Crude hospitalization rate in LAM"
	gen rate = (disch/pop_tot)*100000
	replace rate = round(rate, .01)
	append using rate_chd.dta
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
* For Middlesex-London Health Unit
	preserve
	forvalues dummy = 1/1 {
	display "Running for MDL"
	*preserve // preservs data so that it can be restored	
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region == 3 // CHD, MDL
	collapse (sum) disch, by(cyear)
	merge 1:1 cyear using pop_mdl.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	display "Table: Coronary Heart Disease (CHD)"
	display "Rate: Crude hospitalization rate in MDL"
	gen rate = (disch/pop_tot)*100000
	replace rate = round(rate, .01)
	append using rate_chd.dta
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
	* For ON 
	preserve
	forvalues dummy = 1/1 {
	display "Running for ON"
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region > 1 // CHD, ON
	collapse (sum) disch, by(cyear)
	merge 1:1 cyear using pop_on.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	display "Table: Coronary Heart Disease (CHD)"
	display "Rate: Crude hospitalization rate in ON"
	gen rate = (disch/pop_tot)*100000
	replace rate = round(rate, .01)
	append using rate_chd.dta
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
}

use rate_chd, clear

/* create region2 variable to represent regions numerically
gen region2 = 4 
replace region2 = 1 if region =="wec"
replace region2 = 2 if region =="lam"
replace region2 = 3 if region =="mdl"

label define region_lbl 1 "wec" 2 "lam" 3 "mdl" 4 "on"
label values region2 region_lbl

drop region
rename region2 region
*/

* listing the output (run, if needed)
order cyear region rate
list cyear region disch pop_tot rate, sepby(region)

* Graph of crude rate
twoway ///
(connected rate cyear if region==1, ///
	sort lpattern(l) msymbol(D) lwidth(*1.5)) ///
	(connected rate cyear if region==2, sort) ///
	(connected rate cyear if region==3, sort) ///
	(connected rate cyear if region==4, sort) ///
	, ///
	legend(rows(1) order(1 "WEC" 2 "LAM" 3 "MDL" 4 "ON")) ///
	xsize(3) ysize(2) scale(.75) ///
	title("Total Hospitalization Rates for CHD: 2002-2010") ///
	xtitle("Calendar Year") ytitle("Hospitalizations per 100,000")



	
* *********************************************	
* *********************************************	
* SEX-SPECIFIC CRUDE HOSPITALIZATION RATES: 
* CORONARY HEART DISEASE/ISCHEMIC HEART DISEASE
* *********************************************
* *********************************************	
* Value labels *
* Male: sex2 = 1
* Female: sex2 = 2

use tmp.dta, clear

forvalues outer = 1/1 {
	preserve // preservs data so that it can be restored

	forvalues dummy = 1/1 {

	display "Running for WEC"
	* keep only disease = 1 (CHD) and region = 1 (WEC)
	keep if code == 1 & region == 1 
	collapse (sum) disch, by(cyear sex2) // collapse by cyear, sex2
	merge m:1 cyear using pop_wec.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	gen rate_m = (disch/tot_m)*100000 if sex2 == 1
	gen rate_f = (disch/tot_f)*100000 if sex2 == 2
	replace rate_m = round(rate_m, .01) 
	replace rate_f = round(rate_f, .01) 
	save rate_chd.dta, replace
	*restore // restore the original data
	}
	
	restore
	
	* For Lambton County
	preserve
	forvalues dummy = 1/1 {
	display "Running for LAM"
	*preserve // preservs data so that it can be restored	
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region == 2  // CHD, LAM
	collapse (sum) disch, by(cyear sex2) // collapse by cyear, sex2
	merge m:1 cyear using pop_lam.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	gen rate_m = (disch/tot_m)*100000 if sex2 == 1
	gen rate_f = (disch/tot_f)*100000 if sex2 == 2
	replace rate_m = round(rate_m, .01) 
	replace rate_f = round(rate_f, .01) 
	append using rate_chd.dta // append the data to existing file
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
* For Middlesex-London Health Unit
	preserve
	forvalues dummy = 1/1 {
	display "Running for MDL"
	*preserve // preservs data so that it can be restored	
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region == 3  // CHD, MDL
	collapse (sum) disch, by(cyear sex2) // collapse by cyear, sex2
	merge m:1 cyear using pop_mdl.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	gen rate_m = (disch/tot_m)*100000 if sex2 == 1
	gen rate_f = (disch/tot_f)*100000 if sex2 == 2
	replace rate_m = round(rate_m, .01) 
	replace rate_f = round(rate_f, .01) 
	append using rate_chd.dta
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
	* For ON 
	preserve
	forvalues dummy = 1/1 {
	display "Running for ON"
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region > 1 // CHD, ON
	collapse (sum) disch, by(cyear sex2) // collapse by cyear, sex2
	merge m:1 cyear using pop_on.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	gen rate_m = (disch/tot_m)*100000 if sex2 == 1
	gen rate_f = (disch/tot_f)*100000 if sex2 == 2
	replace rate_m = round(rate_m, .01) 
	replace rate_f = round(rate_f, .01) 
	append using rate_chd.dta
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
}

use rate_chd, clear


* listing the output (run, if needed)
order cyear region rate_m rate_f
sort region sex2 cyear
list cyear region disch tot_m tot_f rate_m rate_f, sepby(region sex2)

gen rate = rate_m
replace rate = rate_f if sex2==2


* Graph of crude rate by sex

label variable rate "Hospitalizations per 100,000" // label for y-axis
graph bar (asis) rate, stack over(region) over(sex2) over(cyear) ylabel(0(500)3000) ///
		legend(rows(1) order(1 "WEC" 2 "LAM" 3 "MDL" 4 "ON")) ///
		xsize(3) ysize(2) scale(.75) ///
		title("Hospitalization Rates for CHD by Sex: 2002-2010")
label variable rate ""



* *********************************************	
* *********************************************	
* AGE-SPECIFIC CRUDE HOSPITALIZATION RATES: 
* CORONARY HEART DISEASE/ISCHEMIC HEART DISEASE
* *********************************************
* *********************************************	
* Value labels *
* agrp_cd2=0 for age 00-19
* agrp_cd2=20 for age 20-44
* agrp_cd2=45 for age 45-64
* agrp_cd2=65 for age 65-74
* agrp_cd2=75 for age 75+


use tmp.dta, clear

forvalues outer = 1/1 {
	preserve // preservs data so that it can be restored

	forvalues dummy = 1/1 {
	display "Running for WEC"
	* keep only disease = 1 (CHD) and region = 1 (WEC)
	keep if code == 1 & region == 1 
	collapse (sum) disch, by(cyear agrp_cd2) // collapse by cyear, sex2
	merge m:1 cyear using pop_wec.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	gen rate_0 = (disch/pop0019)*100000 if agrp_cd2 == 0
	gen rate_20 = (disch/pop2044)*100000 if agrp_cd2 == 20
	gen rate_45 = (disch/pop4564)*100000 if agrp_cd2 == 45
	gen rate_65 = (disch/pop6574)*100000 if agrp_cd2 == 65
	gen rate_75 = (disch/pop75)*100000 if agrp_cd2 == 75
	replace rate_0 = round(rate_0, .01) 
	replace rate_20 = round(rate_20, .01) 
	replace rate_45 = round(rate_45, .01) 
	replace rate_65 = round(rate_65, .01) 
	replace rate_75 = round(rate_75, .01) 
	save rate_chd.dta, replace
	*restore // restore the original data
	}
	
	restore
	
	* For Lambton County
	preserve
	forvalues dummy = 1/1 {
	display "Running for LAM"
	*preserve // preservs data so that it can be restored	
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region == 2  // CHD, LAM
	collapse (sum) disch, by(cyear agrp_cd2) // collapse by cyear, 
	merge m:1 cyear using pop_lam.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	gen rate_0 = (disch/pop0019)*100000 if agrp_cd2 == 0
	gen rate_20 = (disch/pop2044)*100000 if agrp_cd2 == 20
	gen rate_45 = (disch/pop4564)*100000 if agrp_cd2 == 45
	gen rate_65 = (disch/pop6574)*100000 if agrp_cd2 == 65
	gen rate_75 = (disch/pop75)*100000 if agrp_cd2 == 75	
	replace rate_0 = round(rate_0, .01) 
	replace rate_20 = round(rate_20, .01) 
	replace rate_45 = round(rate_45, .01) 
	replace rate_65 = round(rate_65, .01) 
	replace rate_75 = round(rate_75, .01) 	
	append using rate_chd.dta // append the data to existing file
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
* For Middlesex-London Health Unit
	preserve
	forvalues dummy = 1/1 {
	display "Running for MDL"
	*preserve // preservs data so that it can be restored	
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region == 3  // CHD, MDL
	collapse (sum) disch, by(cyear agrp_cd2) // collapse by cyear, age-group
	merge m:1 cyear using pop_mdl.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	gen rate_0 = (disch/pop0019)*100000 if agrp_cd2 == 0
	gen rate_20 = (disch/pop2044)*100000 if agrp_cd2 == 20
	gen rate_45 = (disch/pop4564)*100000 if agrp_cd2 == 45
	gen rate_65 = (disch/pop6574)*100000 if agrp_cd2 == 65
	gen rate_75 = (disch/pop75)*100000 if agrp_cd2 == 75	
	replace rate_0 = round(rate_0, .01) 
	replace rate_20 = round(rate_20, .01) 
	replace rate_45 = round(rate_45, .01) 
	replace rate_65 = round(rate_65, .01) 
	replace rate_75 = round(rate_75, .01) 	
	append using rate_chd.dta
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
	* For ON 
	preserve
	forvalues dummy = 1/1 {
	display "Running for ON"
	* keep only disease = 1 (CHD) and region = 2 (WEC)
	keep if code == 1 & region > 1 // CHD, ON
	collapse (sum) disch, by(cyear agrp_cd2) // collapse by cyear, age-group
	merge m:1 cyear using pop_on.dta
	drop _merge 
	display "." // empty line
	display "." // empty line
	gen rate_0 = (disch/pop0019)*100000 if agrp_cd2 == 0
	gen rate_20 = (disch/pop2044)*100000 if agrp_cd2 == 20
	gen rate_45 = (disch/pop4564)*100000 if agrp_cd2 == 45
	gen rate_65 = (disch/pop6574)*100000 if agrp_cd2 == 65
	gen rate_75 = (disch/pop75)*100000 if agrp_cd2 == 75	
	replace rate_0 = round(rate_0, .01) 
	replace rate_20 = round(rate_20, .01) 
	replace rate_45 = round(rate_45, .01) 
	replace rate_65 = round(rate_65, .01) 
	replace rate_75 = round(rate_75, .01) 	
	append using rate_chd.dta
	save rate_chd.dta, replace
	}
	restore // restore the original data
	
}

use rate_chd, clear

* Collapsing all the rate variables to a sinlge variable, age-group

gen rate = rate_0
replace rate = rate_20 if agrp_cd2==20
replace rate = rate_45 if agrp_cd2==45
replace rate = rate_65 if agrp_cd2==65
replace rate = rate_75 if agrp_cd2==75

* listing the output (run, if needed)
order cyear region agrp_cd2 pop0019-pop75 rate
list cyear region agrp_cd2 disch pop0019-pop75 rate, sepby(region)



* *********************************************	*	
* AGE-STANDARDIZED HOSPITALIZATION RATES		*
* CORONARY HEART DISEASE/ISCHEMIC HEART DISEASE	*
* *********************************************	*

use tmp.dta, clear // loading the chronic data 
keep if region < 4 // keeping WEC, LAM, MDL only
keep if code == 1 // keep only the CHD
collapse (sum) disch, by(cyear agrp_cd2 region)
save tmp1.dta, replace

sort agrp_cd2
gen disch0019 = 0
gen disch2044 = 0
gen disch4564 = 0
gen disch6574 = 0
gen disch75 = 0

replace disch0019 = disch if agrp_cd2 == 0
replace disch2044 = disch if agrp_cd2 == 20
replace disch4564 = disch if agrp_cd2 == 45
replace disch6574 = disch if agrp_cd2 == 65
replace disch75 = disch if agrp_cd2 == 75

sort cyear region agrp_cd2

* need to collapse

collapse (sum) disch0019-disch75, by(cyear region)
sort region cyear
gen id = _n
save tmp1.dta, replace



* Prepare the data for merging with 1991 Standard population
* ----------------------------------------------------------
* gen id = _n
* save tmp1.dta, replace // to be deleted later

use standard1991, clear
expand 27 // change according to your data for this indicator
gen id = _n

merge 1:1 id  using tmp1.dta
drop id _merge

egen double sp0019 = rowtotal(sp_lt1-sp15_19)
egen double sp2044 = rowtotal(sp20_24-sp40_44)
egen double sp4564 = rowtotal(sp45_49-sp60_64)
egen double sp6574 = rowtotal(sp65_69-sp70_74)
egen double sp75 = rowtotal(sp75_79-sp90plus)

save coronary_sp.dta, replace // Data with the standard population included
*erase tmp1.dta

* Merging with standard population complete.
* ----------------------------------------------------------

* now load population data to merge with the tmp1.dta
/*
use pop_est2002-2010.dta, clear
expand(5)
sort cyear region
gen id = _n
merge 1:1 id using tmp1.dta
*/

use coronary_sp, clear

use pop_est2002-2010.dta, clear
drop if region==4
sort region cyear 
merge 1:1 cyear region using coronary_sp.dta
drop _merge

order cyear region disch0019-disch75
sort region cyear

gen multi = 100000 // multiplier, taken to be 100,000 for this indicator
gen rate0019 = (disch0019/pop0019)*multi
gen rate2044 = (disch2044/pop2044)*multi
gen rate4564 = (disch4564/pop4564)*multi
gen rate6574 = (disch6574/pop6574)*multi
gen rate75 = (disch75/pop75)*multi

* Data merging complete. Now ready to calculate the 
* standardized rates

* ----------------------------------------------------------
* Calculation of Age-specific Rates and Standardized rates
* Code plan: exr = expected rate, e.g., exr15_19 means 
* expected rate for age 15-19
* ----------------------------------------------------------
* See the formula for age-specific crude rate

gen evnt0019 = disch0019
gen evnt2044 = disch2044
gen evnt4564 = disch4564
gen evnt6574 = disch6574
gen evnt75 = disch75

gen exr0019 = evnt0019 * sp0019/pop0019
gen exr2044 = evnt2044 * sp2044/pop2044
gen exr4564 = evnt4564 * sp4564/pop4564
gen exr6574 = evnt6574 * sp6574/pop6574
gen exr75 = evnt75 * sp75/pop75

egen long rate_num = 	rowtotal(exr*) // numerator for the standardized rate
gen rate_st = (rate_num/sp_tot) * 100000 // rate per 100,000
replace rate_st = round(rate_st, 0.01)

* listing the standardized rates for CHD
sort region
list cyear region  rate_st, sepby(region)


/* Plot of standardized rates

twoway ///
(connected rate_st cyear if region==1, ///
	sort lpattern(l) msymbol(D) lwidth(*1.5)) ///
	(connected rate_st cyear if region==2, sort) ///
	(connected rate_st cyear if region==3, sort) ///
	(connected rate_st cyear if region==4, sort) ///
	, ///
	legend(rows(1) order(1 "WEC" 2 "LAM" 3 "MDL" 4 "ON")) ///
	xsize(3) ysize(2) scale(.75) ///
	title("Age-Standardized Hospitalization Rates for CHD: 2002-2010") ///
	xtitle("Calendar Year") ytitle("Hospitalizations per 100,000")
*/
	
* Feb 7, 2012

* ----------------------------------------------------------
* CONFIDENCE INTERVALS FOR STANDARDIZED RATES
* ----------------------------------------------------------
* CALCULATION OF VARIANCE USING POISSON APPROXIMATION
* See page 22 of Standardization paper	

* Code plan: vp = variance usign Poisson apprioximation, 
* e.g., vp10_14 means variance for age 10-14

gen double vp0019 = (sp0019/sp_tot)^2 * evnt0019/(pop_tot^2) 
gen double vp2044 = (sp2044/sp_tot)^2 * evnt2044/(pop_tot^2) 
gen double vp4564 = (sp4564/sp_tot)^2 * evnt4564/(pop_tot^2) 
gen double vp6574 = (sp6574/sp_tot)^2 * evnt6574/(pop_tot^2) 
gen double vp75 = (sp75/sp_tot)^2 * evnt75/(pop_tot^2) 

egen double v_rate_st = rowtotal(vp*)

gen lcl_st = rate_st - 1.96*sqrt(v_rate_st)*multi // need to multiply by "multi" to equalize the scale
gen ucl_st = rate_st + 1.96*sqrt(v_rate_st)*multi
replace lcl_st = round(lcl_st, 0.01) // rounding to two digits
replace ucl_st = round(ucl_st, 0.01)
	
* CI calculation using Gamma model
gen rate_st_gam = rate_st/multi // getting back to original scale
gen  frak = rate_st_gam^2/v_rate_st


* Comfidence limit using gamma model
gen lcl_gam = (rate_st_gam*invgammap(frak, .025)/frak)*multi // in 100,000
gen ucl_gam = (rate_st_gam*invgammap(frak+1, .975)/frak)*multi // in 100,000
replace lcl_gam = round(lcl_gam, 0.01) // rounding to two digits
replace ucl_gam = round(ucl_gam, 0.01)

* Saving the rates for WEC, LAM, and MDL. ON to be calculated 
* separately, and joined with this file later.
save rate_wec_lam_mdl.dta, replace	
	
* Listing the CIs
sort region cyear
list cyear region lcl_st ucl_st lcl_gam ucl_gam, sepby(region)

/* CONCLUSION (Feb 7, 2012)
There is no noticeable difference between normal-based CI and gamma-based CI.
Decision: Any of the gamma- or normal-based CIs can be used. 
Since there is no noticeable difference, I would prefere to use the 
normal based CI as it is easier to understand. 
*/


*********************************************************************
**** /// AGE-standardized rates for ONtario excluding WEC /// ***
*********************************************************************

use tmp.dta, clear // loading the chronic data 
gen region_on = 0
replace region_on = 4 if region > 1
drop region // drop region to replace by region_on
rename region_on region // region now contains ON data only

keep if region == 4
keep if code == 1 // keep only the CHD
collapse (sum) disch, by(cyear agrp_cd2 region)

save tmp1.dta, replace

sort agrp_cd2
gen disch0019 = 0
gen disch2044 = 0
gen disch4564 = 0
gen disch6574 = 0
gen disch75 = 0

replace disch0019 = disch if agrp_cd2 == 0
replace disch2044 = disch if agrp_cd2 == 20
replace disch4564 = disch if agrp_cd2 == 45
replace disch6574 = disch if agrp_cd2 == 65
replace disch75 = disch if agrp_cd2 == 75

sort cyear region agrp_cd2

* need to collapse

collapse (sum) disch0019-disch75, by(cyear region)
sort region cyear
gen id = _n
save tmp1.dta, replace



* Prepare the data for merging with 1991 Standard population
* ----------------------------------------------------------
* gen id = _n
* save tmp1.dta, replace // to be deleted later

use standard1991, clear
expand 9 // change according to your data for this indicator
gen id = _n

merge 1:1 id  using tmp1.dta
drop id _merge

egen double sp0019 = rowtotal(sp_lt1-sp15_19)
egen double sp2044 = rowtotal(sp20_24-sp40_44)
egen double sp4564 = rowtotal(sp45_49-sp60_64)
egen double sp6574 = rowtotal(sp65_69-sp70_74)
egen double sp75 = rowtotal(sp75_79-sp90plus)

save coronary_sp.dta, replace // Data with the standard population included
*erase tmp1.dta

* Merging with standard population complete.
* ----------------------------------------------------------

*use coronary_sp, clear

use pop_est2002-2010.dta, clear
keep if region==4
sort region cyear 
merge 1:1 cyear region using coronary_sp.dta
drop _merge

order cyear region disch0019-disch75

gen multi = 100000 // multiplier, taken to be 100,000 for this indicator
gen rate0019 = (disch0019/pop0019)*multi
gen rate2044 = (disch2044/pop2044)*multi
gen rate4564 = (disch4564/pop4564)*multi
gen rate6574 = (disch6574/pop6574)*multi
gen rate75 = (disch75/pop75)*multi

* Data merging complete. Now ready to calculate the 
* standardized rates

* ----------------------------------------------------------
* Calculation of Age-specific Rates and Standardized rates
* Code plan: exr = expected rate, e.g., exr15_19 means 
* expected rate for age 15-19
* ----------------------------------------------------------
* See the formula for age-specific crude rate

gen evnt0019 = disch0019
gen evnt2044 = disch2044
gen evnt4564 = disch4564
gen evnt6574 = disch6574
gen evnt75 = disch75

gen exr0019 = evnt0019 * sp0019/pop0019
gen exr2044 = evnt2044 * sp2044/pop2044
gen exr4564 = evnt4564 * sp4564/pop4564
gen exr6574 = evnt6574 * sp6574/pop6574
gen exr75 = evnt75 * sp75/pop75

egen long rate_num = 	rowtotal(exr*) // numerator for the standardized rate
gen rate_st = (rate_num/sp_tot) * 100000 // rate per 100,000
replace rate_st = round(rate_st, 0.01)

* listing the standardized rates for CHD
keep if region == 4
sort region
list cyear region  rate_st, sepby(region)

	
* Feb 16, 2012

* CALCULATION OF VARIANCE USING POISSON APPROXIMATION
* See page 22 of Standardization paper	

* Code plan: vp = variance usign Poisson apprioximation, 
* e.g., vp10_14 means variance for age 10-14

gen double vp0019 = (sp0019/sp_tot)^2 * evnt0019/(pop_tot^2) 
gen double vp2044 = (sp2044/sp_tot)^2 * evnt2044/(pop_tot^2) 
gen double vp4564 = (sp4564/sp_tot)^2 * evnt4564/(pop_tot^2) 
gen double vp6574 = (sp6574/sp_tot)^2 * evnt6574/(pop_tot^2) 
gen double vp75 = (sp75/sp_tot)^2 * evnt75/(pop_tot^2) 

egen double v_rate_st = 	rowtotal(vp*)

gen lcl_st = rate_st - 1.96*sqrt(v_rate_st)*multi // need to multiply by "multi" to equalize the scale
gen ucl_st = rate_st + 1.96*sqrt(v_rate_st)*multi
replace lcl_st = round(lcl_st, 0.01) // rounding to two digits
replace ucl_st = round(ucl_st, 0.01)
	
* CI calculation using Gamma model
gen rate_st_gam = rate_st/multi // getting back to original scale
gen  frak = rate_st_gam^2/v_rate_st


* Comfidence limit using gamma model
gen lcl_gam = (rate_st_gam*invgammap(frak, .025)/frak)*multi // in 100,000
gen ucl_gam = (rate_st_gam*invgammap(frak+1, .975)/frak)*multi // in 100,000
replace lcl_gam = round(lcl_gam, 0.01) // rounding to two digits
replace ucl_gam = round(ucl_gam, 0.01)

**** /// END OF AGE-SEX-standardized rates for ONtario excluding WEC /// ***

**** /// MERGING ON RATES WITH rate_wec_lam_mdl.dta /// ***
* Joining with the rates for WEC, LAM, MDL
append using rate_wec_lam_mdl.dta
** Merge complete ***

* AGE-SEX-standardized rates for ONtario excluding WEC
sort region cyear
list cyear region rate_st, sepby(region)

* Listing for CI
list cyear region rate_st lcl_st ucl_st lcl_gam ucl_gam, sepby(region)


* Plot of standardized rates

twoway ///
(connected rate_st cyear if region==1, ///
	sort lpattern(l) msymbol(D) lwidth(*1.5)) ///
	(connected rate_st cyear if region==2, sort) ///
	(connected rate_st cyear if region==3, sort) ///
	(connected rate_st cyear if region==4, sort) ///
	, ///
	legend(rows(1) order(1 "WEC" 2 "LAM" 3 "MDL" 4 "ON")) ///
	xsize(3) ysize(2) scale(.75) ///
	title("Age-Standardized Hospitalization Rates for CHD: 2002-2010") ///
	xtitle("Calendar Year") ytitle("Hospitalizations per 100,000")


/* 
HISTOGRAM WITH ERROR BARS FOR STANDARDIZED RATES
Plot of CBR for WEC, LHIN, and ON
----------------------------------------------------------------- */

*keep if (cyear >=2004 & cyear <=2010)

* Upper and lower bounds (ub and lb)
generate yregion = region 	if cyear==2002
replace yregion = region+5  if cyear==2003
replace yregion = region+10 if cyear==2004
replace yregion = region+15 if cyear==2005
replace yregion = region+20 if cyear==2006
replace yregion = region+25 if cyear==2007
replace yregion = region+30 if cyear==2008
replace yregion = region+35 if cyear==2009
replace yregion = region+40 if cyear==2010

sort yregion
*list yregion cyear region2, sepby(region2) nolabel 

* CI for standardized Rates
twoway (bar rate_st yregion if region==1, yscale(range(0 600)) ylabel(0(100)600)) ///
       (bar rate_st yregion if region==2) ///
       (bar rate_st yregion if region==3) ///
	   (bar rate_st yregion if region==4) ///	
	   (connected rate_st yregion if region==1, sort) ///
	   (connected rate_st yregion if region==2, sort) ///
	   (connected rate_st yregion if region==3, sort) ///
	   (connected rate_st yregion if region==4, sort) ///
       (rcap ucl_st lcl_st yregion), ///
	   xsize(3) ysize(2) scale(.75)	///
       legend(rows(1) order(1 "WEC" 2 "LAM" 3 "MDL" 4 "ON") ) ///
       xlabel( 2.5 "2002" 7.5 "2003" 12.5 "2004" 17.5 "2005" 22.5 "2006" 27.5 "2007" 32.5 "2008" 37.5 "2009" 42.5 "2010", noticks) ///
	   title("Age-Standardized Hospitalization Rates for CHD, 2002-2010") ///
       xtitle("Year") ytitle("Hopitalizations per 100,000")

/* Comment (Feb 7, 2012)

The CI for ON does not show up clearly. This is not an error. The  reason
why it only shows the upper limt is the fact that the interval is too small for
both limits to show up on graph.

To check the CI limits, run the following code:

order cyear region rate_st lcl_st ucl_st lcl_gam ucl_gam
sort region

*/



*******************************************************************
********* AGE-SEX STANDARDIZED RATE CALCULATION (FINAL) ***********
********* Completed on February 14, 2012 at 5:53 PM ***************
*******************************************************************

use tmp.dta, clear // loading the chronic data 

* testing
keep if region < 4
keep if code == 1 // keep only the CHD
collapse (sum) disch, by(cyear agrp_cd2 sex2 region)
save tmp2.dta, replace
* sort region cyear sex2 agrp_cd2

*keep if region ==1
* sort agrp_cd2
gen disch0019 = 0
gen disch2044 = 0
gen disch4564 = 0
gen disch6574 = 0
gen disch75 = 0

replace disch0019 = disch if agrp_cd2 == 0
replace disch2044 = disch if agrp_cd2 == 20
replace disch4564 = disch if agrp_cd2 == 45
replace disch6574 = disch if agrp_cd2 == 65
replace disch75 = disch if agrp_cd2 == 75

sort cyear region agrp_cd2

* need to collapse
collapse (sum) disch0019-disch75, by(cyear region sex2)
sort region cyear sex2
gen id = _n
save tmp2.dta, replace


* ----------------------------------------------------------
* Prepare the data for merging with 1991 Standard population (MF)
* This standard data has population by sex and age-group
* ----------------------------------------------------------

use standard1991mf, clear
* expand 72 // change according to your data for this indicator
expand 54 // only region =1, 2, 3
gen id = _n

merge 1:1 id  using tmp2.dta
drop id _merge

* Population total by age-grpup and sex based on CD age-group

* For male
egen double sp0019m = rowtotal(sp_lt1m-sp15_19m)
egen double sp2044m = rowtotal(sp20_24m-sp40_44m)
egen double sp4564m = rowtotal(sp45_49m-sp60_64m)
egen double sp6574m = rowtotal(sp65_69m-sp70_74m)
egen double sp75m = rowtotal(sp75_79m-sp90plusm)

* For female
egen double sp0019f = rowtotal(sp_lt1f-sp15_19f)
egen double sp2044f = rowtotal(sp20_24f-sp40_44f)
egen double sp4564f = rowtotal(sp45_49f-sp60_64f)
egen double sp6574f = rowtotal(sp65_69f-sp70_74f)
egen double sp75f = rowtotal(sp75_79f-sp90plusf)

save coronary_agesex.dta, replace // Data with the standard population included

*erase tmp2.dta

** ////////// Merging with standard population complete. /////////

* now load population data to merge with the coronary_agesex.dta
/*
use pop_est2002-2010.dta, clear
expand(5)
sort cyear region
gen id = _n
merge 1:1 id using tmp1.dta
*/

use coronary_agesex.dta, clear

use pop_est2002-2010.dta, clear

* remove ontario
* keep if region < 4
merge 1:m cyear region using coronary_agesex.dta
sort cyear region sex2
drop _merge

order cyear region sex2 disch0019-disch75 pop0019f-pop75m sp0019m-sp75f
sort region cyear sex2


* Data merging complete. Now ready to calculate the 
* standardized rates

* ----------------------------------------------------------
* Calculation of Age-Sex Standardized rates
* Code plan: exr = expected rate, e.g., exr15_19 means 
* expected rate for age 15-19
* ----------------------------------------------------------
* See the formula for age-specific crude rate

* Event for male
gen evnt0019m = disch0019 if sex2==1
gen evnt2044m = disch2044 if sex2==1
gen evnt4564m = disch4564 if sex2==1
gen evnt6574m = disch6574 if sex2==1
gen evnt75m = disch75 if sex2==1

* Event for female
gen evnt0019f = disch0019 if sex2==2
gen evnt2044f = disch2044 if sex2==2
gen evnt4564f = disch4564 if sex2==2
gen evnt6574f = disch6574 if sex2==2
gen evnt75f = disch75 if sex2==2

* Expected rate for male
gen exrm0019 = evnt0019m * sp0019m/pop0019m
gen exrm2044 = evnt2044m * sp2044m/pop2044m
gen exrm4564 = evnt4564m * sp4564m/pop4564m
gen exrm6574 = evnt6574m * sp6574m/pop6574m
gen exrm75 = evnt75m * sp75m/pop75m

* Expected rate for male
gen exrf0019 = evnt0019f * sp0019f/pop0019f
gen exrf2044 = evnt2044f * sp2044f/pop2044f
gen exrf4564 = evnt4564f * sp4564f/pop4564f
gen exrf6574 = evnt6574f * sp6574f/pop6574f
gen exrf75 = evnt75f * sp75f/pop75f

gen multi = 100000/sp_tot 
egen long ratem = 	rowtotal(exrm*) // numerator for the standardized rate for male
egen long ratef = 	rowtotal(exrf*) // numerator for the standardized rate for male
replace ratem = ratem * multi
replace ratef = ratef * multi

* Save the data to me merged with standardized rates
* save tmp3.dta, replace // contains data prior to collapsing

* THIS SECTION IS REQUIRED FOR CALCULATION OF 
* CONFIDENCE INTERVALS
* Code plan: vp = variance usign Poisson apprioximation, 
* e.g., vp10_14 means variance for age 10-14

* For male
gen double vpm0019 = (sp0019m/sp_tot)^2 * evnt0019m/(pop0019m^2) if sex2==1
gen double vpm2044 = (sp2044m/sp_tot)^2 * evnt2044m/(pop2044m^2) if sex2==1
gen double vpm4564 = (sp4564m/sp_tot)^2 * evnt4564m/(pop4564m^2) if sex2==1 
gen double vpm6574 = (sp6574m/sp_tot)^2 * evnt6574m/(pop6574m^2) if sex2==1 
gen double vpm75 = (sp75m/sp_tot)^2 * evnt75m/(pop75m^2) if sex2==1

* For female
gen double vpf0019 = (sp0019f/sp_tot)^2 * evnt0019f/(pop0019f^2) if sex2==2 
gen double vpf2044 = (sp2044f/sp_tot)^2 * evnt2044f/(pop2044f^2) if sex2==2 
gen double vpf4564 = (sp4564f/sp_tot)^2 * evnt4564f/(pop4564f^2) if sex2==2
gen double vpf6574 = (sp6574f/sp_tot)^2 * evnt6574f/(pop6574f^2) if sex2==2
gen double vpf75 = (sp75f/sp_tot)^2 * evnt75f/(pop75f^2) if sex2==2

egen double v_ratem_st = 	rowtotal(vpm*) // for male
egen double v_ratef_st = 	rowtotal(vpf*) // for female

* total variance
gen double v_rate_st =v_ratem_st + v_ratef_st

* Variablce calculation ends

* Collapse some of the columns to draw graph and list the rates
collapse (sum) ratem ratef v_rate_st, by(cyear region)

gen rate_st = ratem+ratef
replace rate_st = round(rate_st, 0.01)
sort cyear region

* listing the standardized rates for CHD
sort region cyear
list cyear region  rate_st, sepby(region)


* Feb 14, 2012
* ----------------------------------------------------------
* CONFIDENCE INTERVALS FOR AGE-SEX STANDARDIZED RATES
* ----------------------------------------------------------
* CALCULATION OF VARIANCE USING POISSON APPROXIMATION
* See page 22 of Standardization paper	

* Code plan: vp = variance usign Poisson apprioximation, 
* e.g., vp10_14 means variance for age 10-14

gen multi = 100000
gen lcl_st = rate_st - 1.96*sqrt(v_rate_st)*multi // need to multiply by "multi" to equalize the scale
gen ucl_st = rate_st + 1.96*sqrt(v_rate_st)*multi
replace lcl_st = round(lcl_st, 0.01) // rounding to two digits
replace ucl_st = round(ucl_st, 0.01)
	
* CI calculation using Gamma model
gen rate_st_gam = rate_st/multi // getting back to original scale
gen  frak = rate_st_gam^2/v_rate_st


* Comfidence limit using gamma model
gen lcl_gam = (rate_st_gam*invgammap(frak, .025)/frak)*multi // in 100,000
gen ucl_gam = (rate_st_gam*invgammap(frak+1, .975)/frak)*multi // in 100,000
replace lcl_gam = round(lcl_gam, 0.01) // rounding to two digits
replace ucl_gam = round(ucl_gam, 0.01)

* Listing the CIs
sort region cyear
list cyear region lcl_st ucl_st lcl_gam ucl_gam, sepby(region)

* Saving the rates for WEC, LAM, and MDL. ON to be calculated 
* separately, and joined with this file later.
drop if region == 4
save rate_wec_lam_mdl.dta, replace	
	
/* CONCLUSION (Feb 7, 2012)
There is no noticeable difference between normal-based CI and gamma-based CI.
Decision: Any of the gamma- or normal-based CIs can be used. 
Since there is no noticeable difference, I would prefere to use the 
normal based CI as it is easier to understand. 
*/


*********************************************************************
**** /// AGE-SEX-standardized rates for ONtario excluding WEC /// ***
*********************************************************************

use tmp.dta, clear // loading the chronic data 

*** ////testing begins //// ****
* Feb 15, 2012

gen region_on = 0
replace region_on = 4 if region > 1

drop region // drop region to replace by region_on
rename region_on region // region now contains ON data only

keep if region == 4
keep if code == 1 // keep only the CHD
collapse (sum) disch, by(cyear agrp_cd2 sex2 region)
save tmp2.dta, replace

gen disch0019 = 0
gen disch2044 = 0
gen disch4564 = 0
gen disch6574 = 0
gen disch75 = 0

replace disch0019 = disch if agrp_cd2 == 0
replace disch2044 = disch if agrp_cd2 == 20
replace disch4564 = disch if agrp_cd2 == 45
replace disch6574 = disch if agrp_cd2 == 65
replace disch75 = disch if agrp_cd2 == 75

sort cyear region agrp_cd2

* need to collapse
collapse (sum) disch0019-disch75, by(cyear region sex2)
sort region cyear sex2
gen id = _n
save tmp2.dta, replace


* ----------------------------------------------------------
* Prepare the data for merging with 1991 Standard population (MF)
* This standard data has population by sex and age-group
* ----------------------------------------------------------

use standard1991mf, clear
* expand 72 // change according to your data for this indicator
expand 18 // only for ON, there are 18 cases in tmp2.dta
gen id = _n

merge 1:1 id  using tmp2.dta
drop id _merge

* Population total by age-grpup and sex based on CD age-group
* For male
egen double sp0019m = rowtotal(sp_lt1m-sp15_19m)
egen double sp2044m = rowtotal(sp20_24m-sp40_44m)
egen double sp4564m = rowtotal(sp45_49m-sp60_64m)
egen double sp6574m = rowtotal(sp65_69m-sp70_74m)
egen double sp75m = rowtotal(sp75_79m-sp90plusm)

* For female
egen double sp0019f = rowtotal(sp_lt1f-sp15_19f)
egen double sp2044f = rowtotal(sp20_24f-sp40_44f)
egen double sp4564f = rowtotal(sp45_49f-sp60_64f)
egen double sp6574f = rowtotal(sp65_69f-sp70_74f)
egen double sp75f = rowtotal(sp75_79f-sp90plusf)

save coronary_agesex.dta, replace // Data with the standard population included

*erase tmp2.dta

** ////////// Merging with standard population complete. /////////

* now load population data to merge with the coronary_agesex.dta
/*
use pop_est2002-2010.dta, clear
expand(5)
sort cyear region
gen id = _n
merge 1:1 id using tmp1.dta
*/

use coronary_agesex.dta, clear
order cyear-disch75
gen id = _n
save coronary_agesex.dta, replace


use pop_est2002-2010.dta, clear
* Keep ontario only
keep if region == 4
expand 2
sort cyear
gen id = _n

merge 1:1 id using coronary_agesex.dta

drop _merge

order cyear region sex2 disch0019-disch75 pop0019f-pop75m sp0019m-sp75f
* sort region cyear sex2


* Data merging complete. Now ready to calculate the 
* standardized rates

* ----------------------------------------------------------
* Calculation of Age-Sex Standardized rates for ON
* Code plan: exr = expected rate, e.g., exr15_19 means 
* expected rate for age 15-19
* ----------------------------------------------------------
* See the formula for age-specific crude rate

* Event for male
gen evnt0019m = disch0019 if sex2==1
gen evnt2044m = disch2044 if sex2==1
gen evnt4564m = disch4564 if sex2==1
gen evnt6574m = disch6574 if sex2==1
gen evnt75m = disch75 if sex2==1

* Event for female
gen evnt0019f = disch0019 if sex2==2
gen evnt2044f = disch2044 if sex2==2
gen evnt4564f = disch4564 if sex2==2
gen evnt6574f = disch6574 if sex2==2
gen evnt75f = disch75 if sex2==2

* Expected rate for male
gen exrm0019 = evnt0019m * sp0019m/pop0019m
gen exrm2044 = evnt2044m * sp2044m/pop2044m
gen exrm4564 = evnt4564m * sp4564m/pop4564m
gen exrm6574 = evnt6574m * sp6574m/pop6574m
gen exrm75 = evnt75m * sp75m/pop75m

* Expected rate for male
gen exrf0019 = evnt0019f * sp0019f/pop0019f
gen exrf2044 = evnt2044f * sp2044f/pop2044f
gen exrf4564 = evnt4564f * sp4564f/pop4564f
gen exrf6574 = evnt6574f * sp6574f/pop6574f
gen exrf75 = evnt75f * sp75f/pop75f

gen multi = 100000/sp_tot 
egen long ratem = 	rowtotal(exrm*) // numerator for the standardized rate for male
egen long ratef = 	rowtotal(exrf*) // numerator for the standardized rate for male
replace ratem = ratem * multi
replace ratef = ratef * multi

* Save the data to me merged with standardized rates
* save tmp3.dta, replace // contains data prior to collapsing

* THIS SECTION IS REQUIRED FOR CALCULATION OF 
* CONFIDENCE INTERVALS
* Code plan: vp = variance usign Poisson apprioximation, 
* e.g., vp10_14 means variance for age 10-14

* For male
gen double vpm0019 = (sp0019m/sp_tot)^2 * evnt0019m/(pop0019m^2) if sex2==1
gen double vpm2044 = (sp2044m/sp_tot)^2 * evnt2044m/(pop2044m^2) if sex2==1
gen double vpm4564 = (sp4564m/sp_tot)^2 * evnt4564m/(pop4564m^2) if sex2==1 
gen double vpm6574 = (sp6574m/sp_tot)^2 * evnt6574m/(pop6574m^2) if sex2==1 
gen double vpm75 = (sp75m/sp_tot)^2 * evnt75m/(pop75m^2) if sex2==1

* For female
gen double vpf0019 = (sp0019f/sp_tot)^2 * evnt0019f/(pop0019f^2) if sex2==2 
gen double vpf2044 = (sp2044f/sp_tot)^2 * evnt2044f/(pop2044f^2) if sex2==2 
gen double vpf4564 = (sp4564f/sp_tot)^2 * evnt4564f/(pop4564f^2) if sex2==2
gen double vpf6574 = (sp6574f/sp_tot)^2 * evnt6574f/(pop6574f^2) if sex2==2
gen double vpf75 = (sp75f/sp_tot)^2 * evnt75f/(pop75f^2) if sex2==2

egen double v_ratem_st = 	rowtotal(vpm*) // for male
egen double v_ratef_st = 	rowtotal(vpf*) // for female

* total variance
gen double v_rate_st =v_ratem_st + v_ratef_st

* Variablce calculation ends

* Collapse some of the columns to draw graph and list the rates
collapse (sum) ratem ratef v_rate_st, by(cyear region)

gen rate_st = ratem+ratef
replace rate_st = round(rate_st, 0.01)
sort cyear region

* listing the standardized rates for CHD
sort region cyear
list cyear region  rate_st, sepby(region)


* CALCULATION OF VARIANCE USING POISSON APPROXIMATION
* See page 22 of Standardization paper	

* Code plan: vp = variance usign Poisson apprioximation, 
* e.g., vp10_14 means variance for age 10-14

gen multi = 100000
gen lcl_st = rate_st - 1.96*sqrt(v_rate_st)*multi // need to multiply by "multi" to equalize the scale
gen ucl_st = rate_st + 1.96*sqrt(v_rate_st)*multi
replace lcl_st = round(lcl_st, 0.01) // rounding to two digits
replace ucl_st = round(ucl_st, 0.01)
	
* CI calculation using Gamma model
gen rate_st_gam = rate_st/multi // getting back to original scale
gen  frak = rate_st_gam^2/v_rate_st


* Comfidence limit using gamma model
gen lcl_gam = (rate_st_gam*invgammap(frak, .025)/frak)*multi // in 100,000
gen ucl_gam = (rate_st_gam*invgammap(frak+1, .975)/frak)*multi // in 100,000
replace lcl_gam = round(lcl_gam, 0.01) // rounding to two digits
replace ucl_gam = round(ucl_gam, 0.01)

**** /// END OF AGE-SEX-standardized rates for ONtario excluding WEC /// ***

**** /// MERGING ON RATES WITH rate_wec_lam_mdl.dta /// ***
* Joining with the rates for WEC, LAM, MDL
append using rate_wec_lam_mdl.dta
** Merge complete ***

* Listing of AGE-SEX-standardized rates
sort region cyear
list cyear region rate_st lcl_st ucl_st lcl_gam ucl_gam, sepby(region)


* Plot of Age-Sex standardized rates
twoway ///
(connected rate_st cyear if region==1, ///
	sort lpattern(l) msymbol(D) lwidth(*1.5)) ///
	(connected rate_st cyear if region==2, sort) ///
	(connected rate_st cyear if region==3, sort) ///
	(connected rate_st cyear if region==4, sort) ///
	, ///
	legend(rows(1) order(1 "WEC" 2 "LAM" 3 "MDL" 4 "ON")) ///
	xsize(3) ysize(2) scale(.75) ///
	title("Age-Sex Standardized Hospitalization Rates for CHD: 2002-2010") ///
	xtitle("Calendar Year") ytitle("Hospitalizations per 100,000")

/* 
HISTOGRAM WITH ERROR BARS FOR STANDARDIZED RATES
Plot of CBR for WEC, LHIN, and ON
----------------------------------------------------------------- */

*keep if (cyear >=2004 & cyear <=2010)

* Upper and lower bounds (ub and lb)
generate yregion = region 	if cyear==2002
replace yregion = region+5  if cyear==2003
replace yregion = region+10 if cyear==2004
replace yregion = region+15 if cyear==2005
replace yregion = region+20 if cyear==2006
replace yregion = region+25 if cyear==2007
replace yregion = region+30 if cyear==2008
replace yregion = region+35 if cyear==2009
replace yregion = region+40 if cyear==2010

sort yregion
*list yregion cyear region2, sepby(region2) nolabel 


* CI for standardized Rates (normal-based CI)
twoway (bar rate_st yregion if region==1, yscale(range(0 650)) ylabel(0(50)650)) ///
       (bar rate_st yregion if region==2) ///
       (bar rate_st yregion if region==3) ///
	   (bar rate_st yregion if region==4) ///	   
       (rcap ucl_st lcl_st yregion), ///
	   xsize(3) ysize(2) scale(.75)	///
       legend(rows(1) order(1 "WEC" 2 "LAM" 3 "MDL" 4 "ON") ) ///
       xlabel( 2.5 "2002" 7.5 "2003" 12.5 "2004" 17.5 "2005" 22.5 "2006" 27.5 "2007" 32.5 "2008" 37.5 "2009" 42.5 "2010", noticks) ///
	   title("Age-Sex-Standardized Hospitalization Rates for CHD, 2002-2010") ///
       xtitle("Year") ytitle("Hopitalizations per 100,000")

	   
* CI for standardized Rates (gamma-based CI)
twoway (bar rate_st yregion if region==1, yscale(range(0 650)) ylabel(0(50)650)) ///
       (bar rate_st yregion if region==2) ///
       (bar rate_st yregion if region==3) ///
	   (bar rate_st yregion if region==4) ///	   
       (rcap ucl_gam lcl_gam yregion), ///
	   xsize(3) ysize(2) scale(.75)	///
       legend(rows(1) order(1 "WEC" 2 "LAM" 3 "MDL" 4 "ON") ) ///
       xlabel( 2.5 "2002" 7.5 "2003" 12.5 "2004" 17.5 "2005" 22.5 "2006" 27.5 "2007" 32.5 "2008" 37.5 "2009" 42.5 "2010", noticks) ///
	   title("Age-Sex-Standardized Hospitalization Rates for CHD (Gamma CI), 2002-2010") ///
       xtitle("Year") ytitle("Hopitalizations per 100,000")
	   
/* Comment (Feb 7, 2012)

The CI for ON does not show up clearly. This is not an error. The  reason
why it only shows the upper limt is the fact that the interval is too small for
both limits to show up on graph.

To check the CI limits, run the following code:

order cyear region rate_st lcl_st ucl_st lcl_gam ucl_gam
sort region

*/	


/* erase the data sets

erase tmp2.dta
erase tmp3.dta
erase tmp4.dta

*/
