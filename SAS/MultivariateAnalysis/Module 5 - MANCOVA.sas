
/* 
Module 5: MANCOVA
SAS file: Module 5 - MANCOVA.sas
*/

/*
Consider an example to review single factor ANCOVA:

Suppose three different teaching styles will be tested for their
effects on the students' overall performance in a given course.

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

proc print data = teach ; 
run;

* Is it a balanced design?; 
proc means data=teach;
var gpa;
by style;
run;



* Understanding SS1 and SS3;
* Unadjusted Analysis;
proc glm data = teach;
class style;
model score = style;
run;
quit;

* Comparing ss1 and ss2;
* Notice the order of covariates in model;
proc glm data = teach;
class style;
model score = gpa style;
run;
quit;

* Order changed;
proc glm data = teach;
class style;
model score = style gpa;
run;
quit;



* Summary statistics;
proc means data = teach n mean var;
var score gpa;
by style;
run;


* Scatterplot of the data;
proc gplot data = teach;
plot score*gpa; /*y * x plot*/
run;
quit;

* Another way to draw scatterplot;
proc sgplot data=teach;
  scatter x=gpa y=score / group=style;
run;

* Another way to draw scatterplot;
proc sgscatter data=teach;
  title "Scatterplot Matrix for Students' Data";
  matrix score gpa / group=style;
run;
title;


* Calculate correlation between the scores and gpa;
proc corr data = teach;
var score gpa;
run;


* Unadjusted Analysis;
proc glm data = teach;
class style;
model score = style;
run;
quit;

* Unadjusted Analysis with Tykey;
proc glm data = teach;
class style;
model score = style;
lsmeans style / adjust = tukey pdiff;
run;
quit;


* Adjusted Analysis;
proc glm data = teach;
class style;
model score = gpa style gpa*style;
run;
quit;

* Adjusted Analysis with Tukeys procedure;
proc glm data = teach;
class style;
model score = gpa style;
lsmeans style / adjust=tukey pdiff;
run;
quit;

* Testing for homogeneity of regression;
proc glm data = teach plots=diagnostics;
class style;
model score = gpa style gpa*style;
run;
quit;


/**************************************************
MANCOVA
*************************************************/

*ods html close;
*ods html;

/* Data available on P. 256 of textbook;
Treatment: 1= treatment, 2=control
Disability: 1=Mild, 2=Moderate, 3=Severe
*/

proc format;
value treatf 1='Treatment' 2='Control';
value disf 1='Mild' 2='Moderate' 3='Severe';
run;

data p7_1;
input treatment disability wratr wrata iq;
format treatment treatf. disability disf.;
cards;
1 1 115 108 110
1 1 98 105 102
1 1 107 98 100
2 1 90 92 108
2 1 85 95 115
2 1 80 81 95
1 2 100 105 115
1 2 105 95 98
1 2 95 98 100
2 2 70 80 100
2 2 85 68 99
2 2 78 82 105
1 3 89 78 99
1 3 100 85 102
1 3 90 95 100
2 3 65 62 101
2 3 80 70 95
2 3 72 73 102
;
run;

proc print;run;

* GLM procedure for MANOVA;
proc glm data = p7_1;
	class  disability treatment;
	model wratr wrata = treatment disability treatment*disability / nouni;
	*manova h = treatment disability / short;
	manova h = _all_ /printe;
run;
quit;


* GLM procedure for MANCOVA;
* Use NOUNI in the MODEL statement to suppress univariate outputs;
proc glm data = p7_1;
	class  disability treatment;
	model wratr wrata = iq treatment disability treatment*disability /nouni;
	*manova h = treatment disability / short;
	manova h = _all_ /htype=1 printe;
	* htype=1 indicates Type I SSCP for the H matrix;
run;
quit;

* Now put the IQ as the last element in the model statement
* you should get the same results as a Type III SS for IQ.
* GLM procedure for MANCOVA;
* Use NOUNI in the MODEL statement to suppress univariate outputs;
proc glm data = p7_1;
	class  disability treatment;
	model wratr wrata = treatment disability treatment*disability iq /nouni;
	*manova h = treatment disability / short;
	manova h = _all_ /htype=1 printe;
	* htype=1 indicates Type I SSCP for the H matrix;
run;
quit;

* Assessing the DVs;


* Pooled within group correlatin ;
proc discrim data=p7_1 pcorr;
   class treatment;
   var wratr wrata;
run;

* Calculate correlation between the DVs;
proc corr data = p7_1;
var wratr wrata;
run;

/* Use proc DISCRIM to test for homogeneity of variance-covariance matrix;
proc discrim data = p7_1
 wcov pcov method=normal pool=test;
   class treatment;
   var wratr wrata;
run;

proc discrim data = p7_1
 wcov pcov method=normal pool=test;
   class disability;
   var wratr wrata;
run;

*/


* Univariate F:

* GLM procedure;
proc glm data = p7_1;
	class  disability treatment;
	model wratr = treatment disability treatment*disability;
run;
quit;

* GLM procedure;
proc glm data = p7_1;
	class  disability treatment;
	model wrata = treatment disability treatment*disability;
run;
quit;


* Consider WRAT-R has higher priority;
* Test its importance using ANOVA;

proc glm data = p7_1;
class treatment disability;
model wratr = treatment | disability;
run;
quit;

* Now test importance of WRAR-A taking WRAR-R as covariate;
proc glm data = p7_1;
class treatment disability;
model wrata = wratr treatment | disability /ss1;
run;
quit;



/**********************
Gasoline Data
**********************

* Reading the data into SAS;

filename gas 'T6-10.dat';
data gas;
infile gas;
input fuel repair capital fueltype $;
run;
proc print; run;


proc glm data=gas;
class fueltype;
model fuel repair capital = fueltype;
manova h=_all_;
run;
quit;

/* 
Assessing the DVs;

Priority:
1= capital
2= repair
3= fuel
*/

/* Assess cntribution of "repair" after "capital";

proc glm data = gas;
class fueltype;
model repair = capital fueltype /ss1;
run;
quit;


* Assess contribution of "fuel" after "capital";

proc glm data = gas;
class fueltype;
model fuel = capital fueltype /ss1;
run;
quit;

proc glm data = gas;
class fueltype;
model fuel = capital repair fueltype /ss1;
run;
quit;

*/

/**********************
Pottery Data

We are interested to measure differences in the chemical characteristics of ancient 
pottery found at four kiln sites in Great Britain. The data are 
from Tubb, Parker, and Nickless (1980), as reported in Hand et al. (1994).

For each of the samples of pottery, the percentages of oxides of 
five metals are measured. 

We would like to test if there is any difference among the chemical characteristics
of the potteries as a function of sites

***********************/

data pottery; 
input Site $15. Al Fe Mg Ca Na; 
datalines; 
Llanederyn     14.4 7.00 4.30 0.15 0.51 
Llanederyn     13.8 7.08 3.43 0.12 0.17 
Llanederyn     14.6 7.09 3.88 0.13 0.20 
Llanederyn     11.5 6.37 5.64 0.16 0.14 
Llanederyn     13.8 7.06 5.34 0.20 0.20 
Llanederyn     10.9 6.26 3.47 0.17 0.22 
Llanederyn     10.1 4.26 4.26 0.20 0.18 
Llanederyn     11.6 5.78 5.91 0.18 0.16 
Llanederyn     11.1 5.49 4.52 0.29 0.30 
Llanederyn     13.4 6.92 7.23 0.28 0.20 
Llanederyn     12.4 6.13 5.69 0.22 0.54 
Llanederyn     13.1 6.64 5.51 0.31 0.24 
Llanederyn     12.7 6.69 4.45 0.20 0.22 
Llanederyn     12.5 6.44 3.94 0.22 0.23 
IslandThorns   18.3 1.28 0.77 0.03 0.03 
IslandThorns   15.8 2.39 0.53 0.02 0.04 
IslandThorns   23.0 1.50 0.67 0.01 0.06 
IslandThorns   15.0 1.88 0.98 0.03 0.04 
IslandThorns   20.8 1.51 0.72 0.07 0.10 
IslandThorns   17.3 1.28 0.67 0.03 0.03 
IslandThorns   15.8 2.39 0.83 0.05 0.04 
IslandThorns   19.0 1.50 0.97 0.06 0.06 
IslandThorns   25.0 1.88 0.68 0.04 0.04 
IslandThorns   20.8 1.51 0.92 0.07 0.10 
AshleyRails    17.7 1.12 0.56 0.04 0.06 
AshleyRails    18.3 1.14 0.77 0.06 0.05 
AshleyRails    16.7 0.92 0.53 0.02 0.03 
AshleyRails    14.8 2.74 0.67 0.03 0.15 
AshleyRails    19.1 1.64 0.60 0.10 0.03 
AshleyRails    17.7 1.12 0.56 0.06 0.06 
AshleyRails    18.3 1.14 0.67 0.07 0.15 
AshleyRails    16.7 0.92 0.53 0.01 0.08 
AshleyRails    14.8 2.74 0.67 0.03 0.05 
AshleyRails    19.1 1.64 0.60 0.10 0.03
;
run;

proc print;run;

proc glm data = pottery;
class site;
model Al Fe Mg Ca Na = site;
manova h = _all_;
run;
quit;

proc discrim data = pottery
method=normal pool=test;
class site;
var Al Fe Mg Ca Na ;
run;


* Prioritiae the DVs according the following, and then assess each of them
Fe
Mg
Ca
Al
Na
;

* Assessing Mg after considering fe;
proc glm data = pottery;
class site;
model Mg = fe site /ss1;
run;
quit;

title2 'Assessing Ca after Fe Mg';
proc glm data = pottery;
class site;
model ca = fe mg site /ss1;
run;
quit;

title2 'Assessing Al after Fe';
proc glm data = pottery;
class site;
model al = fe site /ss1;
run;
quit;
 
title2 'Assessing Al after Fe Mg Ca';
proc glm data = pottery;
class site;
model al = fe mg site/ss1;
run;
quit;
 
