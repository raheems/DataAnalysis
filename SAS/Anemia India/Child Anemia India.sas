
PROC IMPORT OUT= WORK.anemia 
DATAFILE= "C:\Users\Raheem\Documents\MyFolder\UNCO\Research\Sanku Dey India\Child Anaemia India\CHILD ANEMIA NORTH EAST_hemo.sav" 
DBMS=SPSS REPLACE;
RUN;

proc contents;
run;


proc print data = anemia (obs=10);
run;


* Renaming some variables;
data anemia (
	rename=(
	HB1=hemo
	N104=agey
	N108=agem
	N112=result_status
	S111A=totchild
	W103=yschool
	W106=ageatmar
	X1=placeofres
	X2=religion
	X3=hhstandard
	X4=sexofchild
	X5=litmother
	X6=totchild_cat
	X7=ageatmar_cat
	)
);
set anemia;
label 
hemo='hemoglobin level'
yschool_cat='Year of schooling (cat)';
run;

proc contents data=anemia;
run;

proc freq data=anemia;
table state*agey;
run;

proc print data=anemia (obs=5);
run;

/* 
Creating level of anemia as follows:

anemialevel = 4 (Severe) if hemo < 7
anemialevel = 3 (Moderate) if hemo (7, 9.9)
anemialevel = 2 (Mild) if hemo (10-10.9)
anemialevel = 1 (Non Anemic) if hemo > 10.9

*/

proc format;
value hglevelf 
	4='4Non Anemic'
	3='3Mildly Anemic'
	2='2Moderately Anemic'
	1='1Severely Anemic'
;
value agemcatf
 1='<48 months'
 2='>48 months'
 ;
run;

data anemia;
set anemia;
format hglevel hglevelf.;
format agemcat agemcatf.;
hglevel=1;
if hemo >=7 & hemo < 10 then hglevel=2;
if hemo >=10 & hemo < 11 then hglevel=3;
if hemo >=11 then hglevel=4;
where agey <6;
* Categorizing child's age in months;
agemcat=1;
if agem >=48 then agemcat=2;
*if agem >=24 & agem <36 then agemcat=2;
*if agem >=36 & agem <48 then agemcat=3;
run;

proc freq;
table agemcat*hglevel /chisq;
table agemcat*y /chisq;
table state*agey;
run;

proc print data=anemia (obs=5);
run;

* Creating a copy of the anemia data;
data anemia2;
set anemia;
run;

proc datasets lib=work memtype=data;
   modify anemia2;
     attrib _all_ label=' ';
     attrib _all_ format=;
run;

ods rtf startpage=no file='output.rtf';

title 'Average hemoglobin level';
proc means data=anemia n mean std maxdec=2;
var hemo;
run;

proc univariate data=anemia;
var hemo;
run;

title;


* Frequency distribution;
title 'Frequency distribution';
proc freq data=anemia;
table 
	Y
	hglevel
	state
	placeofres
	religion
	hhstandard
	sexofchild
	result_status
	litmother
	totchild_cat
	ageatmar_cat
	agemcat
;
where agey<6;
run;

/*
proc gchart data=anemia;
vbar state / 
type=pct;
where y=1;
run; quit; 
*/

ods startpage=yes;
* Crosstable for Anemia Status * State;

proc freq data=anemia;
title 'Anemia Status by variaous indicators';
table state*hglevel / nopercent chisq;
table placeofres*hglevel / nopercent chisq;
table religion*hglevel / nopercent chisq;
table hhstandard*hglevel / nopercent chisq;
table sexofchild*hglevel / nopercent chisq;
table litmother*hglevel / nopercent chisq;
table totchild_cat*hglevel / nopercent chisq;
table ageatmar_cat*hglevel / nopercent chisq;
table agemcat*hglevel /nopercent chisq;
run;

* Testing CHM odds ratio;
proc freq data=anemia;
title 'Anemia Status by variaous indicators';
table state*hglevel / nopercent chisq cmh;
table placeofres*hglevel / nopercent chisq cmh;
run;

/* 
Obtaining crude odds ratio for each of the variables;
Probability of (event = anemic)
*/

* Place of residence;
proc logistic data=anemia;
class Y placeofres (ref="Urban") ;
model Y = placeofres /expb;
run;

* Religion;
proc logistic data=anemia;
class Y religion (ref="Others") ;
model Y = religion /expb;
run;

* HH living standard;
proc logistic data=anemia;
class Y hhstandard (ref="Low") ;
model Y = hhstandard /expb;
run;

* Sex of child;
proc logistic data=anemia;
class Y sexofchild (ref="Female") ;
model Y = sexofchild /expb;
run;


* Literacy of mother;
proc logistic data=anemia;
class Y litmother (ref="Can read & write")  ;
model Y = litmother /expb;
run;

* Total children ever born;
proc logistic data=anemia;
class Y totchild_cat (ref="Five or Above Children")  ;
model Y = totchild_cat /expb;
run;

* Age at marriage;
proc logistic data=anemia;
class Y ageatmar_cat (ref="Above 26 Years")  ;
model Y = ageatmar_cat /expb;
run;

* Age of child in months ;
proc logistic data=anemia;
class Y agemcat (ref="<48 months")  ;
model Y = agemcat /expb;
run;




ods startpage=yes;
/* Prevalence of anemia by these variables;
title 'Prevalence of anemia by -- ';
proc freq data=anemia;
table 
	Y
	state
	placeofres
	religion
	hhstandard
	sexofchild
	litmother
	totchild_cat
	ageatmar_cat
;
where y=1; * 1=anemic, 0=non-anemic;
run;
*/
title;


ods startpage=yes;

/** Calculate average years of schooling
by state;
proc sql;
 select state, mean(yschool) as avgyschool
 from anemia
 group by state
 ;
quit;

*/

/* Multilevel analysis using the continuous 
variable, level of hemoglobin as the response 
variable;

proc mixed data=anemia covtest noclprint method=ml;
class hhstandard placeofres state;
model hemo= /solution;
*random intercept /sub=placeofres type=vc;
*random intercept /sub=placeofres(state) type=vc;
*random intercept /sub=hhstandard(placeofres) type=vc;
random intercept /sub=hhstandard(state) type=vc;
random intercept /sub=state type=vc;
run;
quit;

*/


/* 
Multilevel model using binary hemoglobin
as the response variable
*/

/*

Level 1 variables:
- religion
- sex of child
- lit of mother
- total children ever born
- age of mother at marriage

Level-2 variables;
- Place of residence (as random effect)
- hh standard of living index

Level-3 variables;
- State (as random effect)

*/

* Using a two-level organizational model
with state being the level-2 variable;

ods startpage=yes;

* Model 1: Multinomial logist - Intercept only;
title 'Model 1';
proc glimmix data=anemia method=laplace noclprint;
class state hhstandard placeofres;
model hglevel = / dist=multinomial link=clogit solution cl;
random intercept / subject=state solution cl type=vc;
*random intercept / subject=hhstandard solution cl type=vc;
*random intercept / subject=placeofres solution cl type=vc;
covtest / wald;
run;
quit;

ods startpage=yes;

* Model 2: Model 1 + ageatmar_cat + totchild_cat ;
title 'Model 2';
proc glimmix data=anemia method=laplace noclprint;
class state;

model hglevel =  ageatmar_cat totchild_cat
	/ dist=multinomial link=clogit solution cl oddsratio(diff=first label);

random intercept / subject=state solution cl type=vc;
covtest / wald;
run;
quit;


* Model 3: Model 2 + agemcat ;
title 'Model 3';
proc glimmix data=anemia method=laplace noclprint;
class state;

model hglevel =  ageatmar_cat totchild_cat agemcat
	/ dist=multinomial link=clogit solution cl oddsratio(diff=first label);

random intercept / subject=state solution cl type=vc;
covtest / wald;
run;
quit;

ods startpage=yes;

* Model 4: Model 3 + religion + litmother ;
title 'Model 4';
proc glimmix data=anemia method=laplace noclprint;
class state;

model hglevel = ageatmar_cat totchild_cat agemcat
	religion litmother	
	/ dist=multinomial link=clogit solution cl oddsratio(diff=first label);

random intercept / subject=state solution cl type=vc;
covtest / wald;
run;
quit;

ods startpage=yes;

* Model 5: Model 4 sexofchilc+hhstandard ;
title 'Model 5';
proc glimmix data=anemia method=laplace noclprint;
class state;

model hglevel = ageatmar_cat totchild_cat agemcat
	religion litmother
	hhstandard	placeofres sexofchild
	/ dist=multinomial link=clogit solution cl oddsratio(diff=first label);

random intercept / subject=state solution cl type=vc;
covtest / wald;
run;
quit;

ods rtf close;

* Model 5: Model 4 some interactions.
Results are not any better -- 
NO NEED TO USE THIS MODEL;
title 'Model 4 + some interactions';
proc glimmix data=anemia method=laplace noclprint;
class state;

model hglevel = ageatmar_cat totchild_cat 
	ageatmar_cat*hhstandard religion 
	ageatmar_cat*religion 
	ageatmar_cat*litmother 
	ageatmar_cat*totchild_cat
	litmother
	hhstandard	placeofres
	/ dist=multinomial link=clogit solution cl oddsratio(diff=first label);

random intercept / subject=state solution cl type=vc;
covtest / wald;
run;
quit;



/*
Model diagnostics for Model 3
NOT WORKING
*/

* plots=residualpanel not avialable for multinomial distribution;

* Model 3: Model 2 + agemcat ;
title 'Model 3';
proc glimmix data=anemia method=laplace noclprint 
plots=boxplot(random marginal conditional observed);
class state;

model hglevel =  ageatmar_cat totchild_cat agemcat
	/ dist=multinomial link=clogit solution cl oddsratio(diff=first label);

random intercept / subject=state solution cl type=vc;
covtest / wald;
run;
quit;


