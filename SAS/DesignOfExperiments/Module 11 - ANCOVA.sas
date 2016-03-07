
/* 
Single factor ANCOVA:

Suppose three different teaching styles will be tested for their
effects on the students overall performance in a given course.

To eliminate instructor effects, the same instructor teaches
all three sections using three different teaching methods.

It is reasonable to assume that the students' existing GPA will
have an effect on the performance on this particular course. 

Therefore, we should analyze the data after adjusting the course score
for GPA.
*/

data teach;
input style score gpa;
cards;
1 91 3.9
1 90 3.3
1 81 3.5
1 85 4
1 92 4
1 90 3.8
1 88 3.6
1 84 3.8
2 79 3.5
2 77 2.9
2 73 3.0
2 75 3.1
2 84 3.4
2 78 2.8
2 70 2.9
2 85 3.5
2 77 3.5
3 89 4
3 87 3.9
3 88 4
3 83 3.8
3 86 3.9
3 73 2.8
3 71 2.6
3 76 3.9
;
run;

proc print; run;

* Scatterplot of the data;
* Not useful;
proc gplot data = teach;
plot score*gpa;
run;

* Scatterplot using SGPLOT;
title "Scatterplot of Students' Data";
proc sgplot data=teach;
  scatter x=gpa y=score / group=style;
run;
quit;
title;

* Another way to draw scatterplot: Scatterplotmatrix;
proc sgscatter data=teach;
  title "Scatterplot Matrix for Students' Data";
  matrix score gpa / group=style;
run;


* Calculate correlation between the scores and gpa;
title 'Correlation Coefficient between GPA and Score';
proc corr data = teach;
var score gpa;
run;
title;

* Unadjusted Analysis with Tykey;
proc glm data = teach;
class style;
model score = style;
lsmeans style / adjust = tukey pdiff;
run;
quit;


* Adjusted Analysis with Tukeys procedure;
proc glm data = teach;
class style;
model score = gpa stylse;
lsmeans style / adjust=tukey pdiff;
run;
quit;

* Adjusted Analysis with Tukeys procedure;
proc glm data = teach;
class style;
model score =  style gpa;
lsmeans style / adjust=tukey pdiff;
run;
quit;



/*****************************************
2^3 factorial experiment with covariates.
******************************************/


* Design generator for a 2^3 factorial experiment 
with 2 replications;
proc factex;
factors C B A;
output out= ex2 designrep=2 /* save design, replicated 2 times*/
C nvals=(-1 1) 
B nvals=(-1 1)
A nvals=(-1 1)
;
proc print;
run;

data ex2;
retain A B C; /* reordering variables */
set ex2; /* Read the generated design data */
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
* With two replications, we cannot have tests
for any of the effects; 
proc glm data = ex3;
class A B C AB AC BC ABC;
model y = X A|B|C AX BX CX ABX ACX BCX ABCX;
run;
quit;

*Assuming negligible, remove the effect of ABC and ABCX;
proc glm data = ex3;
class A B C AB AC BC ABC;
model y = X A B C AB AC BC AX BX CX ABX ACX BCX;
run;
quit;


* Drop AC, BC, CX, BCX, ACX;
proc glm data = ex3;
class A B C AB AC BC ABC;
model y = X A B C AB AX BX ABX ;
run;
quit;

* Diagnostic tests for the final model;
proc glm data = ex3 plots= diagnostics;
class A B C AB AC BC ABC;
model y = X A B C AB AX BX ABX ;
run;
quit;

* Automatic variable selection using PROC REG;
* Final model is found to be the same as we've found,
which is, y = X A B C AB  AX BX ABX;

ods output SubsetSelSummary=SelectionSummary;
proc reg data=ex3 ;
model y = X A B C AB BC AC ABC AX BX CX ABX ACX BCX ABCX
		/selection= adjrsq;
run;quit;

proc sort data=SelectionSummary 
          out=sorted;
     by NumInModel;
run;

proc print data=sorted;
run;



/***********************************
Test for Homogeneity
***********************************/

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


* Test for AX BX, ABX together;
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

