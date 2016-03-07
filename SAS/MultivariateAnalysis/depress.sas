
ods rtf file='output.rtf';

data depress;
input id sex age;
cards;
1 1 20
2 2 25
3 2 30
4 1 49
;
run;

proc print data=depress;
run;

run;




libname mydata 'C:\Users\Raheem\Documents\MyFolder\UNCO\teaching\SRM 610\Core Materials\SAS Programs and Data Sets';
data depress;
set mydata.depress;
run;

* Loading from the remote desktop;
libname mydata "\\tsclient\C\Users\Raheem\Documents\MyFolder\UNCO\teaching\SRM 610\Core Materials\SAS Programs and Data Sets";
data depress;
set mydata.depress;
run;

proc print data=depress (obs=4);
run;

* Get an overall information about the data set;
proc contents data=depress;
run;

* Print only first 5 rows of data;
proc print data=depress (obs=5);
run;

proc freq data=depress;
tables drink; 
run;

proc freq data=depress;
table income;
run;



* FORMATs are like cloths for the barebone data;
proc format ;
   value SEX
      1 = 'male'  
      2 = 'female' ;
   value MARITAL
      1 = 'never married'  
      2 = 'married'  
      3 = 'divorced'  
      4 = 'separated'  
      5 = 'widowed' ;
   value EDUCAT
      1 = 'less than high school'  
      2 = 'some high school'  
      3 = 'finished high school'  
      4 = 'some college' ;
   value EMPLOY
      1 = 'full time'  
      2 = 'part time'  
      3 = 'unemployed'  
      4 = 'retired'  
      5 = 'houseperson'  
      6 = 'in school'  
      7 = 'other' ;
   value RELIG
      1 = 'protestant'  
      2 = 'catholic'  
      3 = 'jewish'  
      4 = 'none'  
      5 = 'other' ;
   value CA
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CB
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CC
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CD
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CE
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CF
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CG
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CH
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CI
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1A
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1B
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1C
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1D
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1E
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1F
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1G
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1H
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1I
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C1J
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value C2A
      0 = 'rarely or none of the time less than 1 d'  
      1 = 'some or a little of the time 1-2 days'  
      2 = 'occasionally or a moderate amount of the'  
      3 = 'most or all of the time 5-7 days' ;
   value CASES /* depressed is cesd >= 16 */
      0 = 'normal'  
      1 = 'depressed' ;
   value DRINK /* regular drinker? */
      1 = 'yes'  
      2 = 'no' ;
   value HEALTH /* general health */
      1 = 'excellent'  
      2 = 'good'  
      3 = 'fair'  
      4 = 'poor' ;
   value REGDOC /* have a regular doctor? */
      1 = 'yes'  
      2 = 'no' ;
   value TREAT /* Has a doctor prescribed or recommended that you take medicine, medical treatments, or change your way of living in such  */
      1 = 'yes'  
      2 = 'no' ;
   value BEDDAYS /* spent entire day(s) in bed in last two months? */
      0 = 'no'  
      1 = 'yes' ;
   value ACUTEILL /* any acute illness in last two months? */
      0 = 'no'  
      1 = 'yes' ;
   value CHRONILL /* any chronic illness in last year? */
      0 = 'no'  
      1 = 'yes' ;
run;

proc datasets ;
modify depress;
   format       SEX SEX.;
   format   MARITAL MARITAL.;
   format    EDUCAT EDUCAT.;
   format    EMPLOY EMPLOY.;
   format     RELIG RELIG.;
   format        C1 CA.;
   format        C2 CB.;
   format        C3 CC.;
   format        C4 CD.;
   format        C5 CE.;
   format        C6 CF.;
   format        C7 CG.;
   format        C8 CH.;
   format        C9 CI.;
   format       C10 C1A.;
   format       C11 C1B.;
   format       C12 C1C.;
   format       C13 C1D.;
   format       C14 C1E.;
   format       C15 C1F.;
   format       C16 C1G.;
   format       C17 C1H.;
   format       C18 C1I.;
   format       C19 C1J.;
   format       C20 C2A.;
   format     CASES CASES.;
   format     DRINK DRINK.;
   format    HEALTH HEALTH.;
   format    REGDOC REGDOC.;
   format     TREAT TREAT.;
   format   BEDDAYS BEDDAYS.;
   format  ACUTEILL ACUTEILL.;
   format  CHRONILL CHRONILL.;
run;
quit;


* Now after formatting the data, let's see the FREQ tables;
proc freq data=depress;
table drink;
run;

/*
 Bar chart of marital status;
*/
title 'Bar Graph of marital status';
proc sgplot data=depress;
  yaxis label="Percentages";
  xaxis label = "Marital status";
  vbar marital;
run;
title;

* Drawing bar graph with percentages along the vertical axes;
proc freq data=depress noprint;
tables marital / out=out_marital;
run;
 
data out_marital;
  set out_marital;
  label pct='Percent';
  format pct percent.;
  pct=percent/100;
  run;
 
proc print data = out_marital; 
run;

title 'Distribution by marital status';
proc sgplot data=out_marital;
  vbar marital / response=pct datalabel;
  yaxis grid display=(nolabel);
  xaxis label="Marital status";
  format marital marital.;
  run;
title;


* Histogram of cesd variable;
title 'Bar Graph of CESD variables';
proc sgplot data=depress;
  yaxis label="Percentages";
  xaxis label = "Cards";
  vbar CESD;
run;

title;


/*
Now create a frequency table for the CESD variable
and then create a histogram of CESD.
*/

proc freq data=depress;
tables CESD;
run;

* Histogram of cesd variable;
proc univariate data=depress noprint;
	histogram cesd;
run;
title;


/*
Transformation of CESD variable to CESD2;
*/

* For this purpose, we create a new sas
data set called depress2;
data depress2;
 set depress;
 cesd2 = sqrt(cesd); * takes square-root of cesd;
run;

proc print data=depress2 (obs=10);
var cesd cesd2;
run;

proc univariate data=depress2;
histogram cesd2;
run;

* Histogram of income;
proc freq data=depress ;
table income;
run;

proc univariate data=depress noprint;
histogram income;
run;


* Normal probability plots;

symbol v=plus;
title 'Normal Probability Plot for CESD';
proc capability data=depress noprint;
   probplot cesd;
run;

* Normal probability plot 	;
proc univariate data=depress noprint;
 probplot cesd / normal(mu=est sigma=est);
run;

proc univariate data=depress noprint;
 qqplot cesd / normal (mu=est sigma=est);
run;



/* 
Exercise and solutions
*/

/*
For the depression data create a frequency table 
for each of the following variables: 
sex, marital status, employment status, 
whether regular drinker or not, 
have a regular doctor?

*/


proc freq data=depress;
tables sex marital employ drink regdoc;
run;
 

/*
Now create a frequency table for the INCOME variable. 
Draw a histogram of the INCOME variable and comment on the shape of the distribution.
*/
proc freq data=depress ;
table income;
run;

proc univariate data=depress noprint;
histogram income;
run;


/*
Using the depression data set, create a variable equal to the 
negative of one divided by the cubic root of income. 
Display a normal probability plot of the new variable.
*/

* Data transformation;
data depress2;
set depress;
income2 = -1/(income**(1/3));
run;

* Assessing normality using QQplot;
proc univariate data=depress2;
qqplot income2 /normal(mu=est sigma=est);
run;

* Histogram;
proc univariate data=depress2;
histogram income2;
run;

/*
Take the natural logarithms of the CESD score plus 1 
and compare the histograms of CESD and log(CESD). 
Why do you have to add 1 to the CESD score? 
*/

* Data transformation;
data depress2;
set depress;
cesd2 = cesd+1;
cesd2 = log(cesd2);
run;

* Assessing normality using QQplot;
proc univariate data=depress2;
qqplot cesd2 /normal(mu=est sigma=est);
run;

* Histogram;
proc univariate data=depress2;
histogram cesd2;
run;

