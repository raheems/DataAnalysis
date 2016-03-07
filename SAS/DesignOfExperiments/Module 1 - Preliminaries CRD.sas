
/* 
SRM 608
Module 1: Preliminaries
File name: Module 1 - Preliminaries CRD.sas
Author: Enayetur Raheem 

Example to show how to randomly assign treatments to 
experimental units;

In our example, the treatments are amount of nitrates 
(5 levels = 5 treatments) 

The experimental units are field plots to which the treatments
will be applied.

*/


* Create a CRD;
proc factex;
 factors nitrate/nlev=5;
 output out=crd nitrate nvals=(0 50 100 150 200) designrep=4 randomize;
 run;
 quit;

* Print the CRD data set just created;
 proc print data=crd;
 run;

 * Create data collection sheet;
 data list; set crd;
 Plot =_n_;
 lettuce ='_ _ _ _ _';
 run;

 * Print the data collection form;
 proc print ;
 title 'Data Colletion Form';
 var nitrate lettuce;
 id Plot;
 run;



* Data for Analysis;
* Analysis of variance of a completely randomized design;

data nitrate;
input nitrate lettuce;
datalines;
0 104
0 114
0 90 
0 140
50 134
50 130 
50 144
50 174
100 146
100 142
100 152
100 156
150 147
150 160
150 160
150 163
200 131
200 148
200 154
200 163
;
run;

proc print data=nitrate;
run;

* Getting the cell means;
proc means data=nitrate mean maxdec=2;
class nitrate;
var lettuce ;
run;

* Basic Analysis;

title;
proc glm;
class nitrate;
model lettuce = nitrate;
estimate '1 vs 2' nitrate 1 -1 0 0 0 ;
estimate '1 vs 2 vs 3' nitrate 1 -1 -1 0 0;
*means nitrate; * Calculates and returns sample cell means- \bar{y}_i. ;
*lsmeans nitrate; *Calculates least-squares estimates of the means. \mu + \tau_i;
* In one-way ANOVA model, means and lsmeans are identical;
run;
quit;


* Contrast Procedure;
* 0 50 100 150 200;

proc glm;
class nitrate;
model lettuce = nitrate;
contrast 'Compare 0 vs all others' nitrate 1 -.25 -.25 -.25 -.25;
contrast '50 vs all others' nitrate 1 -4 1 1 1;
contrast '100lb vs 200lb' nitrate 0 0 1 0 -1 ;
contrast '0+50 with 100+200' nitrate 1 1 -1 0 -1;
contrast '0+50 with all others' nitrate 1 1 -.66 -.67 -.67;
run;
quit;

* Multiple Comparison;

* Tukey's HSD;
proc glm;
class nitrate;
model lettuce = nitrate;
means nitrate / tukey cldiff ;
lsmeans nitrate / pdiff adjust=tukey; 
run;
quit;

* Studend Newman Keuls method;
proc glm;
class nitrate;
model lettuce = nitrate;
means nitrate / snk ;
run;
quit;

* Dunnett's method to 
compare with a contrast;
proc glm;
class nitrate;
model lettuce = nitrate;
means nitrate / dunnett('0');
means nitrate/dunnett('200');
run;
quit;



/* 
Trend Analysis
P. 83 of Kuehl;
*/

title 'Number of Lettuce Procued at each Nitrate Level';
proc sgplot data=nitrate;
scatter x=nitrate y=lettuce;
run;
title;


title 'Orthogonal Polynomial Effects';
proc iml;
 t={0 50 100 150 200}; *Treatment levels;
 C = orpol(t);
 print C;
quit;
title;


* Test for polynomial contrasts;
proc glm;
class nitrate;
model lettuce = nitrate;
contrast 'Linear' nitrate .63 .31 0 -.31 -.63;
contrast 'Quadratic' nitrate .54 -.27 -.54 -.27 .54;
contrast 'Cubic' nitrate -.32 .63 0 -.63 .32;
contrast 'Quartic' nitrate .12 -.48 .72 -.48 .12;
run;
quit;




/* 
Model diagnostics check;
- Test for residuals
- Residual vs predicted values plot
*/

* Obtaining the residuals for visual inspection/understanding;
proc glm;
class nitrate;
model lettuce = nitrate;
output out=glmout p = predicted r=residual;
run;quit;

* Now print the glmout data that contains residuals;
proc print data=glmout;
title 'Data with the Predicted values and the Residuals';
run;
title;

* Obtaining the studentized residuals;
data student;
set glmout; * Reading the previously created SAS data set;
runorder=_n_;
stres = residual/sqrt(222.53);
run;

* Print student data set with all the variables;
proc print data = student;
run;


* Check for non-constant variance;
* Plotting studentized residual vs predicted values;
proc gplot data=student;
plot stres*predicted;
run;


* Easier way to do all the diagnostic plots;
proc glm data=nitrate plots=diagnostics(unpack);
class nitrate;
model lettuce = nitrate;
run;
quit;

* Checking independence of errors;
* Plot residuals vs time or sequence of tests (order of tests);
* To do this, we need a variable that records the run order or sequence number;
proc gplot data=student;
plot stres*runorder;
run;


* Boxplot to check for outliers;
  proc boxplot data=student;
      plot (stres)*nitrate;
  run;

* Test for normality using normal probability plot; 
proc univariate data=student normal plot;
var stres;
probplot/normal(mu=est sigma=est);
inset normal;
run;

* Homogeneity of Variance test in one-way ANOVA;
proc glm data =nitrate;
class nitrate;
model lettuce = nitrate;
means nitrate / hovtest=bf hovtest=bartlett;
run;
quit;

* Box-Cox transformation using SAS;
proc transreg data=nitrate;
model boxcox(lettuce/convenient) = identity(nitrate);
run;
* This selects lambda=1 as the appropriate 
transformation of lettuce;
* In other words, no transformation is needed;



/* 
Exercise 4.1, p. 144 of Kuehl;

NOTE:
If you wish to use these codes as is, make sure to run them sequentially
from top to the bottom. Because some of the later statements overwrite
previous variables and data sets, running sequentially will ensure 
that the results are correct. 
*/

options linesize=72; *output is suitable for viewing on letter paper;

*ods html close; *Closing any existing html output;
*ods html; *openning a new html output page;

data lifetest;
input level temp hours ;
datalines;
1	1520	1953
1	1520	2135
1	1520	2471
1	1520	4727
1	1520	6134
1	1520	6314
2	1620	1190
2	1620	1286
2	1620	1550
2	1620	2125
2	1620	2557
2	1620	2845
3	1660	651
3	1660	837
3	1660	848
3	1660	1038
3	1660	1361
3	1660	1543
4	1708	511
4	1708	651
4	1708	651
4	1708	652
4	1708	688
4	1708	729
;
run;

* Printout the data;
proc print data=lifetest;
run;


* Analysis of variance of a completely randomized design;
proc glm data=lifetest plots=diagnostics(unpack);
class temp;
model hours = temp;
output out=glmout p = predicted r=residual;
run;
quit;

* Printing the glmout data (if you want);
proc print data=glmout;
run;


* Model diagnostics;
* Obtaining the studentized residuals;
data student;
set glmout; * Reading the previously created SAS data set;
stres = residual/sqrt(1170936.11);
run;


* Print student data set with all the variables;
proc print data = student;
run;


/* 
- Plotting studentized residual vs predicted values;
- Useful for detecting nonhomogeneity of variance;
- Useful for detecting patterns in the residuals as the 
predicted response increases;
*/

proc gplot data=student;
plot stres*predicted;
run;

* Plotting studentized residual vs levels of the factor;
proc gplot data=student;
plot stres*temp;
run;

* Boxplot for each level of treatment to check for outliers;
  proc boxplot data=student;
      plot (stres)*temp;
  run;


* Test for normality using normal probability plot;
proc univariate data=student normal plot;
var stres;
probplot/normal(mu=est sigma=est color=BLUE l=1 w=1);
inset normal;
run;


* Homogeneity of Variance test in one-way ANOVA;
proc glm;
class temp;
model hours = temp;
means temp / hovtest; * default is Levine's test;
means temp / hovtest=bf; * Brown and Forsyth's test;
* We could also use; 
* hovtest=bf (for Brown and Forsyth's test);
* hovtest=bartlett (for performing Bartlett's test);
run;
quit;


/*****************************************
Data transformation and diagnostic checks 
*****************************************/

* Finding lambda automatically;
proc transreg data=lifetest; 
* model BoxCox(hours / convenient) = identity(temp); 
model BoxCox(hours) = identity(temp); 
run; 

*With CONVENIENT, we get lambda = -1 --> reciprocal transformation;
*Without CONVENIENT, we get lambda= -1/2 --> reciprocal of square-root transformation;
* So, let's try both;

/*
 Transformation to stabilize variance;
*/

* First we try the log-transformation as suggested
by the BOXCOX method;

* log transformation;
data lifetest1;
set lifetest;
hours2 = log(hours);
run;


* Reciprocal square-root transformation;
data lifetest2;
set lifetest;
hours2 = 1/sqrt(hours);
run;

* Reciprocal transformation;
data lifetest3;
set lifetest;
hours3 = 1/hours;
run;

* Analysis of variance of a completely randomized design
with log transformed data;
proc glm data=lifetest1 plots=diagnostics;
class temp;
model hours2 = temp;
run;
quit;


* Analysis of variance of a completely randomized design
with reciprocal square-root transformed data;
proc glm data=lifetest2 plots=diagnostics;
class temp;
model hours2 = temp;
run;
quit;

* Analysis of variance of a completely randomized design
with reciprocal transformed data;
proc glm data=lifetest3 plots=diagnostics;
class temp;
model hours3 = temp;
run;
quit;


* Homogeneity of Variance test in one-way ANOVA
using original data;
proc glm data=lifetest;
class temp; 
model hours = temp;
means temp / hovtest; * default is Levine's test;
means temp / hovtest=bf; * Brown and Forsyth's test;
means temp / hovtest=bartlett; * Bartlett's test;
run;
quit;

* Homogeneity of Variance test in one-way ANOVA
using log transformation;
proc glm data=lifetest1;
class temp; 
model hours2 = temp;
means temp / hovtest; * default is Levine's test;
means temp / hovtest=bf; * Brown and Forsyth's test;
means temp / hovtest=bartlett; * Bartlett's test;
run;
quit;

* Homogeneity of Variance test in one-way ANOVA
using reciprocal square-root transformation;
proc glm data=lifetest2;
class temp; 
model hours2 = temp;
means temp / hovtest; * default is Levine's test;
means temp / hovtest=bf; * Brown and Forsyth's test;
means temp / hovtest=bartlett; * Bartlett's test;
run;
quit;

* Homogeneity of Variance test in one-way ANOVA
using reciprocal transformation;
proc glm data=lifetest3;
class temp; 
model hours3 = temp;
means temp / hovtest; * default is Levine's test;
means temp / hovtest=bf; * Brown and Forsyth's test;
means temp / hovtest=bartlett; * Bartlett's test;
run;
quit;


/*
SAMPLE SIZE CALCULATION
*/

* Power analysis using PROC POWER;

* Cauculate power for a given # replication;
* Scenario 1;
proc power;
 onewayanova 
 groupmeans = 112|145|149|157|149
 stddev = 15
 npergroup = 4
 power=.;
run;


* Scenario 2;
* Calculating the grand sample mean;
* We get grand mean == 143;
proc means data=nitrate;
var lettuce;
run;

* Now we assume the mean number of lettuce
for treatment levels 50, 100, 150 to be 146;
proc power;
 onewayanova 
 groupmeans = 112|146|146|146|149
 stddev = 15
 npergroup = 4
 power=.;
run;

* Scenario 3;
* Consider different st.dev;
proc power;
 onewayanova 
 groupmeans = 112|146|146|146|149
 stddev = 10 15 20 25
 npergroup = 4
 power=.;
run;

* Scenario 4;
* Sample size for a given power 
and different st.dev;
proc power;
 onewayanova 
 groupmeans = 112|146|146|146|149
 stddev = 10 15 20 25
 npergroup = .
 power=.8;
run;

* Scenario 5;
* Power curve for 
different n; 
proc power;
 onewayanova 
 groupmeans = 112|146|146|146|149
 stddev = 10 15 20 25
 npergroup = 4.
 power=.;
 plot x=n min=2 max=10;
run;


* USE of PROC GLMPOWER;
proc glmpower data=nitrate;
 class nitrate;
 model lettuce = nitrate ;
 power
  stddev = 10 to 20 by 5
  ntotal = 20 to 80 by 20
  power  = .;
  plot x=n min=20 max=80;
run;

