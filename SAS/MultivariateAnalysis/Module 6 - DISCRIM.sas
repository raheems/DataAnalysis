/*
* Module 7 - Discriminant Analysis and Classification;
* SAS file: Module 7 - DISCRIM.sas
*/

/* 
Example Data for Discriminant Analysis

Grouping variable: Section (has three levels)
Section1: Section 1
Section2: Section 2
Section3: Section 3 

Predictor variables:
QUIZ: Scores on quiz
MIDTERM: Scores on midterm
FINAL: Scores on final exam
*/

proc format;
value sectionf 1='Section 1' 2='Section 2' 3='Section 3';
run;

data ThreeSec;
input section quiz midterm final;
format section sectionf.;
cards;
1 70 70 80
1 73 67 75
1 59 68 85
1 93 77 76
1 82 80 90
1 90 60 81
1 66 67 88
1 72 72 76
1 69 66 74
1 80 84 67
2 60 82 81
2 66 80 88
2 59 85 93
2 72 75 80
2 82 77 88
2 87 73 80
2 77 95 86
2 69 90 87
2 80 75 92
2 90 76 89
3 90 85 89
3 91 80 89
3 87 92 99
3 77 93 89
3 82 88 87
3 78 87 92
3 80 90 99
3 82 87 89
3 77 79 93
3 83 84 86
;
run;

proc print; run;

* Descriptive Statistics;
proc means data = threesec mean std maxdec=2;
class section;
var quiz midterm final ;
run;


*Linear discriminant analysis;
proc discrim data = threesec pool=yes manova can;
  class section;
  var quiz midterm final;
run;


/* 
Discriminat Analysis after testing for the equality of variance-covariance
matrices using POOL=TEST. Also notice that the SLPOOL option is used to 
set a siginifiance level for the test for V-C matrices;

The intermediate results are saved in a SAS data set called discrim_results;
*/

proc discrim data=threesec pool=test slpool=.15 manova can out=discrim_results;
  class section;
  var quiz midterm final;
run;


* Printing the discrim_results SAS data set;
proc print data=discrim_results;
run;

* Verifying the group centroids;
proc means data=discrim_results;
class section;
var can1 can2;
run;

* Double check if te DISCRIM function scores have 
mean = 0, and std = 1;
proc means data = discrim_results n mean std maxdec=2;
var can1 can2;
run;

* Plotting the two discriminant functions: can2 by can1;
proc gplot data = discrim_results;
plot can2 * can1 = _into_;
run;
quit;



/* Calculating the Centroids;
proc means data = discrim_results;
class section;
var can1 can2;
run;
*/

/* Creating new variable to store the centroids;
data discrim_results2;
set discrim_results;

* Adding Can1 centroids;
if section=1 then can1mean = -1.78 ;
else if section=2 then can1mean= .112;
else can1mean= 1.67;

* Adding can2 centroids;
if section=1 then can2mean = .174 ;
else if section=2 then can2mean= -.385;
else can2mean= .211;
run;
proc print;run;


* Plotting the centroids only;
proc gplot data = discrim_results2;
plot can2mean * can1mean ;
run;
quit;

*/

* leave-one-out crossvalidation;
proc discrim data=threesec pool=test slpool=.05 manova can crossvalidate;
  class section;
  var quiz midterm final;
run;

* Proportional priors to deal with unequal sample sizes;

data ThreeSec2;
input section quiz midterm final;
format section sectionf.;
cards;
1 70 70 80
1 73 67 75
1 93 77 76
1 82 80 90
1 90 60 81
1 66 67 88
1 72 72 76
1 69 66 74
1 80 84 67
2 60 82 81
2 72 75 80
2 82 77 88
2 87 73 80
2 77 95 86
2 69 90 87
2 80 75 92
2 90 76 89
3 90 85 89
3 91 80 89
3 87 92 99
3 77 93 89
3 82 88 87
3 78 87 92
3 80 90 99
3 82 87 89
3 77 79 93
3 83 84 86
;
run;

proc print; run;

* Descriptive Statistics (unequal sample);
title2 'Summary Statistics (Unequal Section Sizes)';
proc means data = threesec2 mean std maxdec=2;
class section;
var quiz midterm final ;
run;

*Linear discriminant analysis (unequal sample);
title2 'LDA Uneq Sample, Equal Priors';
proc discrim data = threesec2 pool=yes manova can;
  class section;
  var quiz midterm final;
 run;

title2 'LDA Uneq Sample, Proportional Priors';
proc discrim data = threesec2 pool=yes manova can;
  class section;
  var quiz midterm final;
  priors proportional;
run;

title;



*** CUSTOM CROSS VALIDATION ***;

***************************************************************
The code below randomly splits the dataset into two parts: one 
  to build the rule (training data), one to validate it on "new" data (test data). 
***************************************************************;

/* 
Randomly split the dataset into training and test samples
Output data set 'split' contains a new variable 'selected'
that indicates whether to include it in the training sample.
There is an example in book, p. 421 that uses uniform random number to 
select the observations;
*/

title 'Example of Set-Aside Method of Validation';
proc surveyselect data=threesec samprate=.75 out=split outall noprint;
   strata section;
run;

proc print data=split;
run;

*** Split the data set according to variable 'selected';
data train test; * defifning two SAS data sets;
	set split;
	if selected=1 then output train;
	else output test;
run;

title2 'Training Sub-Sample';
proc print data=train;
run;


title2 'Testing Sub-Sample';
proc print data=test;
run;


title2 'Linear DA of Training Dataset';
proc discrim data=train pool=yes crossvalidate testdata=test;
  class section;
  var quiz midterm final;
  priors proportional;
  testclass section;
run;

* Custom Cross validation ends ;


/*
* Contrast procedure to find the predictor that separates the groups most;
* SAS GLM contrasting Section 1 with the other two groups;
* Bonferoni correction: alpha/3 = .05/3 = .0167
*/

* Check for Quiz;
proc glm data = threesec;
class section;
model quiz = section midterm final / effectsize alpha=.0167;
contrast 'Section 1 vs Others' section -2 1 1;
run;

* Check for Midterm;
proc glm data = threesec;
class section;
model midterm = section quiz final / effectsize alpha=.0167;
contrast 'Section 1 vs Others' section -2 1 1;
run;

* Check for Final;
proc glm data = threesec;
class section;
model final = section quiz midterm  /effectsize alpha=.0167;
contrast 'Section 1 vs Others' section -2 1 1;
run;



* SAS GLM contrasting Section 2 with the other two combined;
* Bonferoni correction: alpha/3 = .05/3 = .0167;

* Check for Quiz;
proc glm data = threesec;
class section;
model quiz = section midterm final  /effectsize alpha=.0167;
contrast 'Section 2 vs Others' section 1 -2 1;
run;

* Check for Midterm;
proc glm data = threesec;
class section;
model midterm = section quiz final  /effectsize alpha=.0167;
contrast 'Section 2 vs Others' section 1 -2 1;
run;

* Check for Final;
proc glm data = threesec;
class section;
model final = section quiz midterm  /effectsize alpha=.0167;
contrast 'Section 2 vs Others' section 1 -2 1;
run;


* SAS GLM contrasting Section 3 with the other two combined;
* Bonferoni correction: alpha/3 = .05/3 = .0167;

* Check for Quiz;
proc glm data = threesec;
class section;
model quiz = section midterm final /effectsize alpha=.0167;
contrast 'Section 3 vs Others' section 1 1 -2;
run;

* Check for Midterm;
proc glm data = threesec;
class section;
model midterm = section quiz final /effectsize alpha=.0167;
contrast 'Section 3 vs Others' section 1 1 -2;
run;

* Check for Final;
proc glm data = threesec;
class section;
model final = section quiz midterm /effectsize alpha=.0167;
contrast 'Section 3 vs Others' section 1 1 -2;
run;

* End of Contrast Procedure;


*** Use stepwise linear discriminant analysis to search for a good subset of variables ***;
title 'Stepwise DA';
* METHOD = SW (StepWise)
* SLE: significance level for adding (entering) variable;
* SLS: significance level for retaining (staying) variables;

PROC STEPDISC DATA=threesec METHOD=SW SLE=.15 SLS=.10 ;
CLASS section;
VAR quiz midterm final;
RUN;



* leave-one-out crossvalidation;
title2 'Result with all predictors';
proc discrim data=threesec pool=test slpool=.05 manova can crossvalidate;
  class section;
  var quiz midterm final;
run;

* Testing a DA after dropping quiz from consideration;

* leave-one-out crossvalidation;
title2 'Result after dropping QUIZ';
proc discrim data=threesec pool=test slpool=.05 manova can crossvalidate;
  class section;
  var midterm final;
run;
