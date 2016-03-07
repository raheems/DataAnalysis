
/*
Module 4 SAS Program file
*/

/*
Analysis of unreplicated design
*/

data chem;
input A B C D y ;
cards;
-1 -1 -1 -1 45
+1 -1 -1 -1 41
-1 +1 -1 -1 90
+1 +1 -1 -1 67
-1 -1 +1 -1 50
+1 -1 +1 -1 39
-1 +1 +1 -1 95
+1 +1 +1 -1 66
-1 -1 -1 +1 47
+1 -1 -1 +1 43
-1 +1 -1 +1 95
+1 +1 -1 +1 69
-1 -1 +1 +1 40
+1 -1 +1 +1 51
-1 +1 +1 +1 87
+1 +1 +1 +1 72
;
run;

proc print data = chem;
run;

*ods trace on;
proc glm data=chem;
model y = A|B|C|D /solution;
*model y = A|B|C|D;
* Saving the parameter estimates to a file 
called sol;
ods output ParameterEstimates=sol;
run;
quit;
*ods trace off;


proc print data=sol;
run;

* Creating data for normal probability plot;
* Removing unnecessary rows and columns;
data nplot;
 set sol;
 if _n_>1;
  drop StdErr tValue Probt;
run;

proc print data=nplot;
run;

* Proc RANK calculates normal scores for 
  parameter estimates;
proc rank data=nplot 
out = nplots normal=blom;
var estimate;
ranks zscore;
run;

proc print data=nplots;
run;

* Removing the effects labels 
which are outside |z| <=1.2;
data nplots2;
 set nplots;
 if abs(zscore) <= 1.2 
 then parameter=' ';
run;

proc print data=nplots2;
run;

 * Now plot the effects agains the normal scores;
 proc sgplot data=nplots2;
 scatter x=zscore y=estimate/datalabel=parameter;
 xaxis label='Normal Scores';
 run;

* Half normal probability plot;
 data halfn;
  set sol;
  estimate = abs(estimate);
  if _n_>1;
   drop StdErr tValue Probt;
run;

proc print data=halfn;
run;


proc rank data=halfn out=hnplot;
var estimate;
ranks rnk;
run;

proc print data=hnplot;
run;

data hnplots;
 set hnplot;
zscore=probit((((rnk-0.5)/15)+1)/2);
if abs(zscore) <=1.2 
 then parameter =' ';
run;

proc print data=hnplots;
run;

proc sgplot data=hnplots;
scatter x=zscore y=estimate/datalabel=parameter;
xaxis label='Half Normal Scores';
run;


* To get the interaction plots
we run the simple model with 
A|B only;

proc glm data=chem plots=diagnostics;
class A B;
model y = A|B;
lsmeans A*B / slice=B;
run;
quit;

* To get the contour plot,
run the model considering A, B
to be continuous variables;
proc glm data=chem;
model y = A|B;
run; quit;
