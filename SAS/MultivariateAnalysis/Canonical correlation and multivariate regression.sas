
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




libname mydata 'C:\Users\Raheem\Documents\MyFolder\
UNCO\teaching\SRM 610\Core Materials\SAS Programs and Data Sets';
data depress;
set mydata.depress;
run;

proc print data=depress(obs=4);
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


/*
Canonical correlation analysis of 
depression data

*/

proc print data=depress (obs=5);
run;

proc freq data=depress;
tables health educat sex;
run;

* Create a new SAS data set
with selected variables;
data depress2;
set depress;
keep cesd health sex age educat income;
run;

proc print data=depress2 (obs=4);
run;

ods trace on;

proc means data=depress2 n mean median std maxdec=2 nolabels;
var cesd health sex age educat income;
run;

proc corr data=depress2;
run;



* Standardize the dat set (if you want);
proc standard data=depress2
mean=0 std=1 out=depress2;
run;

* print the data set;
proc print data=depress2 (obs=4);
run;

* Canonical correlation;
proc cancorr data=depress2 out=depress20 all 
vprefix=SocioEconomic vname= 'Socio-Economic Measurements' 
wprefix=QualityofHealth wname='Perceived Health'
;
var sex age educat income;
with cesd health;
run;

proc print data=depress20 (obs=4);
run;



/*
Multivariate Normality Test for the variables 
in a data set;
We will use a SAS macro located at:
http://support.sas.com/kb/24/983.html
*/

* First, tell SAS where to look for the macro file;
%inc "multnorm.sas";

* Templates for testing multivariate normality;
%multnorm(data=datafilename, var=var1 var2 var3, plot=mult)

* Template for testing univariate and multivariate normality;
%multnorm(data=datafilename, var=var1 var2 var3, plot=both)


* Example;
* Testing Multivariate normality ;

* Multivariate normality test;
%multnorm(data=depress2, 
var=sex age educat income cesd health,
plot=mult);

* Univariate+multivariate normality test;
%multnorm(data=depress2, 
var=sex age educat income cesd health, 
plot=both);





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


/* 
Fitness data analysis
*/

data Fit; 
      input Weight Waist Pulse Chins Situps Jumps; 
      datalines; 
   191  36  50   5  162   60 
   189  37  52   2  110   60 
   193  38  58  12  101  101 
   162  35  62  12  105   37 
   189  35  46  13  155   58 
   182  36  56   4  101   42 
   211  38  56   8  101   38 
   167  34  60   6  125   40 
   176  31  74  15  200   40 
   154  33  56  17  251  250 
   169  34  50  17  120   38 
   166  33  52  13  210  115 
   154  34  64  14  215  105 
   247  46  50   1   50   50 
   193  36  46   6   70   31 
   202  37  62  12  210  120 
   176  37  54   4   60   25 
   157  32  52  11  230   80 
   156  33  54  15  225   73 
   138  33  68   2  110   43 
   ; 
run;

proc cancorr data=Fit all 
vprefix=Physiological vname='Physiological Measurements' 
wprefix=Exercises wname='Exercises'; 
var Weight Waist Pulse; 
with Chins Situps Jumps; 
title 'Middle-Aged Men in a Health Fitness Club'; 
title2 'Data Courtesy of Dr. A. C. Linnerud, NC State Univ'; 
run; title;


/* 

For the depression data set, perform a canonical 
correlation analysis between the following: 

Set 1: AGE, MARITAL, EDUCAT, EMPLOY, INCOME
Set 2: the last seven variables: DRINK, HEALTH, 
REGDOC, TREAT, BEDDAYS, ACUTEILL, CHRONILL

*/

* Create a new SAS data set
with selected variables;
data depress3;
set depress;
keep AGE MARITAL EDUCAT EMPLOY INCOME
DRINK HEALTH REGDOC TREAT BEDDAYS ACUTEILL CHRONILL
;
run;

proc print data=depress3 (obs=4);
run;

* Canonical correlation analysis;
proc cancorr data=depress3 out=depress30 all;
var AGE MARITAL EDUCAT EMPLOY INCOME;
with DRINK HEALTH REGDOC TREAT BEDDAYS ACUTEILL CHRONILL;
run;

* Testing multivariate normality;
%multnorm(data=depress3, 
var=AGE MARITAL EDUCAT EMPLOY INCOME 
DRINK HEALTH REGDOC TREAT BEDDAYS ACUTEILL CHRONILL,
plot=mult);




