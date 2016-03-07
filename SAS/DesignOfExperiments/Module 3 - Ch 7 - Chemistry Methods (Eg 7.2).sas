
/*
File: Module 3 - Ch7 - Chemistry Methods (Eg 7.2).sas
New methods of chemistry frequently are developed to assay
for compounds in a clinical laborary setting. Given the choice
among two or more chemistry methods, the clinical chemist must
evaluate the relative performance of the methods.

Research Question:
A chemist wanted to know whether the two chemistry methods
consistently provided equivalent results in an assay for
triglycerides in human serum. A methods comparison test was
constructed by the clinical chemist to evaluate the difference
in the performance of the two chemistry methods.

Treatment Design:
A factorial design was used with the factors "chemistry methods"
and "days". The two methods each were to be tested on four days,
for a 2x4 arrangement.

Experimental Design:
Each day two replicate samples of serum were prepared with 
each of the two chemistry methods. The samples were analyzed 
in random order on the same spectrophotometer for a completely 
randomized design with two replications. 

Outcome:
The obesrvations on triglyceride levels (mg/dl) in the serum
samples are recorded.

Analysis:
Fixed effect: Chemistry method (2 levels)
Random effect: Days (4 levels)
*/

data chem;
input method day levels;
cards;
1 1 142.3
1 1 144
1 2 134.9
1 2 146.3
1 3 148.6 
1 3 156.5
1 4 152
1 4 151.4
2 1 142.9
2 1 147.4
2 2 125.9
2 2 127.6
2 3 135.5
2 3 138.9
2 4 142.9
2 4 142.3
;
run;


proc print data = chem;
run;


* Summary Statistics and Exploratory Analysis;
title1 'Plot of the data by day';
symbol1 v=circle i=none c=black;
proc gplot data=chem;
plot levels*day; * you can also plot by method;
run;
title;

proc sort data = chem;
by day;
run;

*Calculate the means and plot them;
proc means data=chem;
output out=chemout mean=avlevels;
var levels;
by day;
run;


proc print data = chemout;
run;

title1 'Plot of averages by day';
symbol1 v=circle i=join c=black;
proc gplot data=chemout;
plot avlevels*day;
run;
title;



* Analysis of MIXEX effects model;
proc glm data = chem;
class method day;
model levels= method|day / ss3;
random day method*day/ test;

* Testing the difference between cell means;
* This is valid only if there is no significant interaction;
lsmeans day / pdiff;

* Testing the difference beteewn pairwise interactions;
lsmeans day*method / pdiff  ;

* Testing the effect of method on the interaction;
lsmeans day*method / slice=method plot=none;

* For random-effects model, testing the contrasts should be
based on the SS(Interaction) as the denominator;
contrast 'Method 1 vs 2' method 1 -1 / E=day*method;

* Comparing Day 1 Vs Day 2;
Contrast 'Day 1 vs 2' day 1 -1 0 0 / E=method*day;

contrast 'M1 vs M2' 
	method 1 -1
	method*day .25 .25 .25 .25 -.25 -.25 -.25 -.25 / e=method*day;
run;
quit;

* Repeation of the previous code with some 
more options added;

* Deriving/Obtaining the contrasts to compare;
* Suppose we want to compare M1 Vs M2;

* Example use of ESTIMATE and ORDER=data option;

proc glm order=data data=chem;
class method day;
model levels= method|day / ss3 solution;
random day|method / test;
* ORDER=specifies the sorting order for the levels of 
all classification variables;
* ORDER=data order of appearance in the input data set;

* For random-effects model, testing the contrasts should be
based on the SS(Interaction) as the denominator;

* ESTIMATE gives you t-values and coresponding p-values;
estimate 'M1 vs M2' 
	method 1 -1
	method*day .25 .25 .25 .25 -.25 -.25 -.25 -.25;

* Comparing M1 and M2;
contrast 'M1 vs M2 WorkedOut' 
	method 1 -1
	method*day .25 .25 .25 .25 -.25 -.25 -.25 -.25 / E= method*day;
* Verify that the above statemtent is equivalent to the following;
contrast 'M1 vs M2 METHOD' method 1 -1 / E= method*day; 
run;
quit;



* Analysis of random effects model
using PROC MIXED;
proc mixed data = chem cl;
class method day;
model levels=method;
random day method*day;

* Test for Method 1 vs 2;
contrast 'M1 vs M2 METHOD' method 1 -1; 
run;


* Analysis of mixed effects model
using PROC VARCOMP. 
Here method is fixed effect, 
day is a random effect;
proc varcomp data=chem;
class method day;
* one factor is fixed;
* Use the Model statement with FIXED=1 option;
model levels=method day method*day / fixed=1; 
run;

