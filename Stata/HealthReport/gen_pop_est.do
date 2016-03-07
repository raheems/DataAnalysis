/*
File Name	:	gen_pop_est.do
Created by	:	Enayetur Raheem
Position	:	Data Analyst, WECHU
Date		:	Feb 3, 2012
Location	: 	\\dataserv\mydocs\eraheem\mystata\env2012
Use			: 	Population estimates are needed to calculate the rates

PURPOSE

	
*/

* Import the Excel data
import excel "\\dataserv\mydocs\eraheem\mystata\env2012\data\pop_est_2002_2010.xls", firstrow sheet(data) clear

* convert cyear to numeric variable
destring(cyear), replace

* remove all the missing cases to clean things up
* keep if !missing(cyear-on75m)

* Estimated population total by sex
* Total female
gen long tot_f = pop0019f + pop2044f + pop4564f + pop6574f + pop75f 
* Total male
gen long tot_m = pop0019m + pop2044m + pop4564m + pop6574m + pop75m

* create region2 variable to represent regions numerically
gen region2 = 4 
replace region2 = 1 if region =="wec"
replace region2 = 2 if region =="lam"
replace region2 = 3 if region =="mdl"

label define region_lbl 1 "wec" 2 "lam" 3 "mdl" 4 "on"
label values region2 region_lbl

drop region
rename region2 region

* Calculating total population for each CD-age-group and each region
gen pop0019 = pop0019f + pop0019m
gen pop2044 = pop2044f + pop2044m
gen pop4564 = pop4564f + pop4564m
gen pop6574 = pop6574f + pop6574m
gen pop75 = pop75f + pop75m
gen long pop_tot = pop0019 + pop2044 + pop4564 + pop6574 + pop75

* order the variables

order cyear region tot_m tot_f pop_tot pop0019-pop75

* save the date for use in calculating rates
save pop_est2002-2010.dta, replace
