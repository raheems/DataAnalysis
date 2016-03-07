
/*
Latin Square Design. 
*/

* Creating a data collection plan using 
* Latin square design;
proc plan seed=100;
factors rows=5 ordered cols=5 ordered/noprint;
treatments trt=5 cyclic;
output out = lsd
rows cvals=('Batch 1' 'Batch 2' 'Batch 3' 'Batch 4' 'Batch 5') ordered
cols cvals=('Op 1' 'Op 2' 'Op 3' 'Op 4' 'Op 5') random
trt nvals=(1 2 3 4 5) random;
run;

* Printing the data which can be used 
as a data collection form;
proc print data=lsd;
run;

* To verify the Latin square design, 
run the following code and verify that
each trt is appearing in each and and each 
column once;
proc tabulate data=lsd;
class rows cols;
var trt;
table rows, cols*(trt*f=2.);
run;

/*
Example from Montgomery:

An experimenter is interested in studying the effects of five
different formulations of a rocket propellant used in aircrew 
escape systems on the observed burning rate.

Outcome= burning rate
Block 1: batches of raw material (5)
Block 2: Operators (5)
Treatment: formulation (coded as A, B, C, D, E)

*/

*ods html close;
*ods html;

data raw;
input batch operator formulation $ rate ;
cards;
1 1 A 24
1 2 B 20
1 3 C 19
1 4 D 24
1 5 E 24
2 1 B 17
2 2 C 24
2 3 D 30
2 4 E 27
2 5 A 36
3 1 C 18
3 2 D 38
3 3 E 26
3 4 A 27
3 5 B 21
4 1 D 26
4 2 E 31
4 3 A 26
4 4 B 23
4 5 C 22
5 1 E 22
5 2 A 30
5 3 B 20
5 4 C 29
5 5 D 31
;
proc print data=raw;
run;


proc glm data=raw plot=diagnostics;
class batch operator formulation;
model rate = formulation batch operator;
means formulation / cldiff tukey;
lsmeans formulation /pdiff adjust=tukey;
output out=rawout residuals=res predicted=pred;
run;
quit;

* Double check the residual plot;
* You don't need it since PLOT=DIAGNOSTICS
gives you the same plot;
proc gplot data = rawout; 
symbol1 v=circle;
plot res*pred;
run;
quit;



/* 
Bioequivalence Study. Lawson, page. 135

Consider the following bioequivalence study. 
The purpose was to test the bioequivalence of three formulations 
(A=solution, B=tablet, C=capsule) of a drug as measured by the 
AUC or area under the curve, which related the concentration 
of the drug in the blood as a function of the time since dosing.

Three volunteer subjects took each formulation in succession 
with a sufficient washout period between.

After dosing, blood samples were obtained every half-hour 
for four hours and analyzed for drug concentration.  
AUC was calculation with the resulting data.

Since there may be large variation in metabolism of the drug 
from subject to subject, subject was used as a row blocking factor. 

Since absorption and metabolism of a drug will vary from 
time to time for a particular subject, time was used as a 
column blocking factor.

*/

data bioequiv;
input subject period formulation $ auc;
cards;
1 1 A 1186
1 2 B 642
1 3 C 1183
2 1 B 1135
2 2 C 1305
2 3 A 984
3 1 C 873
3 2 A 1426
3 3 B 1540
;
run;

* Print the data;
proc print data=bioequiv;
run;

* Statistical Analysis;

proc glm data=bioequiv;
 class subject period formulation;
 model auc = subject period formulation;
 lsmeans formulation / pdiff adjust=tukey;
run;
quit;



/*
(Montgomery, p. 159) An industrial engineer is 
investigating the effect of four assembly 
methods (A, B, C, D) on the assembly time for a 
color TV component. 

Four operators are selected for the study. 
Furthermore, the engineer knows that each assembly
method produces such fatigue that the time required 
for the last assembly may be greater than the time 
required for the first, regardless of the method.

To account for this source of variability, the 
engineer uses the Latin square design shown on the next slide. 
Analyze the data and draw conclusion.

Suppose the engineer suspects that the workplace used 
by the four operators may represent additional source 
of variation.

A fourth factor, workplace (alpha, beta,gamma, delta) 
may be introduced and another experiment conducted 
yielding the Graeco-Latin square that follows. 

order (row): order of assembly: 1, 2, 3, 4
operator (column): 1, 2, 3, 4
method (assembly method): 1, 2, 3, 4
workplace: 1, 2, 3, 4
time (assembly time): Response variable
*/


data tv;
input order operator method $ workplace $ time;
cards;
1 1 C beta 11
1 2 B gamma 10
1 3 D delta 14
1 4 A alpha 8
2 1 B alpha 8
2 2 C delta 12
2 3 A delta 10
2 4 D beta 12
3 1 A delta 9
3 2 D alpha 11
3 3 B beta 7
3 4 C delta 15
4 1 D gamma 9
4 2 A beta 8
4 3 C alpha 18
4 4 B delta 6
;
run;
 
proc print data=tv;
run;

proc glm data=tv;
class order operator method workplace;
model time = order operator method workplace / ss3;
lsmeans workplace /pdiff adjust=tukey;
run;
quit;

proc glm data=tv;
class order operator method workplace;
model time = order operator method ;
lsmeans operator /pdiff adjust=tukey;
run;
quit;


