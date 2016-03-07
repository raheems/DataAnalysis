/*
Exercise on depression data;
*/


libname mydata 'C:\Users\Raheem\Documents\MyFolder\UNCO\teaching\SRM 610\Core Materials\SAS Programs and Data Sets';
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
tables cases; 
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

proc freq data=depress;
tables sex;
run;

*Linear discriminant analysis;
proc discrim data=depress pool=test slpool=.15 manova can out=discrim_results;
  class cases;
  var sex income age;
run;


* Printing the discrim_results SAS data set;
proc print data=discrim_results;
run;

* Verifying the group centroids;
proc means data=discrim_results;
class cases;
var can1;
run;

* Double check if te DISCRIM function scores have 
mean = 0, and std = 1;
proc means data = discrim_results n mean std maxdec=2;
var can1 ;
run;

proc print data=discrim_results (obs=4);
run;

* Plotting the discriminant function: can1;
proc gplot data = discrim_results;
plot can1*ID = _into_;
* you can choose to write plot ID * can1 = _into_;
* whichever you like;
run;
quit;


* leave-one-out crossvalidation;
proc discrim data=threesec pool=test slpool=.05 manova can crossvalidate;
  class section;
  var quiz midterm final;
run;

