
/* 
2^3 factorial experiment with covariates.

*/


* Design generator for a 2^3 factorial experiment with 2 replications;
proc factex;
factors C B A;
output out= ex2 designrep=2 /* save design, replicated 2 times*/
C nvals=(-1 1) 
B nvals=(-1 1)
A nvals=(-1 1)
;
* proc print;
run;

data ex2;
retain A B C; /* reordering variables */
set ex2; /* Read the generated design data */
* Interactions;
input x y ; /*Covariate = x,  Response = y */
cards;
4.05 -30.73
.36 9.07
5.03 39.72
1.96 16.30
5.38 -26.39
8.63 54.58
4.10 44.54
11.44 66.20
3.58 -26.46
1.06 10.94
15.53 103.01
2.92 20.44
2.48 -8.94
13.64 73.72
-.67 15.89
5.13 38.57
;
run;
 proc print; run;


data ex3;
set ex2;
	AB = A*B;
	AC = A*C;
	BC = B*C;
	ABC = A*B*C;
	Ax = A*x;
	BX = B*X;
	CX = C*X;
	ABX= AB*X;
	ACX = AC*X;
	BCX = BC*X;
	ABCX = ABC*X;
run;

proc print; run;

* Scatterplot of the data;
proc gplot data = ex2;
plot x*y;
run;

* Calculate correlation between the scores and gpa;
proc corr data = ex2;
var x  y;
run;

* Unadjusted analysis;
proc glm data = ex3  plots = diagnostics;
class A B C;
model Y =  A|B|C ;
run;
quit;

* Unadjusted Analysis;
* With two replications, we cannot estimate all the
interactions with the covariate; 
proc glm data = ex3;
class A B C AB AC BC ABC;
model y = X A|B|C AX BX CX ABX ACX BCX ABCX;
run;
quit;

* Drop AC, CX, BCX, ACX;
proc glm data = ex3;
class A B C AB AC BC ABC;
model y = X A B C AB BC AX BX ABX ;
run;
quit;

* Drop BC;
proc glm data = ex3 plots= diagnostics;
class A B C AB AC BC ABC;
model y = X A B C AB AX BX ABX ;
run;
quit;


* The above model is your final model;

* Now carry out test for homogeneity of regression slope;
* We use extra sum of squares principle;

* Test for Ax:
* Include this effect as the last element in the model
* and use Type I SS to test for its significance.
* Note that Type I and TYpe III results would be the same in this case 

* Full model;
proc glm data = ex3;
class A B C;
model y = X A B C AB  BX ABX AX ;
run;
quit;


 *Test for AX BX, ABX together;
* Full model;
proc glm data = ex3;
class A B C;
model y = X A B C AB AX BX ABX;
run;
quit;

* Reduced model excluding AX BX ABX ;
proc glm data = ex3 plots= diagnostics;
class A B C;
model y = X A B C AB;
run;
quit;

* p-value for F0= 277.317 with 3 and 7 df;
data a1;
x=277.317;
y=1-probf(x, 3, 7);
run;

proc print;run;

