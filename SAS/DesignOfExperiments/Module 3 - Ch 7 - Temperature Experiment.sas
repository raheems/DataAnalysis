
/*
Module 3 - Ch7 – Temperature Experiment.sas
*/

data temp;
input subject therm site temp;
cards;
1 1 1 62.16
2 1 1 65.63
3 1 1 63.12
4 1 1 61.51
1 1 2 61.53
2 1 2 63.70
3 1 2 61.34
4 1 2 61.54
1 2 1 154.42
2 2 1 132.30
3 2 1 105.52
4 2 1 94.88
1 2 2 310.46
2 2 2 284.64
3 2 2 315.61
4 2 2 294.16
1 3 1 95.98
2 3 1 98.50
3 3 1 110.05
4 3 1 107.93
1 3 2 225.65
2 3 2 241.63
3 3 2 364.07
4 3 2 304.58
;
run;



proc print data = temp;
run;

* Analysis of random effects model;
proc glm data = temp;
class therm site;
model temp= therm | site / ss3;
random therm|site / test;
run;
quit;

* Analysis of random effects model
using PROC MIXED ;
proc mixed data = temp cl;
class therm site;
model temp=;
random therm|site;
run;


* Analysis of random effects model
using PROC VARCOMP ;
proc varcomp data=temp;
class therm site;
model temp=therm|site;
run;

